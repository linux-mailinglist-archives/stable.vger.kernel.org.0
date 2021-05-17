Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3F382E67
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhEQOHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237905AbhEQOGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 847CE61354;
        Mon, 17 May 2021 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260304;
        bh=F0wwMLFZkfjf8sQf792pUgIM9/L+mtzINs5RBxdQOxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q46yFuRI5hN7XRozeUkf9XBttA5za/iTSz6+4FUuW1ToPQGLJezYTr/JSXugn4olF
         H2BYRfnqljhxYQlzE83N88uRO0ZfjMDFBTi3PIPGVejHghpGUOxZPCovRMrKt1wWgt
         +2OWJ/Ash9rfB4TC3MmQXaCWEfTiren7ihnMFZE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.12 003/363] tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()
Date:   Mon, 17 May 2021 15:57:49 +0200
Message-Id: <20210517140302.629501892@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

commit e630af7dfb450d1c00c30077314acf33032ff9e4 upstream.

The earlier fix (linked) only partially fixed the locality handling bug
in tpm_tis_gen_interrupt(), i.e. only for TPM 1.x.

Extend the locality handling to cover TPM2.

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-integrity/20210220125534.20707-1-jarkko@kernel.org/
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -709,16 +709,14 @@ static int tpm_tis_gen_interrupt(struct
 	cap_t cap;
 	int ret;
 
-	/* TPM 2.0 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
-
-	/* TPM 1.2 */
 	ret = request_locality(chip, 0);
 	if (ret < 0)
 		return ret;
 
-	ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		ret = tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+	else
+		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
 
 	release_locality(chip, 0);
 


