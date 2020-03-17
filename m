Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19161891F4
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQX1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:48 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQX1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXs+zZcwYo4OTMS2ydB/XSB5ocQ6tl+KhxQiZjUusLY=;
        b=sNDEjlSR+AxjoRJY1APzB9ZRTLSFlQuKl+nWNt1UeeEhdliYtJGllVImVW7+QsuTVmZq0P
        i4uMenVZhChy88Fffy0pP5/IKEVO4aqZahkhefznHghfHZ9Kp+mdK0bHAYGechPtz5mux/
        F00i0fzcZdaPGphahDTlTWUP6NqVVCk=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 05/48] batman-adv: Fix unexpected free of bcast_own on add_if error
Date:   Wed, 18 Mar 2020 00:26:51 +0100
Message-Id: <20200317232734.6127-6-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f7dcdf5fdbe8fec7670d8f65a5db595c98e0ecab upstream.

The function batadv_iv_ogm_orig_add_if allocates new buffers for bcast_own
and bcast_own_sum. It is expected that these buffers are unchanged in case
either bcast_own or bcast_own_sum couldn't be resized.

But the error handling of this function frees the already resized buffer
for bcast_own when the allocation of the new bcast_own_sum buffer failed.
This will lead to an invalid memory access when some code will try to
access bcast_own.

Instead the resized new bcast_own buffer has to be kept. This will not lead
to problems because the size of the buffer was only increased and therefore
no user of the buffer will try to access bytes outside of the new buffer.

Fixes: d0015fdd3d2c ("batman-adv: provide orig_node routing API")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/bat_iv_ogm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index aa94b4ec766a..cea4e321f588 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -155,10 +155,8 @@ static int batadv_iv_ogm_orig_add_if(struct batadv_orig_node *orig_node,
 	orig_node->bat_iv.bcast_own = data_ptr;
 
 	data_ptr = kmalloc_array(max_if_num, sizeof(u8), GFP_ATOMIC);
-	if (!data_ptr) {
-		kfree(orig_node->bat_iv.bcast_own);
+	if (!data_ptr)
 		goto unlock;
-	}
 
 	memcpy(data_ptr, orig_node->bat_iv.bcast_own_sum,
 	       (max_if_num - 1) * sizeof(u8));
-- 
2.20.1

