Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A7BCA7E1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392582AbfJCQtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393086AbfJCQti (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 754892070B;
        Thu,  3 Oct 2019 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121378;
        bh=4RZYoUsuUQLZ4s568q0GUzU5T/LBcXRptdcGVSEtYSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk2xv3Ux/7o26KLdb+sCj17HkxGJNPqMh+JgURb+strcHxH8SaB5aJKJeRb5c5wyP
         jnhrCIOjUDLbzR0c5DsCK2cLnhQbjJSC/AiBof6UpdH37eBwH5idBKUp58nd1kY3Dg
         t9mCLAF92XSMxXdXc93i/t09rustW1Wx2zw5tx6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.3 255/344] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
Date:   Thu,  3 Oct 2019 17:53:40 +0200
Message-Id: <20191003154605.647615518@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit 1ea32c83c699df32689d329b2415796b7bfc2f6e upstream.

The tpm_tis_core has to set the TPM_CHIP_FLAG_IRQ before probing for
interrupts since there is no other place in the code that would set
it.

Cc: linux-stable@vger.kernel.org
Fixes: 570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -981,6 +981,7 @@ int tpm_tis_core_init(struct device *dev
 		}
 
 		tpm_chip_start(chip);
+		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);


