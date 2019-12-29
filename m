Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C342E12C91B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbfL2SAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732584AbfL2R5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42326206DB;
        Sun, 29 Dec 2019 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642263;
        bh=G10bv3DWKOZiiqCp+6xtRZZKm6/KEpfUH1lOVBOkzJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vijVtsiuJ5awAfQ/qXlcW72fjAsVKOoEzpbMQrRB4cGTFXS78InOj/QbP5FUyW5z6
         JehV6ojmTvPaTG2KhYriVdVUmUtRIgaHlc/8q/0Ck6EyrE3JWA9S/j1+ViRJ7AzxVq
         FjAXeIv+tSY3X768L8JCUuAr/r2RdVIzKP8bEbSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 409/434] clk: imx: pll14xx: fix clk_pll14xx_wait_lock
Date:   Sun, 29 Dec 2019 18:27:42 +0100
Message-Id: <20191229172729.867336163@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit c3a5fd15ed0c1494435e4e35fbee734ae46b5073 upstream.

The usage of readl_poll_timeout is wrong, the 3rd parameter(cond)
should be "val & LOCK_STATUS" not "val & LOCK_TIMEOUT_US",
It is not check whether the pll locked, LOCK_STATUS reflects the mask,
not LOCK_TIMEOUT_US.

Fixes: 8646d4dcc7fb ("clk: imx: Add PLLs driver for imx8mm soc")
Cc: <stable@vger.kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-pll14xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -153,7 +153,7 @@ static int clk_pll14xx_wait_lock(struct
 {
 	u32 val;
 
-	return readl_poll_timeout(pll->base, val, val & LOCK_TIMEOUT_US, 0,
+	return readl_poll_timeout(pll->base, val, val & LOCK_STATUS, 0,
 			LOCK_TIMEOUT_US);
 }
 


