Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDE71BCA05
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbgD1So4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgD1Soy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BA720730;
        Tue, 28 Apr 2020 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099493;
        bh=aXQgl0ZNfrWXCQb6+w320BVyC8lkIiecHEU16PpLw9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHc5ISelz6MqifANtVCbC0iuz2Cx/CW8CGV+MSEzs/ihgTV/lKG64NSjUYBFgV0UY
         mvrj0arbhEWW56DdWvlvFXp/ZCEgY0pXD6Cw9nhjgA7mjQmKUUahL2YmlYWvcSPzqf
         MqBNWHxIb2YjSfF9oJkAe74YZm+LTJW2IZ939sHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 144/168] staging: vt6656: Power save stop wake_up_count wrap around.
Date:   Tue, 28 Apr 2020 20:25:18 +0200
Message-Id: <20200428182249.874550070@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ea81c3486442f4643fc9825a2bb1b430b829bccd upstream.

conf.listen_interval can sometimes be zero causing wake_up_count
to wrap around up to many beacons too late causing
CTRL-EVENT-BEACON-LOSS as in.

wpa_supplicant[795]: message repeated 45 times: [..CTRL-EVENT-BEACON-LOSS ]

Fixes: 43c93d9bf5e2 ("staging: vt6656: implement power saving code.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/fce47bb5-7ca6-7671-5094-5c6107302f2b@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/int.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -145,7 +145,8 @@ void vnt_int_process_data(struct vnt_pri
 				priv->wake_up_count =
 					priv->hw->conf.listen_interval;
 
-			--priv->wake_up_count;
+			if (priv->wake_up_count)
+				--priv->wake_up_count;
 
 			/* Turn on wake up to listen next beacon */
 			if (priv->wake_up_count == 1)


