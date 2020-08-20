Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4E24BF17
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgHTNjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgHTJah (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D96206FA;
        Thu, 20 Aug 2020 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915833;
        bh=MDDyBPpHCPkjL6gnxEy7Y1yVEhWZUKASThmRxTHfrlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnc2GzkOfn5PUZAyg9fT9nAbjc/QbuSdr71FsXLEhuo4J9N+keMvTjsFefQi6uOde
         rZVLaMb8al1W4MaLLxlaE2xqcO1KOZYMKPtROHi9jwLtdphbVWYbGtmrjD5HrDtdeX
         QesFdtK3U44eda3wB6e06099bVEGpDmH5ixWzmwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 149/232] ima: Fail rule parsing when appraise_flag=blacklist is unsupportable
Date:   Thu, 20 Aug 2020 11:20:00 +0200
Message-Id: <20200820091620.030559584@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit 5f3e92657bbfb63ad3109433d843c89996114b03 ]

Verifying that a file hash is not blacklisted is currently only
supported for files with appended signatures (modsig).  In the future,
this might change.

For now, the "appraise_flag" option is only appropriate for appraise
actions and its "blacklist" value is only appropriate when
CONFIG_IMA_APPRAISE_MODSIG is enabled and "appraise_flag=blacklist" is
only appropriate when "appraise_type=imasig|modsig" is also present.
Make this clear at policy load so that IMA policy authors don't assume
that other uses of "appraise_flag=blacklist" are supported.

Fixes: 273df864cf74 ("ima: Check against blacklisted hashes for files with modsig")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reivewed-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 3e3e568c81309..a59bf2f5b2d4f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1035,6 +1035,11 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 		return false;
 	}
 
+	/* Ensure that combinations of flags are compatible with each other */
+	if (entry->flags & IMA_CHECK_BLACKLIST &&
+	    !(entry->flags & IMA_MODSIG_ALLOWED))
+		return false;
+
 	return true;
 }
 
@@ -1371,9 +1376,17 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				result = -EINVAL;
 			break;
 		case Opt_appraise_flag:
+			if (entry->action != APPRAISE) {
+				result = -EINVAL;
+				break;
+			}
+
 			ima_log_string(ab, "appraise_flag", args[0].from);
-			if (strstr(args[0].from, "blacklist"))
+			if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
+			    strstr(args[0].from, "blacklist"))
 				entry->flags |= IMA_CHECK_BLACKLIST;
+			else
+				result = -EINVAL;
 			break;
 		case Opt_permit_directio:
 			entry->flags |= IMA_PERMIT_DIRECTIO;
-- 
2.25.1



