Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68571330DA0
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCHMa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCHMa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:30:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C568A651CC;
        Mon,  8 Mar 2021 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206656;
        bh=J8VyNRxt6mivqprZ4XEEceQSfGynntp3tnWDfFs+Hd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZVPlMCF+rkhhRCr7mczrbyXzk+VPKBy0ue83zvgHa6vua0bVGm3l3Uam7768qGzN
         O0Hg9pDXZD4C2YJizQ9hNngocuYN5v+kFUj15qA/xK7YiN1MpDuDLy5X3dKxqqwcZ6
         NCnTQbcbcKFT91kLI4ZmWpyK+C6WTsUUCXGg4zhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Bigonville <bigon@debian.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Lukasz Majczak <lma@semihalf.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 01/22] tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()
Date:   Mon,  8 Mar 2021 13:30:18 +0100
Message-Id: <20210308122714.468537074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Majczak <lma@semihalf.com>

commit d53a6adfb553969809eb2b736a976ebb5146cd95 upstream.

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

Decorate tpm_tis_gen_interrupt() with request_locality() and
release_locality().

Cc: Laurent Bigonville <bigon@debian.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -618,12 +618,22 @@ static int tpm_tis_gen_interrupt(struct
 	const char *desc = "attempting to generate an interrupt";
 	u32 cap2;
 	cap_t cap;
+	int ret;
 
+	/* TPM 2.0 */
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
-	else
-		return tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
-				  0);
+
+	/* TPM 1.2 */
+	ret = request_locality(chip, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
+
+	release_locality(chip, 0);
+
+	return ret;
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an


