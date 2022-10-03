Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3635F2BB0
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiJCIY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJCIYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6367824F11;
        Mon,  3 Oct 2022 00:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24CCBB80E90;
        Mon,  3 Oct 2022 07:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7B4C433C1;
        Mon,  3 Oct 2022 07:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781876;
        bh=CQa9aHIsHJ/Fq5xcdiiAk9NAQbh+vDgkS4lNrFPfjtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJlSpQBp1JDg/nO+HXSpHgxLixBYsYFC254YEG2jdlcrX9ctSlu64tTGGa1UzbtKf
         Wf2tMZfQoHC0cTUWSdiUM3sir4ldIE4eaVGF77cLKpPZ7ml2subsIaqu/aZC/pQphc
         j9+KFeN/kbgKVaXE1IwbQK/SAEGFb3lmjITLMjlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Gou Hao <gouhao@uniontech.com>
Subject: [PATCH 4.19 13/25] ima: Free the entire rule when deleting a list of rules
Date:   Mon,  3 Oct 2022 09:12:16 +0200
Message-Id: <20221003070715.800430612@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit 465aee77aae857b5fcde56ee192b33dc369fba04 upstream.

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
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_policy.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -241,6 +241,21 @@ static int __init default_appraise_polic
 }
 __setup("ima_appraise_tcb", default_appraise_policy_setup);
 
+static void ima_free_rule(struct ima_rule_entry *entry)
+{
+	int i;
+
+	if (!entry)
+		return;
+
+	kfree(entry->fsname);
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		security_filter_rule_free(entry->lsm[i].rule);
+		kfree(entry->lsm[i].args_p);
+	}
+	kfree(entry);
+}
+
 /*
  * The LSM policy can be reloaded, leaving the IMA LSM based rules referring
  * to the old, stale LSM policy.  Update the IMA LSM based rules to reflect
@@ -1040,17 +1055,11 @@ ssize_t ima_parse_add_rule(char *rule)
 void ima_delete_rules(void)
 {
 	struct ima_rule_entry *entry, *tmp;
-	int i;
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++) {
-			security_filter_rule_free(entry->lsm[i].rule);
-			kfree(entry->lsm[i].args_p);
-		}
-
 		list_del(&entry->list);
-		kfree(entry);
+		ima_free_rule(entry);
 	}
 }
 


