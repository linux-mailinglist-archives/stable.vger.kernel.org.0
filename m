Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2100828A8A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbfEWTQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389144AbfEWTQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:16:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A2FF21841;
        Thu, 23 May 2019 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638976;
        bh=5UCojV3+1l9pwyt7QHyOjN9adHUxg59F+wBeuWKbW/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEHcYYHtBwQDsR2vLEHPj8igyvqFVbSL3MavPuXyoKEekIjr3IcmZiz45YRke6IZp
         DM6xwasRZMkDxY4BzwHBQzqwgqKUmY+Jsp7nfxhxYeWZrUAWP0ivG+aRVZW/NaREOj
         /Ude+vjrQoYhqHBslyxeCP43iBcBPeV6MclsSxZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 4.19 033/114] phy: ti-pipe3: fix missing bit-wise or operator when assigning val
Date:   Thu, 23 May 2019 21:05:32 +0200
Message-Id: <20190523181734.791120488@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit e6577cb5103b7ca7c0204c0c86ef4af8aa6288f6 upstream.

There seems to be a missing bit-wise or operator when setting val,
fix this by adding it in.

Fixes: 2796ceb0c18a ("phy: ti-pipe3: Update pcie phy settings")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/ti/phy-ti-pipe3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/ti/phy-ti-pipe3.c
+++ b/drivers/phy/ti/phy-ti-pipe3.c
@@ -303,7 +303,7 @@ static void ti_pipe3_calibrate(struct ti
 
 	val = ti_pipe3_readl(phy->phy_rx, PCIEPHYRX_ANA_PROGRAMMABILITY);
 	val &= ~(INTERFACE_MASK | LOSD_MASK | MEM_PLLDIV);
-	val = (0x1 << INTERFACE_SHIFT | 0xA << LOSD_SHIFT);
+	val |= (0x1 << INTERFACE_SHIFT | 0xA << LOSD_SHIFT);
 	ti_pipe3_writel(phy->phy_rx, PCIEPHYRX_ANA_PROGRAMMABILITY, val);
 
 	val = ti_pipe3_readl(phy->phy_rx, PCIEPHYRX_DIGITAL_MODES);


