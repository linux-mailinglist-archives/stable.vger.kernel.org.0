Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAE344291
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhCVMnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231972AbhCVMk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D0BB619BD;
        Mon, 22 Mar 2021 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416751;
        bh=T2BsNNN7xneST+qY/2iePrIdTx/7Kg+ir1JLIr7JWxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rO5p1MOMeQauEyBgoGcrYS+M4Y7cZoO6zGPS0fZpdZediULoGp5YA9meYHvt/0ZZ
         encJ5Y3BTZmxC8ZrAmBhb6mOVODM+8EzgAy+vJYbQHDC8tlOqmGb6hJ+ngnFQ/iUVs
         KSYBwMRXzMXq8GMjBotai7ULsRrxFCat3sWfT4GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/157] module: avoid *goto*s in module_sig_check()
Date:   Mon, 22 Mar 2021 13:27:10 +0100
Message-Id: <20210322121936.076494456@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index 3b6dd8200d3d..f1be6b6a3a3d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2923,20 +2923,13 @@ static int module_sig_check(struct load_info *info, int flags)
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
@@ -2945,6 +2938,13 @@ static int module_sig_check(struct load_info *info, int flags)
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



