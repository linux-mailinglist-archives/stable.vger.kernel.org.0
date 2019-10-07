Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5535CEE92
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 23:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfJGVqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 17:46:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:7617 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfJGVqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 17:46:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 14:46:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="199639433"
Received: from tstruk-mobl1.jf.intel.com ([10.24.10.78])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Oct 2019 14:46:37 -0700
Subject: [PATCH] tpm: add check after commands attribs tab allocation
From:   Tadeusz Struk <tadeusz.struk@intel.com>
To:     jarkko.sakkinen@linux.intel.com
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tadeusz.struk@intel.com
Date:   Mon, 07 Oct 2019 14:46:37 -0700
Message-ID: <157048479752.25182.17480591993061064051.stgit@tstruk-mobl1.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

devm_kcalloc() can fail and return NULL so we need to check for that.

Fixes: 58472f5cd4f6f ("tpm: validate TPM 2.0 commands")
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/char/tpm/tpm2-cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index ba9acae83bff..5817dfe5c5d2 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -939,6 +939,10 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
 
 	chip->cc_attrs_tbl = devm_kcalloc(&chip->dev, 4, nr_commands,
 					  GFP_KERNEL);
+	if (!chip->cc_attrs_tbl) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
 	if (rc)

