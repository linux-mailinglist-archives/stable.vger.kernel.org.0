Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433CCCA8EB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404190AbfJCQeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404166AbfJCQe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 570C22133F;
        Thu,  3 Oct 2019 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120467;
        bh=A/fluV88cdCtFiDoTo2oHXuBD3ua79iA+SvIybnQ9+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIPpuooplxDAHMa2j98h++LGteMflphKTh4YV65o3CmNDfmsG/o7LQ+9Hj6V3UqjP
         ECPCvDpCzgEWaO2tFrmj/Ntws6Sk6ugf7C4xAjSoXnPxsGNRCYw4K1TPUklgQNqbxT
         JYn8PT2gw0LGIFpXXLCaz7KXOQ1SjaZtXoZ8Yrng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.2 232/313] tpm_tis_core: Turn on the TPM before probing IRQs
Date:   Thu,  3 Oct 2019 17:53:30 +0200
Message-Id: <20191003154555.839747700@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit 5b359c7c43727e624eac3efc7ad21bd2defea161 upstream.

The interrupt probing sequence in tpm_tis_core cannot obviously run with
the TPM power gated. Power on the TPM with tpm_chip_start() before
probing IRQ's. Turn it off once the probing is complete.

Cc: linux-stable@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -980,6 +980,7 @@ int tpm_tis_core_init(struct device *dev
 			goto out_err;
 		}
 
+		tpm_chip_start(chip);
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
@@ -989,6 +990,7 @@ int tpm_tis_core_init(struct device *dev
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}
+		tpm_chip_stop(chip);
 	}
 
 	rc = tpm_chip_register(chip);


