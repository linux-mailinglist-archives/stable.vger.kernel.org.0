Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B991F2D4C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbgFIAcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgFHXPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9183B20659;
        Mon,  8 Jun 2020 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658115;
        bh=szMzKWLLvKCRf1i4cCc+3mjcrWOYNZx5wYhk+zhoUZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lyvfb0boWRwzuj5n1djRN2YtCRfPhEmHu9xqraW8JTIBhGNAnp4uUtKzrOEnFjwRS
         hnSGuH8AzzccYwWLQBNe1g9YJbGI3urjWLVKXiwJii/GJronLvDcYNbL0qWas5RIbA
         sRCqyOzmnWaIPIvSUM9IlYNAIoQZS+7fOzHMUnCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        John Johansen <john.johansen@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 153/606] apparmor: Fix use-after-free in aa_audit_rule_init
Date:   Mon,  8 Jun 2020 19:04:38 -0400
Message-Id: <20200608231211.3363633-153-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit c54d481d71c6849e044690d3960aaebc730224cc upstream.

In the implementation of aa_audit_rule_init(), when aa_label_parse()
fails the allocated memory for rule is released using
aa_audit_rule_free(). But after this release, the return statement
tries to access the label field of the rule which results in
use-after-free. Before releasing the rule, copy errNo and return it
after release.

Fixes: 52e8c38001d8 ("apparmor: Fix memory leak of rule on error exit path")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/audit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 5a98661a8b46..597732503815 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -197,8 +197,9 @@ int aa_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 	rule->label = aa_label_parse(&root_ns->unconfined->label, rulestr,
 				     GFP_KERNEL, true, false);
 	if (IS_ERR(rule->label)) {
+		int err = PTR_ERR(rule->label);
 		aa_audit_rule_free(rule);
-		return PTR_ERR(rule->label);
+		return err;
 	}
 
 	*vrule = rule;
-- 
2.25.1

