Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099FD13A4DB
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgANKDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgANKDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862FA24672;
        Tue, 14 Jan 2020 10:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996185;
        bh=y2ZNNeksxz04GyUAfYwbbjFlxdCvRnMbvISORCrrBYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmIQujExr1UeHHDY2H/BO14GxstEcVUQ5zoH1iKUuZeYKMy2xt9lFsTfUjJY9A3Dm
         bq8t0KyM6BwXWT6G9xiixgRV8dC125zeHrfz7NeNBwBFG5qEkNNmAmeOOtwWNDkWXm
         XiAwL1mfHAUHH/rV44WjfRPPyOPG4/nyOX8fVPj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoping Zhou <xiaoping.zhou@intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 10/78] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts"
Date:   Tue, 14 Jan 2020 11:00:44 +0100
Message-Id: <20200114094353.967524292@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit dda8b2af395b2ed508e2ef314ae32e122841b447 upstream.

There has been a bunch of reports (one from kernel bugzilla linked)
reporting that when this commit is applied it causes on some machines
boot freezes.

Unfortunately hardware where this commit causes a failure is not widely
available (only one I'm aware is Lenovo T490), which means we cannot
predict yet how long it will take to properly fix tpm_tis interrupt
probing.

Thus, the least worst short term action is to revert the code to the
state before this commit. In long term we need fix the tpm_tis probing
code to work on machines that Stefan's fix was supposed to fix.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205935
Fixes: 1ea32c83c699 ("tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts")
Cc: stable@vger.kernel.org
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -981,7 +981,6 @@ int tpm_tis_core_init(struct device *dev
 		}
 
 		tpm_chip_start(chip);
-		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);


