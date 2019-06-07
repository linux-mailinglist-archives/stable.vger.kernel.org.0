Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3316739029
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfFGPtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731983AbfFGPte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B74C20840;
        Fri,  7 Jun 2019 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922573;
        bh=6SKreW8A/rijOlLBCupg5FdbBGnRGcupoXGZRHcXZe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2EKkZoC8vHACrv8k2xuJCd2Qcntp8tneSwLqEdtHaKreycz5Cq9rry1jjIRZZkfA
         q5j38F0/pvgOjcUcxWWQ+uw6SdTizzdWh13rBoUmFwnrf9pIiYn0wAwgYPG6dzGnPM
         bmTUojmnZuFlcymX5OqfMZJfpN/tpfRThCqSRAnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.1 60/85] ima: show rules with IMA_INMASK correctly
Date:   Fri,  7 Jun 2019 17:39:45 +0200
Message-Id: <20190607153856.094748565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 8cdc23a3d9ec0944000ad43bad588e36afdc38cd upstream.

Show the '^' character when a policy rule has flag IMA_INMASK.

Fixes: 80eae209d63ac ("IMA: allow reading back the current IMA policy")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_policy.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1147,10 +1147,10 @@ enum {
 };
 
 static const char *const mask_tokens[] = {
-	"MAY_EXEC",
-	"MAY_WRITE",
-	"MAY_READ",
-	"MAY_APPEND"
+	"^MAY_EXEC",
+	"^MAY_WRITE",
+	"^MAY_READ",
+	"^MAY_APPEND"
 };
 
 #define __ima_hook_stringify(str)	(#str),
@@ -1210,6 +1210,7 @@ int ima_policy_show(struct seq_file *m,
 	struct ima_rule_entry *entry = v;
 	int i;
 	char tbuf[64] = {0,};
+	int offset = 0;
 
 	rcu_read_lock();
 
@@ -1233,15 +1234,17 @@ int ima_policy_show(struct seq_file *m,
 	if (entry->flags & IMA_FUNC)
 		policy_func_show(m, entry->func);
 
-	if (entry->flags & IMA_MASK) {
+	if ((entry->flags & IMA_MASK) || (entry->flags & IMA_INMASK)) {
+		if (entry->flags & IMA_MASK)
+			offset = 1;
 		if (entry->mask & MAY_EXEC)
-			seq_printf(m, pt(Opt_mask), mt(mask_exec));
+			seq_printf(m, pt(Opt_mask), mt(mask_exec) + offset);
 		if (entry->mask & MAY_WRITE)
-			seq_printf(m, pt(Opt_mask), mt(mask_write));
+			seq_printf(m, pt(Opt_mask), mt(mask_write) + offset);
 		if (entry->mask & MAY_READ)
-			seq_printf(m, pt(Opt_mask), mt(mask_read));
+			seq_printf(m, pt(Opt_mask), mt(mask_read) + offset);
 		if (entry->mask & MAY_APPEND)
-			seq_printf(m, pt(Opt_mask), mt(mask_append));
+			seq_printf(m, pt(Opt_mask), mt(mask_append) + offset);
 		seq_puts(m, " ");
 	}
 


