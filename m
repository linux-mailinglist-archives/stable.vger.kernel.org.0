Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BD328D59
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhCATIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240787AbhCATEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B5D65290;
        Mon,  1 Mar 2021 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619938;
        bh=vAoKC/oQSeRRYOHmfGbX1pUThqpyunmz1aqUmqw9eds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK0YB99XdRg+G40Jzimh3hXatjLxW5E3sffHR2yQj5NC3U0ckOHb7zd4AtuE9iTv1
         IA3Xi3Lpsx3i/HYy/bD1ewfFQU26AdoH8MHq2GNgfCAkUj7LsoLU4oV7pDP/SL8VbA
         1SoiuHbIkU2dWUO0VpJLzHXKW9veBy9sydTz2mgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 636/663] spi: spi-synquacer: fix set_cs handling
Date:   Mon,  1 Mar 2021 17:14:44 +0100
Message-Id: <20210301161213.322348970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

commit 1c9f1750f0305bf605ff22686fc0ac89c06deb28 upstream.

When the slave chip select is deasserted, DMSTOP bit
must be set.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201073109.9036-1-jassisinghbrar@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -490,6 +490,10 @@ static void synquacer_spi_set_cs(struct
 	val &= ~(SYNQUACER_HSSPI_DMPSEL_CS_MASK <<
 		 SYNQUACER_HSSPI_DMPSEL_CS_SHIFT);
 	val |= spi->chip_select << SYNQUACER_HSSPI_DMPSEL_CS_SHIFT;
+
+	if (!enable)
+		val |= SYNQUACER_HSSPI_DMSTOP_STOP;
+
 	writel(val, sspi->regs + SYNQUACER_HSSPI_REG_DMSTART);
 }
 


