Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3515F2AD8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiJCHm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiJCHll (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:41:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2492E637B;
        Mon,  3 Oct 2022 00:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A9B60F63;
        Mon,  3 Oct 2022 07:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F74EC433C1;
        Mon,  3 Oct 2022 07:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781879;
        bh=xM5y8YomQJngbkbV7wJV9nosQk9T+fU4DmNA9kCnYnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHPFTcdsSAlf7oAstyTGuUF3z7wvwkjJxunqjgMgzTN7bbwmLdt1ENGZwGIl5E8Y2
         vmwbGYjEv0t3b12/8JJxznSy7tnBiaHfp5Z34ajBJkFeXUiJkI+rexyO8Pzh7sJAT/
         SdgGClU8MBBCCkqd8KA44jU4uPVzy+x/nvxIr+QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Gou Hao <gouhao@uniontech.com>
Subject: [PATCH 4.19 14/25] ima: Free the entire rule if it fails to parse
Date:   Mon,  3 Oct 2022 09:12:17 +0200
Message-Id: <20221003070715.827351832@linuxfoundation.org>
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

commit 2bdd737c5687d6dec30e205953146ede8a87dbdd upstream.

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
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_policy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -662,6 +662,7 @@ static int ima_lsm_rule_init(struct ima_
 					   &entry->lsm[lsm_rule].rule);
 	if (!entry->lsm[lsm_rule].rule) {
 		kfree(entry->lsm[lsm_rule].args_p);
+		entry->lsm[lsm_rule].args_p = NULL;
 		return -EINVAL;
 	}
 
@@ -1034,7 +1035,7 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	result = ima_parse_rule(p, entry);
 	if (result) {
-		kfree(entry);
+		ima_free_rule(entry);
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 				    NULL, op, "invalid-policy", result,
 				    audit_info);


