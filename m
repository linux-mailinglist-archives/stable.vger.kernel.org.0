Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34053483605
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiACRbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbiACRau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:30:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E92C061376;
        Mon,  3 Jan 2022 09:30:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C65B81042;
        Mon,  3 Jan 2022 17:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD953C36AEE;
        Mon,  3 Jan 2022 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231031;
        bh=hGPKFm/39euNVFMinPd0zZsLdEwQkPaR6fJ4viZLL/k=;
        h=From:To:Cc:Subject:Date:From;
        b=P3+QWd7Mzyey2/eUrZXwuyvJbMvC4rOaiO0KySdlrFwJ0pQysS87wMeqTsyKeRQGp
         BSz5lfMPJbjUH/G7k19FLvQz1PQOba85sCPwc1HRCFDa/Guf58ak9PEH+wCOxu8QQb
         lUUiO9WZMYi+EADwN5sg4l704tEDGkIxYzsbBSqQ/KJTAtk+aOLG1FOEzz5NpGZyHS
         z1MU1jwtFRMXRMa/fhNrxm53rNHMQvnryobgSF+R+o0Sz5qMIcBTSJOVbAaDLHdwP+
         gyvkGAinpCWpo94+bXg9V63/yvzbd0Rq4XNA2bvwpYUG0r4dAsktkzl5scf371zqu/
         +j1mBg1hGRazg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, matthias.bgg@gmail.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 1/5] usb: mtu3: fix interval value for intr and isoc
Date:   Mon,  3 Jan 2022 12:30:25 -0500
Message-Id: <20220103173029.1613474-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit e3d4621c22f90c33321ae6a6baab60cdb8e5a77c ]

Use the Interval value from isoc/intr endpoint descriptor, no need
minus one. The original code doesn't cause transfer error for
normal cases, but it may have side effect with respond time of ERDY
or tPingTimeout.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211218095749.6250-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
index 270721cf229f7..c5c864a02a763 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -82,7 +82,7 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
 		if (usb_endpoint_xfer_int(desc) ||
 				usb_endpoint_xfer_isoc(desc)) {
 			interval = desc->bInterval;
-			interval = clamp_val(interval, 1, 16) - 1;
+			interval = clamp_val(interval, 1, 16);
 			if (usb_endpoint_xfer_isoc(desc) && comp_desc)
 				mult = comp_desc->bmAttributes;
 		}
@@ -94,7 +94,7 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
 		if (usb_endpoint_xfer_isoc(desc) ||
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
-			interval = clamp_val(interval, 1, 16) - 1;
+			interval = clamp_val(interval, 1, 16);
 			mult = usb_endpoint_maxp_mult(desc) - 1;
 		}
 		break;
-- 
2.34.1

