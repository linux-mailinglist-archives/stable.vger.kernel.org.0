Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AEA11B4E0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbfLKPWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732450AbfLKPWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6302073D;
        Wed, 11 Dec 2019 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077771;
        bh=S/M8CtlQbwpUthGYfY/88gTEmA4TU9Iazq+kr6gyotU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJTKe0HUbQcnsvt9T3hcygiKLdPVbyhgueM0u1PmLyoeGP9AeGDek+YQmx/FZOTaA
         GZzc3jEHv/nMYS7505T1u3MLMuNyHygLyOhH5wwbf0d0m7rIwyxoqAejRw20HuFQ9r
         2Bt7BhUQpllOy+XEAaXXcL6+1zfUJsokmGd7xEnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/243] media: cxd2880-spi: fix probe when dvb_attach fails
Date:   Wed, 11 Dec 2019 16:05:27 +0100
Message-Id: <20191211150350.308111175@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 458ffce1cb46e46e3cec48b625ed142250475708 ]

When dvb_attach fails, probe returns 0, and remove crashes afterwards.
This patch sets the return value to -ENODEV when attach fails.

Fixes: bd24fcddf6b8 ("media: cxd2880-spi: Add support for CXD2880 SPI interface")

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/spi/cxd2880-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 11ce5101e19f6..c43730977f53c 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -536,6 +536,7 @@ cxd2880_spi_probe(struct spi_device *spi)
 
 	if (!dvb_attach(cxd2880_attach, &dvb_spi->dvb_fe, &config)) {
 		pr_err("cxd2880_attach failed\n");
+		ret = -ENODEV;
 		goto fail_attach;
 	}
 
-- 
2.20.1



