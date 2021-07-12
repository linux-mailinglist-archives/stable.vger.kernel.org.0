Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFBD3C51EC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345715AbhGLHoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349095AbhGLHlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B9160FF3;
        Mon, 12 Jul 2021 07:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075529;
        bh=I8wdIfFGfFwk8ZHmzi/UfXFOalguRc+26UAZKv1x+2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WeMU/GBuP6wC03r4SF0WEHABNm8Wm8eZgj+PdksBk12DtFiFtWEQ+U1Z2OnwAEm7
         6XhbPPEhhpbP+oQ39AZ4srHd92qLlrAjz6UA5HRyjNwzrFpXdfbzjnrbtHI4BpRe2H
         yuE3836rYSoD8D5Ib0UfKhaQ9vlSHXV1Qvv6+Vz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Wellbrock <a.wellbrock@mailbox.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 254/800] tpm_tis_spi: add missing SPI device ID entries
Date:   Mon, 12 Jul 2021 08:04:37 +0200
Message-Id: <20210712060949.809603101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit c46ed2281bbe4b84e6f3d4bdfb0e4e9ab813fa9d ]

The SPI core always reports a "MODALIAS=spi:<foo>", even if the device was
registered via OF. This means that this module won't auto-load if a DT has
for example has a node with a compatible "infineon,slb9670" string.

In that case kmod will expect a "MODALIAS=of:N*T*Cinfineon,slb9670" uevent
but instead will get a "MODALIAS=spi:slb9670", which is not present in the
kernel module aliases:

$ modinfo drivers/char/tpm/tpm_tis_spi.ko | grep alias
alias:          of:N*T*Cgoogle,cr50C*
alias:          of:N*T*Cgoogle,cr50
alias:          of:N*T*Ctcg,tpm_tis-spiC*
alias:          of:N*T*Ctcg,tpm_tis-spi
alias:          of:N*T*Cinfineon,slb9670C*
alias:          of:N*T*Cinfineon,slb9670
alias:          of:N*T*Cst,st33htpm-spiC*
alias:          of:N*T*Cst,st33htpm-spi
alias:          spi:cr50
alias:          spi:tpm_tis_spi
alias:          acpi*:SMO0768:*

To workaround this issue, add in the SPI device ID table all the entries
that are present in the OF device ID table.

Reported-by: Alexander Wellbrock <a.wellbrock@mailbox.org>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
index 3856f6ebcb34..de4209003a44 100644
--- a/drivers/char/tpm/tpm_tis_spi_main.c
+++ b/drivers/char/tpm/tpm_tis_spi_main.c
@@ -260,6 +260,8 @@ static int tpm_tis_spi_remove(struct spi_device *dev)
 }
 
 static const struct spi_device_id tpm_tis_spi_id[] = {
+	{ "st33htpm-spi", (unsigned long)tpm_tis_spi_probe },
+	{ "slb9670", (unsigned long)tpm_tis_spi_probe },
 	{ "tpm_tis_spi", (unsigned long)tpm_tis_spi_probe },
 	{ "cr50", (unsigned long)cr50_spi_probe },
 	{}
-- 
2.30.2



