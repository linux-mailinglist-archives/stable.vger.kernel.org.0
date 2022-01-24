Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E194A499117
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351989AbiAXUJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352290AbiAXUDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD7BB80FA1;
        Mon, 24 Jan 2022 20:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED24C340E5;
        Mon, 24 Jan 2022 20:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054610;
        bh=fKi7ZwPG8n0+BGVYMxk00IA52PoG1YjyUx5UZx1Vb/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXbm1vNFKuVxYVWc9sVbQQitjpL9vgq8DHgcCkIVWsXi4l3L+RRZSA+LSGTPYOH1+
         itv4ZC6BtDEEymd18uCfk7TpiErh2DXdcHtjql/RVlZJNHz0gjB9UEFnV7gnNvz1Ac
         q4K5YLqwlrzlS5Lh8zjfvMNmmoIv3yxu1J0Ys9JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Williams <patrick@stwcx.xyz>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 445/563] tpm: fix NPE on probe for missing device
Date:   Mon, 24 Jan 2022 19:43:30 +0100
Message-Id: <20220124184039.846941886@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Williams <patrick@stwcx.xyz>

commit 84cc69589700b90a4c8d27b481a51fce8cca6051 upstream.

When using the tpm_tis-spi driver on a system missing the physical TPM,
a null pointer exception was observed.

    [    0.938677] Unable to handle kernel NULL pointer dereference at virtual address 00000004
    [    0.939020] pgd = 10c753cb
    [    0.939237] [00000004] *pgd=00000000
    [    0.939808] Internal error: Oops: 5 [#1] SMP ARM
    [    0.940157] CPU: 0 PID: 48 Comm: kworker/u4:1 Not tainted 5.15.10-dd1e40c #1
    [    0.940364] Hardware name: Generic DT based system
    [    0.940601] Workqueue: events_unbound async_run_entry_fn
    [    0.941048] PC is at tpm_tis_remove+0x28/0xb4
    [    0.941196] LR is at tpm_tis_core_init+0x170/0x6ac

This is due to an attempt in 'tpm_tis_remove' to use the drvdata, which
was not initialized in 'tpm_tis_core_init' prior to the first error.

Move the initialization of drvdata earlier so 'tpm_tis_remove' has
access to it.

Signed-off-by: Patrick Williams <patrick@stwcx.xyz>
Fixes: 79ca6f74dae0 ("tpm: fix Atmel TPM crash caused by too frequent queries")
Cc: stable@vger.kernel.org
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -950,6 +950,8 @@ int tpm_tis_core_init(struct device *dev
 	priv->timeout_max = TPM_TIMEOUT_USECS_MAX;
 	priv->phy_ops = phy_ops;
 
+	dev_set_drvdata(&chip->dev, priv);
+
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
 		return rc;
@@ -962,8 +964,6 @@ int tpm_tis_core_init(struct device *dev
 		priv->timeout_max = TIS_TIMEOUT_MAX_ATML;
 	}
 
-	dev_set_drvdata(&chip->dev, priv);
-
 	if (is_bsw()) {
 		priv->ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
 					ILB_REMAP_SIZE);


