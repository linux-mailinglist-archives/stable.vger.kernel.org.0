Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF3480063
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbhL0Pp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbhL0Pod (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278CAC08E855;
        Mon, 27 Dec 2021 07:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2FE5B810C3;
        Mon, 27 Dec 2021 15:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E2C36AEA;
        Mon, 27 Dec 2021 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619716;
        bh=Ak0LR/s7Jvnu58KgjJVcfQyjSnc1pLx1bV2DZ3058Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSK9EQPiMAHBTcxIrv6/1k5ZeR6dXLriLbdvvZK2fLoosuCFqCWNAGLqAKYKaQX/x
         dVe2z6QfXjnnibBPhUawwkuQODgooLOYytzRV2Op6Af3S2ofaSWkwui0gBVecFrssJ
         3wY/LFCUyYBuH+pKl9lDXAiai0u/sDhzCBY8Vd0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/128] asix: fix wrong return value in asix_check_host_enable()
Date:   Mon, 27 Dec 2021 16:30:18 +0100
Message-Id: <20211227151332.958422492@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit d1652b70d07cc3eed96210c876c4879e1655f20e ]

If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
asix_check_host_enable(), which is logically wrong. Fix it by returning
-ETIMEDOUT explicitly if we have exceeded 30 iterations

Also, replaced 30 with #define as suggested by Andrew

Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/ecd3470ce6c2d5697ac635d0d3b14a47defb4acb.1640117288.git.paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index b80c2dcfc9084..9aa92076500af 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -9,6 +9,8 @@
 
 #include "asix.h"
 
+#define AX_HOST_EN_RETRIES	30
+
 int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		  u16 size, void *data, int in_pm)
 {
@@ -68,7 +70,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 	int i, ret;
 	u8 smsr;
 
-	for (i = 0; i < 30; ++i) {
+	for (i = 0; i < AX_HOST_EN_RETRIES; ++i) {
 		ret = asix_set_sw_mii(dev, in_pm);
 		if (ret == -ENODEV || ret == -ETIMEDOUT)
 			break;
@@ -83,7 +85,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 			break;
 	}
 
-	return ret;
+	return i >= AX_HOST_EN_RETRIES ? -ETIMEDOUT : ret;
 }
 
 static void reset_asix_rx_fixup_info(struct asix_rx_fixup_info *rx)
-- 
2.34.1



