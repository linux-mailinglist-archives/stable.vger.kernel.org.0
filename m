Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D04B37C188
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhELPBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231887AbhELO7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780446144A;
        Wed, 12 May 2021 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831391;
        bh=Cv6LI9wlQSoSUVWhBCyuz4fJ+z81h80e01Lbp8ns4cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJmTdaDYpM6nA9H5wyuX0MWKrQmSH8MdN13WQ1HVWjzAtVLWDEyvPIyoV4lTosUQ/
         HjC8PCI6BY8DuTPrwmbbirojVFSbau3Cniz2FwD67vM38XPD65KCdnWDnycQMvonLU
         fLu+737uwW9H/h9qhrX7HycqbLoKaI0Ln+F94KJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/244] USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
Date:   Wed, 12 May 2021 16:47:52 +0200
Message-Id: <20210512144746.265274944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2e3d055bf27d70204cae349335a62a4f9b7c165a ]

IS_ERR() and PTR_ERR() use wrong pointer, it should be
udc->virt_addr, fix it.

Fixes: 1b9f35adb0ff ("usb: gadget: udc: Add Synopsys UDC Platform driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210330130159.1051979-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/snps_udc_plat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/snps_udc_plat.c b/drivers/usb/gadget/udc/snps_udc_plat.c
index 32f1d3e90c26..99805d60a7ab 100644
--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -114,8 +114,8 @@ static int udc_plat_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	udc->virt_addr = devm_ioremap_resource(dev, res);
-	if (IS_ERR(udc->regs))
-		return PTR_ERR(udc->regs);
+	if (IS_ERR(udc->virt_addr))
+		return PTR_ERR(udc->virt_addr);
 
 	/* udc csr registers base */
 	udc->csr = udc->virt_addr + UDC_CSR_ADDR;
-- 
2.30.2



