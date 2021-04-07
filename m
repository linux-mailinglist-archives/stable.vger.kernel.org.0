Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CBE356890
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 11:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbhDGJ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 05:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbhDGJ5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 05:57:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07400C061756;
        Wed,  7 Apr 2021 02:57:27 -0700 (PDT)
Date:   Wed, 07 Apr 2021 09:57:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617789445;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y5FLxlgSbexvqy2fxlM9SqEVAma4qXNuQhn4SL5UkIk=;
        b=2Dm7z5zULhx5OvRlLUVkUNNXy8aDsuiZpRWngcivpZ5SrkcKvkmlVIySsDAdvVq5BwRJ9f
        57JD5evhjgZGgSZpwFaajFmvMm30dsCJpzFma0bor1WEbav0Nj7qme5bE8X51kg4aooKSC
        /kuK9lVDZFaN4HzjQDC5mkqNxwT/D8zD+zbwNRvV0Y9BktBGzBMctWbTExwuJ7kpiS678y
        SJSzeEs++B/n3sE/383AQIZgki3UZTFm+TeJdalvEJtBug+t6fsdT75U+gvwZsrzVY9P95
        8BFu1cVMjxAWxhJLbNrae3YrEr064TdVrerb+oAw6h5vUwAwbLJFvATEXQXYyw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617789445;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y5FLxlgSbexvqy2fxlM9SqEVAma4qXNuQhn4SL5UkIk=;
        b=hz+WEwZ1pLiauU75JepV0A8wgi3iGLWLYgXYw5Unu8j7Q4nzo0K+ZyQzBII8BR47ftjfDV
        1QZF6hf3b17ee/Cw==
From:   "tip-bot2 for William Roche" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] RAS/CEC: Correct ce_add_elem()'s returned values
Cc:     William Roche <william.roche@oracle.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1617722939-29670-1-git-send-email-william.roche@oracle.com>
References: <1617722939-29670-1-git-send-email-william.roche@oracle.com>
MIME-Version: 1.0
Message-ID: <161778944414.29796.5725343346963494205.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     3a62583c2853b0ab37a57dde79decea210b5fb89
Gitweb:        https://git.kernel.org/tip/3a62583c2853b0ab37a57dde79decea210b5fb89
Author:        William Roche <william.roche@oracle.com>
AuthorDate:    Tue, 06 Apr 2021 11:28:59 -04:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 07 Apr 2021 11:52:26 +02:00

RAS/CEC: Correct ce_add_elem()'s returned values

ce_add_elem() uses different return values to signal a result from
adding an element to the collector. Commit in Fixes: broke the case
where the element being added is not found in the array. Correct that.

 [ bp: Rewrite commit message, add kernel-doc comments. ]

Fixes: de0e0624d86f ("RAS/CEC: Check count_threshold unconditionally")
Signed-off-by: William Roche <william.roche@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1617722939-29670-1-git-send-email-william.roche@oracle.com
---
 drivers/ras/cec.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index ddecf25..d7894f1 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -309,11 +309,20 @@ static bool sanity_check(struct ce_array *ca)
 	return ret;
 }
 
+/**
+ * cec_add_elem - Add an element to the CEC array.
+ * @pfn:	page frame number to insert
+ *
+ * Return values:
+ * - <0:	on error
+ * -  0:	on success
+ * - >0:	when the inserted pfn was offlined
+ */
 static int cec_add_elem(u64 pfn)
 {
 	struct ce_array *ca = &ce_arr;
+	int count, err, ret = 0;
 	unsigned int to = 0;
-	int count, ret = 0;
 
 	/*
 	 * We can be called very early on the identify_cpu() path where we are
@@ -330,8 +339,8 @@ static int cec_add_elem(u64 pfn)
 	if (ca->n == MAX_ELEMS)
 		WARN_ON(!del_lru_elem_unlocked(ca));
 
-	ret = find_elem(ca, pfn, &to);
-	if (ret < 0) {
+	err = find_elem(ca, pfn, &to);
+	if (err < 0) {
 		/*
 		 * Shift range [to-end] to make room for one more element.
 		 */
