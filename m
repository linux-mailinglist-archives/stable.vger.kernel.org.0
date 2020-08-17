Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7F247640
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgHQP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgHQP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CA823C17;
        Mon, 17 Aug 2020 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678165;
        bh=L7Fuv2KHVQPkEGZguNm9DpboBBFZMLvBILGXeFQ+vY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yM0OoTSo78kq0RpYaxz8JfVYVmP1vNK7+FS2V5xuOsDVwlDnlesi0UO2LAy2q35Bx
         8spfmny9lngOV73cl/0hWAG4msvRWAhKEASS/f9p4H50BXTu6IO5BFkhk8Vz+129VQ
         s1MPZL2YjLVX8Vja+76n7WBjlOHZKLvHyp3+FjWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 240/464] ima: Free the entire rule when deleting a list of rules
Date:   Mon, 17 Aug 2020 17:13:13 +0200
Message-Id: <20200817143845.293760421@linuxfoundation.org>
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

[ Upstream commit 465aee77aae857b5fcde56ee192b33dc369fba04 ]

Create a function, ima_free_rule(), to free all memory associated with
an ima_rule_entry. Use the new function to fix memory leaks of allocated
ima_rule_entry members, such as .fsname and .keyrings, when deleting a
list of rules.

Make the existing ima_lsm_free_rule() function specific to the LSM
audit rule array of an ima_rule_entry and require that callers make an
additional call to kfree to free the ima_rule_entry itself.

This fixes a memory leak seen when loading by a valid rule that contains
an additional piece of allocated memory, such as an fsname, followed by
an invalid rule that triggers a policy load failure:

 # echo -e "dont_measure fsname=securityfs\nbad syntax" > \
    /sys/kernel/security/ima/policy
 -bash: echo: write error: Invalid argument
 # echo scan > /sys/kernel/debug/kmemleak
 # cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffff9bab67ca12c0 (size 16):
   comm "bash", pid 684, jiffies 4295212803 (age 252.344s)
   hex dump (first 16 bytes):
     73 65 63 75 72 69 74 79 66 73 00 6b 6b 6b 6b a5  securityfs.kkkk.
   backtrace:
     [<00000000adc80b1b>] kstrdup+0x2e/0x60
     [<00000000d504cb0d>] ima_parse_add_rule+0x7d4/0x1020
     [<00000000444825ac>] ima_write_policy+0xab/0x1d0
     [<000000002b7f0d6c>] vfs_write+0xde/0x1d0
     [<0000000096feedcf>] ksys_write+0x68/0xe0
     [<0000000052b544a2>] do_syscall_64+0x56/0xa0
     [<000000007ead1ba7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f1b08bbcbdaf ("ima: define a new policy condition based on the filesystem name")
Fixes: 2b60c0ecedf8 ("IMA: Read keyrings= option from the IMA policy")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 236a731492d1e..641582230861c 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -261,6 +261,21 @@ static void ima_lsm_free_rule(struct ima_rule_entry *entry)
 		security_filter_rule_free(entry->lsm[i].rule);
 		kfree(entry->lsm[i].args_p);
 	}
+}
+
+static void ima_free_rule(struct ima_rule_entry *entry)
+{
+	if (!entry)
+		return;
+
+	/*
+	 * entry->template->fields may be allocated in ima_parse_rule() but that
+	 * reference is owned by the corresponding ima_template_desc element in
+	 * the defined_templates list and cannot be freed here
+	 */
+	kfree(entry->fsname);
+	kfree(entry->keyrings);
+	ima_lsm_free_rule(entry);
 	kfree(entry);
 }
 
@@ -302,6 +317,7 @@ static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 
 out_err:
 	ima_lsm_free_rule(nentry);
+	kfree(nentry);
 	return NULL;
 }
 
@@ -315,7 +331,14 @@ static int ima_lsm_update_rule(struct ima_rule_entry *entry)
 
 	list_replace_rcu(&entry->list, &nentry->list);
 	synchronize_rcu();
+	/*
+	 * ima_lsm_copy_rule() shallow copied all references, except for the
+	 * LSM references, from entry to nentry so we only want to free the LSM
+	 * references and the entry itself. All other memory refrences will now
+	 * be owned by nentry.
+	 */
 	ima_lsm_free_rule(entry);
+	kfree(entry);
 
 	return 0;
 }
@@ -1402,15 +1425,11 @@ ssize_t ima_parse_add_rule(char *rule)
 void ima_delete_rules(void)
 {
 	struct ima_rule_entry *entry, *tmp;
-	int i;
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++)
-			kfree(entry->lsm[i].args_p);
-
 		list_del(&entry->list);
-		kfree(entry);
+		ima_free_rule(entry);
 	}
 }
 
-- 
2.25.1



