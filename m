Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728D73954D5
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 06:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhEaEx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 00:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhEaEx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 00:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 910FC61057;
        Mon, 31 May 2021 04:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622436709;
        bh=WRv6fQ3sfkE3Q4OpIzMPN0VfRRUu+eA4XzEtYX3Xfpo=;
        h=From:To:Cc:Subject:Date:From;
        b=n1RlIT341qSR9OIDfR/FCEx0dSK3RIx8r1VDbf0PJhwJsxwLTGRyhTsAYr3OPyxAY
         PX0sVsrgzcyyQYAspc94vvz42qDE22nYlkPwrQEiGiu4gEdcSqstkWQfK6hgAuyRah
         RkL6x2s733j6f9LTMjLvEIzOPeb1brOYw9Q1o7jgByzx7wT8UoFpgwz/mJaJQMiaFf
         q1xsuzn22W5gUy1YnU1612Q8RwXXPzBcvvvH2vz/zEZ0wPz4Ytk5pVjNDknx/IiW7s
         uwjaU2D26Rtl8/KP0Wvw2dl5s8y/Gim082BfEp+kqEytq56bpYwqBwanO6ngdKG0ff
         bjCXJ0ADpMS5w==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()
Date:   Mon, 31 May 2021 07:51:31 +0300
Message-Id: <20210531045131.110616-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do not torn down the system when getting invalid status from a TPM chip.
This can happen when panic-on-warn is used.

In addition, print out the value of TPM_STS.x instead of "invalid
status". In order to get the earlier benefits for forensics, also call
dump_stack().

Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 55b9d3965ae1..514a481829c9 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -202,7 +202,16 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 		 * acquired.  Usually because tpm_try_get_ops() hasn't
 		 * been called before doing a TPM operation.
 		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		dev_err_once(&chip->dev, "invalid TPM_STS.x 0x%02x, dumping stack for forensics\n",
+			     status);
+
+		/*
+		 * Dump stack for forensics, as invalid TPM_STS.x could be
+		 * potentially triggered by impaired tpm_try_get_ops() or
+		 * tpm_find_get_ops().
+		 */
+		dump_stack();
+
 		return 0;
 	}
 
-- 
2.31.1

