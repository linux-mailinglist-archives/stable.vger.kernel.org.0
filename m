Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A633832B3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbhEQOun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239860AbhEQOsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F8656197C;
        Mon, 17 May 2021 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261353;
        bh=7xF696LXr3hj3CzUc54YkDy9CBiMSi/sfyJM0364i7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ss6c3VfP3f5qNjzOgwQgX2yAhXbwvLTPN4ja3U7qARjZG5IbbIAJi7+wmiwfLKdYE
         GFMtGoMP7EyX3ItZGctpFuFJnB9M4AdBYth5VrPDqed7jjsM+dJ5uJW1IhCYOYIanD
         m4VIG9SWLM9i4s8uHjS+AeYIJdseWqYPaQ/TFFUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 004/289] tpm, tpm_tis: Reserve locality in tpm_tis_resume()
Date:   Mon, 17 May 2021 15:58:49 +0200
Message-Id: <20210517140305.300906206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 8a2d296aaebadd68d9c1f6908667df1d1c84c051 upstream.

Reserve locality in tpm_tis_resume(), as it could be unsert after waking
up from a sleep state.

Cc: stable@vger.kernel.org
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reported-by: Hans de Goede <hdegoede@redhat.com>
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1125,12 +1125,20 @@ int tpm_tis_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	/* TPM 1.2 requires self-test on resume. This function actually returns
+	/*
+	 * TPM 1.2 requires self-test on resume. This function actually returns
 	 * an error code but for unknown reason it isn't handled.
 	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		ret = request_locality(chip, 0);
+		if (ret < 0)
+			return ret;
+
 		tpm1_do_selftest(chip);
 
+		release_locality(chip, 0);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_tis_resume);


