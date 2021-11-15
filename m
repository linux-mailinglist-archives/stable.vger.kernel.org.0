Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563A74513EA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348747AbhKOT7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344118AbhKOTX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C6B86362E;
        Mon, 15 Nov 2021 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002338;
        bh=SCN5aa6sZco6dzL9HU0MMi0W+4jJJx1rWX7LrT34Wwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3PsAty2MADuZpF3eLm7FoM2r45cO+kv0cyBm5ed+qFbH0jaLiVmuvjgbiq0vyHcw
         pV1SbQH6KfedXzVj93ON9HesowDTzmmYMUIOGX8cdUEwiiCvk4RmehRJh9iN/GLSa9
         Mmb1DDEAauTScVXdK1XEiN22Y7f6Il2IPPcLDezw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/917] tpm_tis_spi: Add missing SPI ID
Date:   Mon, 15 Nov 2021 18:00:16 +0100
Message-Id: <20211115165446.433197920@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 7eba41fe8c7bb01ff3d4b757bd622375792bc720 ]

In commit c46ed2281bbe ("tpm_tis_spi: add missing SPI device ID entries")
we added SPI IDs for all the DT aliases to handle the fact that we always
use SPI modaliases to load modules even when probed via DT however the
mentioned commit missed that the SPI and OF device ID entries did not
match and were different and so DT nodes with compatible
"tcg,tpm_tis-spi" will not match.  Add an extra ID for tpm_tis-spi
rather than just fix the existing one since what's currently there is
going to be better for anyone actually using SPI IDs to instantiate.

Fixes: c46ed2281bbe ("tpm_tis_spi: add missing SPI device ID entries")
Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
index 54584b4b00d19..aaa59a00eeaef 100644
--- a/drivers/char/tpm/tpm_tis_spi_main.c
+++ b/drivers/char/tpm/tpm_tis_spi_main.c
@@ -267,6 +267,7 @@ static const struct spi_device_id tpm_tis_spi_id[] = {
 	{ "st33htpm-spi", (unsigned long)tpm_tis_spi_probe },
 	{ "slb9670", (unsigned long)tpm_tis_spi_probe },
 	{ "tpm_tis_spi", (unsigned long)tpm_tis_spi_probe },
+	{ "tpm_tis-spi", (unsigned long)tpm_tis_spi_probe },
 	{ "cr50", (unsigned long)cr50_spi_probe },
 	{}
 };
-- 
2.33.0



