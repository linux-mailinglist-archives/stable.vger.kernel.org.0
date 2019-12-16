Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412E01218AD
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfLPR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfLPR5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:57:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58882166E;
        Mon, 16 Dec 2019 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519071;
        bh=8txS9mJL9J6Lew5YvRFGxoiMpn2Y4GzBC6UtL/Z2LXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPFaHVROTfr2HAdjIRSd42dgzLZpzx9rHWWxKUqaXKPlWsB3pbdnLlIyfFKIRTLeT
         dGDSMurqUo22PSq6A5sUVU4PNroaLOyFwMshgmVHCQf6nokmsqjxtae9b0NtLrnXrO
         D0mjh+LTxPMW7SNT/LcFdlCCiz/M3RAXBrXjsQs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.14 181/267] tpm: add check after commands attribs tab allocation
Date:   Mon, 16 Dec 2019 18:48:27 +0100
Message-Id: <20191216174912.414990948@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>

commit f1689114acc5e89a196fec6d732dae3e48edb6ad upstream.

devm_kcalloc() can fail and return NULL so we need to check for that.

Cc: stable@vger.kernel.org
Fixes: 58472f5cd4f6f ("tpm: validate TPM 2.0 commands")
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm2-cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -1029,6 +1029,10 @@ static int tpm2_get_cc_attrs_tbl(struct
 
 	chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
 					  GFP_KERNEL);
+	if (!chip->cc_attrs_tbl) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
 	if (rc)


