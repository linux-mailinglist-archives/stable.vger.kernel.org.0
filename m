Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC4200CE4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389381AbgFSOuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389378AbgFSOuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B36DB206DB;
        Fri, 19 Jun 2020 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578254;
        bh=sm8euXclJ2m5nLyWIPbkkEmWMOOlBNEoz3YBzD4yL7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuekWtJ0KNGBIWy+qTwY6JdnPOvo8xhljWkC1SjEVF8ik/vnbKFYNqkAdVgcM2Vqg
         JE8UouTLR+VFuwkiRRl0tVHYIyTeErmhT4gMb0xZbdyrJFrY32xvJJ/R6/qOYcsPJt
         s+CpOAB3FqEjUAankz366lkInPochneYCrnNdawY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.14 143/190] ima: Directly assign the ima_default_policy pointer to ima_rules
Date:   Fri, 19 Jun 2020 16:33:08 +0200
Message-Id: <20200619141640.805513637@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 067a436b1b0aafa593344fddd711a755a58afb3b upstream.

This patch prevents the following oops:

[   10.771813] BUG: kernel NULL pointer dereference, address: 0000000000000
[...]
[   10.779790] RIP: 0010:ima_match_policy+0xf7/0xb80
[...]
[   10.798576] Call Trace:
[   10.798993]  ? ima_lsm_policy_change+0x2b0/0x2b0
[   10.799753]  ? inode_init_owner+0x1a0/0x1a0
[   10.800484]  ? _raw_spin_lock+0x7a/0xd0
[   10.801592]  ima_must_appraise.part.0+0xb6/0xf0
[   10.802313]  ? ima_fix_xattr.isra.0+0xd0/0xd0
[   10.803167]  ima_must_appraise+0x4f/0x70
[   10.804004]  ima_post_path_mknod+0x2e/0x80
[   10.804800]  do_mknodat+0x396/0x3c0

It occurs when there is a failure during IMA initialization, and
ima_init_policy() is not called. IMA hooks still call ima_match_policy()
but ima_rules is NULL. This patch prevents the crash by directly assigning
the ima_default_policy pointer to ima_rules when ima_rules is defined. This
wouldn't alter the existing behavior, as ima_rules is always set at the end
of ima_init_policy().

Cc: stable@vger.kernel.org # 3.7.x
Fixes: 07f6a79415d7d ("ima: add appraise action keywords and default rules")
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_policy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -170,7 +170,7 @@ static struct ima_rule_entry secure_boot
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
-static struct list_head *ima_rules;
+static struct list_head *ima_rules = &ima_default_rules;
 
 static int ima_policy __initdata;
 
@@ -468,7 +468,6 @@ void __init ima_init_policy(void)
 			temp_ima_appraise |= IMA_APPRAISE_POLICY;
 	}
 
-	ima_rules = &ima_default_rules;
 	ima_update_policy_flag();
 }
 


