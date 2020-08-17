Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2C246B35
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgHQPur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730883AbgHQPum (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0AFF2065C;
        Mon, 17 Aug 2020 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679436;
        bh=cbANANyU/YMVkf+WiiSd6M9TsPsYv2l6Y4+7w6+2p+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxaFoEuuB1BPB1YXKxAURngXiwCr+vSG70yLfoYTUHowH0inXZSayUMfBbFsyylSF
         qaJyklXNWGuKxbzYYg3FgesWxr5BUaUUYqAU7WIdBRaQe8s6fAGH4tbz3yPVDMCuns
         YU/Hg4dKRRLmGsK7LAFbRK/BU9DenkyK8tj3Pd3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 210/393] ima: Fail rule parsing when buffer hook functions have an invalid action
Date:   Mon, 17 Aug 2020 17:14:20 +0200
Message-Id: <20200817143829.811925451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit 712183437ebebc89cd086ef96cf9a521fd97fd09 ]

Buffer based hook functions, such as KEXEC_CMDLINE and KEY_CHECK, can
only measure. The process_buffer_measurement() function quietly ignores
all actions except measure so make this behavior clear at the time of
policy load.

The parsing of the keyrings conditional had a check to ensure that it
was only specified with measure actions but the check should be on the
hook function and not the keyrings conditional since
"appraise func=KEY_CHECK" is not a valid rule.

Fixes: b0935123a183 ("IMA: Define a new hook to measure the kexec boot command line arguments")
Fixes: 5808611cccb2 ("IMA: Add KEY_CHECK func to measure keys")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 40 +++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 18271920d315d..a3d72342408ad 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -973,6 +973,43 @@ static void check_template_modsig(const struct ima_template_desc *template)
 #undef MSG
 }
 
+static bool ima_validate_rule(struct ima_rule_entry *entry)
+{
+	/* Ensure that the action is set */
+	if (entry->action == UNKNOWN)
+		return false;
+
+	/*
+	 * Ensure that the hook function is compatible with the other
+	 * components of the rule
+	 */
+	switch (entry->func) {
+	case NONE:
+	case FILE_CHECK:
+	case MMAP_CHECK:
+	case BPRM_CHECK:
+	case CREDS_CHECK:
+	case POST_SETATTR:
+	case MODULE_CHECK:
+	case FIRMWARE_CHECK:
+	case KEXEC_KERNEL_CHECK:
+	case KEXEC_INITRAMFS_CHECK:
+	case POLICY_CHECK:
+		/* Validation of these hook functions is in ima_parse_rule() */
+		break;
+	case KEXEC_CMDLINE:
+	case KEY_CHECK:
+		if (entry->action & ~(MEASURE | DONT_MEASURE))
+			return false;
+
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 {
 	struct audit_buffer *ab;
@@ -1150,7 +1187,6 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			keyrings_len = strlen(args[0].from) + 1;
 
 			if ((entry->keyrings) ||
-			    (entry->action != MEASURE) ||
 			    (entry->func != KEY_CHECK) ||
 			    (keyrings_len < 2)) {
 				result = -EINVAL;
@@ -1356,7 +1392,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			break;
 		}
 	}
-	if (!result && (entry->action == UNKNOWN))
+	if (!result && !ima_validate_rule(entry))
 		result = -EINVAL;
 	else if (entry->action == APPRAISE)
 		temp_ima_appraise |= ima_appraise_flag(entry->func);
-- 
2.25.1



