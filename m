Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74179330E35
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhCHMfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhCHMfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50C2E651FE;
        Mon,  8 Mar 2021 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206944;
        bh=ocRSRrg9FOC9ipj2VM+n3s9teUbEqYl7gnawnchYBAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVboKjMFDr03wzFqmb0tbYKJMcHFmuP0xsR4XUhJ0WKNCac9us9RntrLdl/PZFgV2
         n/XsO31XoCBHPHklgj1e3de9/ZdfspCLHO3MTO2HuDruC2tg5IytRRjIDHGMWZL5Xh
         tEj8D4lydXL08w3ZqpINSxgcQh4pzqCy0Im2UF98=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Laurent Bigonville <bigon@debian.org>,
        Lukasz Majczak <lma@semihalf.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.11 07/44] tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()
Date:   Mon,  8 Mar 2021 13:34:45 +0100
Message-Id: <20210308122718.946636024@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jarkko Sakkinen <jarkko@kernel.org>

commit a5665ec2affdba21bff3b0d4d3aed83b3951e8ff upstream.

This is shown with Samsung Chromebook Pro (Caroline) with TPM 1.2
(SLB 9670):

[    4.324298] TPM returned invalid status
[    4.324806] WARNING: CPU: 2 PID: 1 at drivers/char/tpm/tpm_tis_core.c:275 tpm_tis_status+0x86/0x8f

Background
==========

TCG PC Client Platform TPM Profile (PTP) Specification, paragraph 6.1 FIFO
Interface Locality Usage per Register, Table 39 Register Behavior Based on
Locality Setting for FIFO - a read attempt to TPM_STS_x Registers returns
0xFF in case of lack of locality.

The fix
=======

Decorate tpm_get_timeouts() with request_locality() and release_locality().

Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Laurent Bigonville <bigon@debian.org>
Cc: stable@vger.kernel.org
Reported-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1029,11 +1029,21 @@ int tpm_tis_core_init(struct device *dev
 	init_waitqueue_head(&priv->read_queue);
 	init_waitqueue_head(&priv->int_queue);
 	if (irq != -1) {
-		/* Before doing irq testing issue a command to the TPM in polling mode
+		/*
+		 * Before doing irq testing issue a command to the TPM in polling mode
 		 * to make sure it works. May as well use that command to set the
 		 * proper timeouts for the driver.
 		 */
-		if (tpm_get_timeouts(chip)) {
+
+		rc = request_locality(chip, 0);
+		if (rc < 0)
+			goto out_err;
+
+		rc = tpm_get_timeouts(chip);
+
+		release_locality(chip, 0);
+
+		if (rc) {
 			dev_err(dev, "Could not get TPM timeouts and durations\n");
 			rc = -ENODEV;
 			goto out_err;


