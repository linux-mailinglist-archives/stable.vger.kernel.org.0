Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DFB34428F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCVMnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhCVMkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F254619B1;
        Mon, 22 Mar 2021 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416749;
        bh=rUU2feMyCLViLaHjhWKUKmRoiINpJ8rNpKOrHctVM30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4Gqt/V0t3Yxr/gyGxfHKLIhssRDW0coksrwzIf0K6h6f3GdOsuZ6u/cqsGeZsYgb
         hKvLLoepkP4y22heUisRrlHirf+/Tr+EfqzHtM0pMNREh/lVAoEk/AF6Dsv9Dw8VbN
         2phCvJKCI2F2oTx/7Ee0B7D/a6eS+gLN/89zcm4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/157] module: merge repetitive strings in module_sig_check()
Date:   Mon, 22 Mar 2021 13:27:09 +0100
Message-Id: <20210322121936.046321514@linuxfoundation.org>
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

[ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]

The 'reason' variable in module_sig_check() points to 3 strings across
the *switch* statement, all needlessly starting with the same text.
Let's put the starting text into the pr_notice() call -- it saves 21
bytes of the object code (x86 gcc 10.2.1).

Suggested-by: Joe Perches <joe@perches.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 94f926473e35..3b6dd8200d3d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2922,16 +2922,17 @@ static int module_sig_check(struct load_info *info, int flags)
 		 * enforcing, certain errors are non-fatal.
 		 */
 	case -ENODATA:
-		reason = "Loading of unsigned module";
+		reason = "unsigned module";
 		goto decide;
 	case -ENOPKG:
-		reason = "Loading of module with unsupported crypto";
+		reason = "module with unsupported crypto";
 		goto decide;
 	case -ENOKEY:
-		reason = "Loading of module with unavailable key";
+		reason = "module with unavailable key";
 	decide:
 		if (is_module_sig_enforced()) {
-			pr_notice("%s: %s is rejected\n", info->name, reason);
+			pr_notice("%s: loading of %s is rejected\n",
+				  info->name, reason);
 			return -EKEYREJECTED;
 		}
 
-- 
2.30.1



