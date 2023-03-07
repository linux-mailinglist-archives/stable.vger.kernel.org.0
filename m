Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AE86AEA95
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjCGRfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCGRer (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56E99BA53
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5111861517
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495FFC433EF;
        Tue,  7 Mar 2023 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210254;
        bh=tPZ71qCox8w2ZDs50xdWfUE2VuyEUqyj2wCJR+q0DAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJPc8ihyffSNQvKA63hOxc6HfHgfPWiAjWLiA1Tx1B/8JGQaHghZAgahHPf9IHZnl
         M6Mn0bsJj1X7ULdvF92TOHhVdUfn5twgvoy1eyKvH5elv7tK1IczaW6iG6MZZemfHK
         +v7WheqeuyY7yhWalGs4TQfklkmXMMhVc27U54WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ondrej Mosnacek <omosnace@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0482/1001] sysctl: fix proc_dobool() usability
Date:   Tue,  7 Mar 2023 17:54:14 +0100
Message-Id: <20230307170042.319685305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit f1aa2eb5ea05ccd1fd92d235346e60e90a1ed949 ]

Currently proc_dobool expects a (bool *) in table->data, but sizeof(int)
in table->maxsize, because it uses do_proc_dointvec() directly.

This is unsafe for at least two reasons:
1. A sysctl table definition may use { .data = &variable, .maxsize =
   sizeof(variable) }, not realizing that this makes the sysctl unusable
   (see the Fixes: tag) and that they need to use the completely
   counterintuitive sizeof(int) instead.
2. proc_dobool() will currently try to parse an array of values if given
   .maxsize >= 2*sizeof(int), but will try to write values of type bool
   by offsets of sizeof(int), so it will not work correctly with neither
   an (int *) nor a (bool *). There is no .maxsize validation to prevent
   this.

Fix this by:
1. Constraining proc_dobool() to allow only one value and .maxsize ==
   sizeof(bool).
2. Wrapping the original struct ctl_table in a temporary one with .data
   pointing to a local int variable and .maxsize set to sizeof(int) and
   passing this one to proc_dointvec(), converting the value to/from
   bool as needed (using proc_dou8vec_minmax() as an example).
3. Extending sysctl_check_table() to enforce proc_dobool() expectations.
4. Fixing the proc_dobool() docstring (it was just copy-pasted from
   proc_douintvec, apparently...).
5. Converting all existing proc_dobool() users to set .maxsize to
   sizeof(bool) instead of sizeof(int).

Fixes: 83efeeeb3d04 ("tty: Allow TIOCSTI to be disabled")
Fixes: a2071573d634 ("sysctl: introduce new proc handler proc_dobool")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c        |  2 +-
 fs/proc/proc_sysctl.c |  6 ++++++
 kernel/sysctl.c       | 43 ++++++++++++++++++++++++-------------------
 mm/hugetlb_vmemmap.c  |  2 +-
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 59ef8a1f843f3..914ea1c3537d1 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -496,7 +496,7 @@ static struct ctl_table nlm_sysctls[] = {
 	{
 		.procname	= "nsm_use_hostnames",
 		.data		= &nsm_use_hostnames,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(bool),
 		.mode		= 0644,
 		.proc_handler	= proc_dobool,
 	},
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 48f2d60bd78a2..436025e0f77a6 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1124,6 +1124,11 @@ static int sysctl_check_table_array(const char *path, struct ctl_table *table)
 			err |= sysctl_err(path, table, "array not allowed");
 	}
 
+	if (table->proc_handler == proc_dobool) {
+		if (table->maxlen != sizeof(bool))
+			err |= sysctl_err(path, table, "array not allowed");
+	}
+
 	return err;
 }
 
@@ -1136,6 +1141,7 @@ static int sysctl_check_table(const char *path, struct ctl_table *table)
 			err |= sysctl_err(path, entry, "Not a file");
 
 		if ((entry->proc_handler == proc_dostring) ||
+		    (entry->proc_handler == proc_dobool) ||
 		    (entry->proc_handler == proc_dointvec) ||
 		    (entry->proc_handler == proc_douintvec) ||
 		    (entry->proc_handler == proc_douintvec_minmax) ||
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 137d4abe3eda1..1c240d2c99bcb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -425,21 +425,6 @@ static void proc_put_char(void **buf, size_t *size, char c)
 	}
 }
 
-static int do_proc_dobool_conv(bool *negp, unsigned long *lvalp,
-				int *valp,
-				int write, void *data)
-{
-	if (write) {
-		*(bool *)valp = *lvalp;
-	} else {
-		int val = *(bool *)valp;
-
-		*lvalp = (unsigned long)val;
-		*negp = false;
-	}
-	return 0;
-}
-
 static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 				 int *valp,
 				 int write, void *data)
@@ -710,16 +695,36 @@ int do_proc_douintvec(struct ctl_table *table, int write,
  * @lenp: the size of the user buffer
  * @ppos: file position
  *
- * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string.
+ * Reads/writes one integer value from/to the user buffer,
+ * treated as an ASCII string.
+ *
+ * table->data must point to a bool variable and table->maxlen must
+ * be sizeof(bool).
  *
  * Returns 0 on success.
  */
 int proc_dobool(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
-	return do_proc_dointvec(table, write, buffer, lenp, ppos,
-				do_proc_dobool_conv, NULL);
+	struct ctl_table tmp;
+	bool *data = table->data;
+	int res, val;
+
+	/* Do not support arrays yet. */
+	if (table->maxlen != sizeof(bool))
+		return -EINVAL;
+
+	tmp = *table;
+	tmp.maxlen = sizeof(val);
+	tmp.data = &val;
+
+	val = READ_ONCE(*data);
+	res = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (res)
+		return res;
+	if (write)
+		WRITE_ONCE(*data, val);
+	return 0;
 }
 
 /**
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 45e93a545dd7e..a559037cce00c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -581,7 +581,7 @@ static struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
 		.procname	= "hugetlb_optimize_vmemmap",
 		.data		= &vmemmap_optimize_enabled,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(vmemmap_optimize_enabled),
 		.mode		= 0644,
 		.proc_handler	= proc_dobool,
 	},
-- 
2.39.2



