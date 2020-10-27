Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CA729B928
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802230AbgJ0PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797536AbgJ0P1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED3A22202;
        Tue, 27 Oct 2020 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812471;
        bh=/KzYQAVWKxQG7Y6LJLVsvYOI+KeJV5ecFGe7zFVyNuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8i6u8jhomMCx8SeziqHfabFBfmx4bL1PvCguFHpk4UwJPxVjRTUXJncdR9YtDWti
         6ft+k+j09c4pVrGASpGiUoTI/qJYq6XquHcwYQH6GqBoq9z0e5J1eHeaKQS5357ZRG
         SybywHCUdK735pSDEBc7NJvK3wgj3Kdjso4N57IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nayna Jain <nayna@linux.ibm.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 222/757] ima: Fail rule parsing when asymmetric key measurement isnt supportable
Date:   Tue, 27 Oct 2020 14:47:52 +0100
Message-Id: <20201027135501.034151230@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit 48ce1ddce16b0d1e3ff948da40a0d5125a4ee1a0 ]

Measuring keys is currently only supported for asymmetric keys. In the
future, this might change.

For now, the "func=KEY_CHECK" and "keyrings=" options are only
appropriate when CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS is enabled. Make
this clear at policy load so that IMA policy authors don't assume that
these policy language constructs are supported.

Fixes: 2b60c0ecedf8 ("IMA: Read keyrings= option from the IMA policy")
Fixes: 5808611cccb2 ("IMA: Add KEY_CHECK func to measure keys")
Suggested-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9354e7cf4a09f..4a7a4b6bf79b2 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1233,7 +1233,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				entry->func = POLICY_CHECK;
 			else if (strcmp(args[0].from, "KEXEC_CMDLINE") == 0)
 				entry->func = KEXEC_CMDLINE;
-			else if (strcmp(args[0].from, "KEY_CHECK") == 0)
+			else if (IS_ENABLED(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) &&
+				 strcmp(args[0].from, "KEY_CHECK") == 0)
 				entry->func = KEY_CHECK;
 			else
 				result = -EINVAL;
@@ -1290,7 +1291,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		case Opt_keyrings:
 			ima_log_string(ab, "keyrings", args[0].from);
 
-			if (entry->keyrings) {
+			if (!IS_ENABLED(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) ||
+			    entry->keyrings) {
 				result = -EINVAL;
 				break;
 			}
-- 
2.25.1



