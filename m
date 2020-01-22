Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69913145524
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgAVNTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgAVNTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:19 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E61162467F;
        Wed, 22 Jan 2020 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699158;
        bh=MFlrl2mAvjcriUlNfYGIlpC6736k2fCgkJURBDnWGHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrGdV6J8NpkrFiWSmjsZUYqcU35ycTmPPnnayACp+u3wi3Iu0ktqF+7fzLOJ13ngX
         lQe+GiOTfKo91JfCqKmjX8UULdEB9Zi81SUlA4XBgSqqZxiti60IVExwLHkbS4zJbQ
         rAUm4Uwd5zzVCUgRivc3St6CwbP7RDi7+OvBN+hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 058/222] mtd: rawnand: gpmi: Fix suspend/resume problem
Date:   Wed, 22 Jan 2020 10:27:24 +0100
Message-Id: <20200122092837.865067935@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

commit 5bc6bb603b4d0c8802af75e4932232683ab2d761 upstream.

On system resume, the gpmi clock must be enabled before accessing gpmi
block.  Without this, resume causes something like

[  661.348790] gpmi_reset_block(5cbb0f7e): module reset timeout
[  661.348889] gpmi-nand 1806000.gpmi-nand: Error setting GPMI : -110
[  661.348928] PM: dpm_run_callback(): platform_pm_resume+0x0/0x44 returns -110
[  661.348961] PM: Device 1806000.gpmi-nand failed to resume: error -110

Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
Acked-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -148,6 +148,10 @@ static int gpmi_init(struct gpmi_nand_da
 	struct resources *r = &this->resources;
 	int ret;
 
+	ret = pm_runtime_get_sync(this->dev);
+	if (ret < 0)
+		return ret;
+
 	ret = gpmi_reset_block(r->gpmi_regs, false);
 	if (ret)
 		goto err_out;
@@ -179,8 +183,9 @@ static int gpmi_init(struct gpmi_nand_da
 	 */
 	writel(BM_GPMI_CTRL1_DECOUPLE_CS, r->gpmi_regs + HW_GPMI_CTRL1_SET);
 
-	return 0;
 err_out:
+	pm_runtime_mark_last_busy(this->dev);
+	pm_runtime_put_autosuspend(this->dev);
 	return ret;
 }
 


