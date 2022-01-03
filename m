Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B44835E5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiACRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiACRaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE0CC061785;
        Mon,  3 Jan 2022 09:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6C1611A3;
        Mon,  3 Jan 2022 17:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F43C36AED;
        Mon,  3 Jan 2022 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231020;
        bh=FbIKzz13KQM/5QEXBIQ84ND/042tlnZqxVNTfkT/m5U=;
        h=From:To:Cc:Subject:Date:From;
        b=DL59G1Z6w2eh7fOGwQDKIFhP0eJ0iyJ/dxbgsOwqbRWDi+XwuJaUcWi3WY17bVgHL
         8njJIiur0YX5wWp5oH6iubKM/SHGBRmDsfn/ue66XlZSZFLjeRmbfqYSnYSTNZrD5l
         nxgpjtkuQgRawSkD3pQzq4MdwixA4BLFprQfQpr4jMTlTuqU+RjVX37jaKSiPk/zd2
         Pg2zUOHwxjSMHBzm/A+gOtNHnvngVj2Ml0cA66+I4Ad4l9oYcdo0leSRtelVEm4x9s
         mG0o+J77+1OoxsaXLpxXOPPIYbMxFdPDvDiQ7r21PPU1XwjdGPG4l6sRlosQtIol4R
         A/G17W+Oxw1Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, matthias.bgg@gmail.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 1/6] usb: mtu3: fix interval value for intr and isoc
Date:   Mon,  3 Jan 2022 12:30:13 -0500
Message-Id: <20220103173018.1613394-1-sashal@kernel.org>
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
index 619c4598e64ea..63f82026cca39 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -85,7 +85,7 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
 		if (usb_endpoint_xfer_int(desc) ||
 				usb_endpoint_xfer_isoc(desc)) {
 			interval = desc->bInterval;
-			interval = clamp_val(interval, 1, 16) - 1;
+			interval = clamp_val(interval, 1, 16);
 			if (usb_endpoint_xfer_isoc(desc) && comp_desc)
 				mult = comp_desc->bmAttributes;
 		}
@@ -97,7 +97,7 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
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

