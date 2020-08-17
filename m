Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2054B24763D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgHQTfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbgHQP3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B821323BE2;
        Mon, 17 Aug 2020 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678174;
        bh=I0mBP7wTCEKkZIwHjCDfXcQWyWEOqJFbo3CJkQzU6tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHiCEKVoCE8AHo/GCm4wLGyioymWD3Kkm3HJEqJJnOIfG9IjxzRFy4u3idJKd6nVR
         VgfiW6a5NVnSzNdlzGSN2O8nTIUBr/k0GoRCDLgs2kSa1qHgy+O2reKXZ3L+twUfSx
         j973Pa2756YdpInrR50EssfzsCuxvJfnmozls0cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 243/464] ima: Fail rule parsing when the KEXEC_CMDLINE hook is combined with an invalid cond
Date:   Mon, 17 Aug 2020 17:13:16 +0200
Message-Id: <20200817143845.436176143@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit db2045f5892a9db7354442bf77f9b03b50ff9ee1 ]

The KEXEC_CMDLINE hook function only supports the pcr conditional. Make
this clear at policy load so that IMA policy authors don't assume that
other conditionals are supported.

Since KEXEC_CMDLINE's inception, ima_match_rules() has always returned
true on any loaded KEXEC_CMDLINE rule without any consideration for
other conditionals present in the rule. Make it clear that pcr is the
only supported KEXEC_CMDLINE conditional by returning an error during
policy load.

An example of why this is a problem can be explained with the following
rule:

 dont_measure func=KEXEC_CMDLINE obj_type=foo_t

An IMA policy author would have assumed that rule is valid because the
parser accepted it but the result was that measurements for all
KEXEC_CMDLINE operations would be disabled.

Fixes: b0935123a183 ("IMA: Define a new hook to measure the kexec boot command line arguments")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a3d72342408ad..a77e0b34e72f7 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -343,6 +343,17 @@ static int ima_lsm_update_rule(struct ima_rule_entry *entry)
 	return 0;
 }
 
+static bool ima_rule_contains_lsm_cond(struct ima_rule_entry *entry)
+{
+	int i;
+
+	for (i = 0; i < MAX_LSM_RULES; i++)
+		if (entry->lsm[i].args_p)
+			return true;
+
+	return false;
+}
+
 /*
  * The LSM policy can be reloaded, leaving the IMA LSM based rules referring
  * to the old, stale LSM policy.  Update the IMA LSM based rules to reflect
@@ -998,6 +1009,16 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 		/* Validation of these hook functions is in ima_parse_rule() */
 		break;
 	case KEXEC_CMDLINE:
+		if (entry->action & ~(MEASURE | DONT_MEASURE))
+			return false;
+
+		if (entry->flags & ~(IMA_FUNC | IMA_PCR))
+			return false;
+
+		if (ima_rule_contains_lsm_cond(entry))
+			return false;
+
+		break;
 	case KEY_CHECK:
 		if (entry->action & ~(MEASURE | DONT_MEASURE))
 			return false;
-- 
2.25.1



