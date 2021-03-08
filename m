Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72190330DAA
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCHMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhCHMbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A82D7651C3;
        Mon,  8 Mar 2021 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206685;
        bh=P75V3XSQXANXinS3xgTs9HUSnTtU6oownB/M2IpmAH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjRzHi6HyKJ3/h3UqJcZDLZvjjpFNB5lQD8KAO6lbus6gD2qbN0XEUK5lDjTcCOH0
         s26kIZyrVzCkcTBf3OzO57fNCoBC+plIZjRQJizo6+CyhVShrVea+d32ClEi0qeTtg
         PW6Y598KUtXLlbPczpSjJfnu9FCu0X2Bm5AlypcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Laurent Bigonville <bigon@debian.org>,
        Lukasz Majczak <lma@semihalf.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 02/22] tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()
Date:   Mon,  8 Mar 2021 13:30:19 +0100
Message-Id: <20210308122714.516317331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -939,11 +939,21 @@ int tpm_tis_core_init(struct device *dev
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


