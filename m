Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C95C24764C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgHQTfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbgHQP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFCE23B85;
        Mon, 17 Aug 2020 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678168;
        bh=TPvivIz/oPvaS6bc4/Rp6tbbh1/uQX/iceHJri6MASg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebRcccuH/xT+emtZE7Yx2Kteecpe7ijdy2uDjYzm+VgRQ7rdx/LjSx3IvDUKdVgav
         XoyjJU5jUSEJARvhz7gtrrpOlqCd63Q8FC3X2FRn3yoeOsr1gqx1CaKQc013ECI5wp
         PrPUnJQaXD9RUp9GHX0GDOFCgRIoePGNP8Iljvi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 241/464] ima: Free the entire rule if it fails to parse
Date:   Mon, 17 Aug 2020 17:13:14 +0200
Message-Id: <20200817143845.340769278@linuxfoundation.org>
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

[ Upstream commit 2bdd737c5687d6dec30e205953146ede8a87dbdd ]

Use ima_free_rule() to fix memory leaks of allocated ima_rule_entry
members, such as .fsname and .keyrings, when an error is encountered
during rule parsing.

Set the args_p pointer to NULL after freeing it in the error path of
ima_lsm_rule_init() so that it isn't freed twice.

This fixes a memory leak seen when loading an rule that contains an
additional piece of allocated memory, such as an fsname, followed by an
invalid conditional:

 # echo "measure fsname=tmpfs bad=cond" > /sys/kernel/security/ima/policy
 -bash: echo: write error: Invalid argument
 # echo scan > /sys/kernel/debug/kmemleak
 # cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffff98e7e4ece6c0 (size 8):
   comm "bash", pid 672, jiffies 4294791843 (age 21.855s)
   hex dump (first 8 bytes):
     74 6d 70 66 73 00 6b a5                          tmpfs.k.
   backtrace:
     [<00000000abab7413>] kstrdup+0x2e/0x60
     [<00000000f11ede32>] ima_parse_add_rule+0x7d4/0x1020
     [<00000000f883dd7a>] ima_write_policy+0xab/0x1d0
     [<00000000b17cf753>] vfs_write+0xde/0x1d0
     [<00000000b8ddfdea>] ksys_write+0x68/0xe0
     [<00000000b8e21e87>] do_syscall_64+0x56/0xa0
     [<0000000089ea7b98>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f1b08bbcbdaf ("ima: define a new policy condition based on the filesystem name")
Fixes: 2b60c0ecedf8 ("IMA: Read keyrings= option from the IMA policy")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 641582230861c..18271920d315d 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -913,6 +913,7 @@ static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 
 		if (ima_rules == &ima_default_rules) {
 			kfree(entry->lsm[lsm_rule].args_p);
+			entry->lsm[lsm_rule].args_p = NULL;
 			result = -EINVAL;
 		} else
 			result = 0;
@@ -1404,7 +1405,7 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	result = ima_parse_rule(p, entry);
 	if (result) {
-		kfree(entry);
+		ima_free_rule(entry);
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 				    NULL, op, "invalid-policy", result,
 				    audit_info);
-- 
2.25.1



