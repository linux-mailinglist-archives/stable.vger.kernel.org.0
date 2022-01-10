Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C014891C0
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240831AbiAJHgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbiAJHca (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84236C029818;
        Sun,  9 Jan 2022 23:28:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2603D611BC;
        Mon, 10 Jan 2022 07:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11199C36AE9;
        Mon, 10 Jan 2022 07:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799729;
        bh=Nh+ZX6DpgLsEZsAZkNl4PXQbvAL4hXHFEs5ivU3Zt/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7NFG2ZdbpVKaQJc9aUHLVI1VSLnvoABK3Zel7OUHJQpf7jII1p38twIVG25gYNt1
         dF9NAhZ59Og5QSI9UJfb/RHs0en6nIItwPQXXN79Ta0b5p5m3eAGd3IUT7x31JKw/9
         poTL45CeeLXmDrbjK+UNvP7AJYUcg8JwDpCvhjdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/34] usb: mtu3: fix interval value for intr and isoc
Date:   Mon, 10 Jan 2022 08:23:24 +0100
Message-Id: <20220110071816.656375417@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 253c8b71d3c49..061da9b82b967 100644
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



