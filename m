Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A1353DE9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhDEJC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237546AbhDEJCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 310576138A;
        Mon,  5 Apr 2021 09:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613368;
        bh=vFNmNt+U/hd/gxxm8RYCo69Q9+MJfjIf8BhgTyZ+l84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUiskFRngR2lhSwY0kpP7ZnW83fy0d66YzWFzu3teBuicjaKpQVhLnUthz3MgW7L1
         H5ERBiNQr7m/Pbca1+SN7wLsfP3Klfjs90y1rUn78WJ5GLnL7ufFsH1SkOAtfzEKUE
         N+76MPyGQ6MlGnAfUd9MmCi58vaMYDTjo4JXiZaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/74] module: merge repetitive strings in module_sig_check()
Date:   Mon,  5 Apr 2021 10:53:27 +0200
Message-Id: <20210405085024.812932452@linuxfoundation.org>
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
index ab1f97cfe18d..9fe3e9b85348 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2908,16 +2908,17 @@ static int module_sig_check(struct load_info *info, int flags)
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
-			pr_notice("%s is rejected\n", reason);
+			pr_notice("%s: loading of %s is rejected\n",
+				  info->name, reason);
 			return -EKEYREJECTED;
 		}
 
-- 
2.30.1



