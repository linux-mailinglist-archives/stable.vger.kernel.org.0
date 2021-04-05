Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C16353DEA
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhDEJC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237480AbhDEJC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97EB61393;
        Mon,  5 Apr 2021 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613371;
        bh=Vz7DeXI+vyBpNCdgCRe4YNYy+HjPdbOLdzL2DofiBMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JirdM1lja1iiMonl9CDAxJaUWwVX0vOj2HQo/jG4kCvdMRlabodc0SWo+6WhgZ0b
         AW2hnJJzYum6GqQ8UAzXyLMXyGTBnNSORgO8MbI3Kx2Q4bx04RO15/HZyIHNRlrvwB
         Sfaug5/s8AlVB6DGKENIncUQ8JJInMoWfb4Fv3d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/74] module: avoid *goto*s in module_sig_check()
Date:   Mon,  5 Apr 2021 10:53:28 +0200
Message-Id: <20210405085024.851797884@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 10ccd1abb808599a6dc7c9389560016ea3568085 ]

Let's move the common handling of the non-fatal errors after the *switch*
statement -- this avoids *goto*s inside that *switch*...

Suggested-by: Joe Perches <joe@perches.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9fe3e9b85348..8d1def62a415 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2909,20 +2909,13 @@ static int module_sig_check(struct load_info *info, int flags)
 		 */
 	case -ENODATA:
 		reason = "unsigned module";
-		goto decide;
+		break;
 	case -ENOPKG:
 		reason = "module with unsupported crypto";
-		goto decide;
+		break;
 	case -ENOKEY:
 		reason = "module with unavailable key";
-	decide:
-		if (is_module_sig_enforced()) {
-			pr_notice("%s: loading of %s is rejected\n",
-				  info->name, reason);
-			return -EKEYREJECTED;
-		}
-
-		return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
+		break;
 
 		/* All other errors are fatal, including nomem, unparseable
 		 * signatures and signature check failures - even if signatures
@@ -2931,6 +2924,13 @@ static int module_sig_check(struct load_info *info, int flags)
 	default:
 		return err;
 	}
+
+	if (is_module_sig_enforced()) {
+		pr_notice("%s: loading of %s is rejected\n", info->name, reason);
+		return -EKEYREJECTED;
+	}
+
+	return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
 }
 #else /* !CONFIG_MODULE_SIG */
 static int module_sig_check(struct load_info *info, int flags)
-- 
2.30.1



