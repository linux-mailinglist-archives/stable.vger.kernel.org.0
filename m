Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EF518B435
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCSNHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgCSNHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A3B20842;
        Thu, 19 Mar 2020 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623260;
        bh=LPP5v4SZNWrBxVbQHTXg15znv7K1qgCA0w3y/2YNjgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFZGXipBFIm1C6CA4uua7usvrXBEDH4gmLBLhCVuxpY8uCcDSBkQINdpy2qi8O7KF
         kY/3IemTwCJGqv77j3ZF8ofGhhhuL4qBv8vXQxIEv6TnMvfQnKEsAPuEA6dBvaCgsp
         fbBDHBFj4EmXGzbTw0j+LRQEFmuyO+0GR1p7Ts/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 42/93] batman-adv: Fix unexpected free of bcast_own on add_if error
Date:   Thu, 19 Mar 2020 13:59:46 +0100
Message-Id: <20200319123938.445830048@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -155,10 +155,8 @@ static int batadv_iv_ogm_orig_add_if(str
 	orig_node->bat_iv.bcast_own = data_ptr;
 
 	data_ptr = kmalloc_array(max_if_num, sizeof(u8), GFP_ATOMIC);
-	if (!data_ptr) {
-		kfree(orig_node->bat_iv.bcast_own);
+	if (!data_ptr)
 		goto unlock;
-	}
 
 	memcpy(data_ptr, orig_node->bat_iv.bcast_own_sum,
 	       (max_if_num - 1) * sizeof(u8));


