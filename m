Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE216E62BF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjDRMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjDRMfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:35:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AAD118E7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 499BA6326A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59497C4339C;
        Tue, 18 Apr 2023 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821298;
        bh=NoS/pzlATe+Ka0et55LQBmB6Lq2O7AS8ggsYTKhHgAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMTjMvGo/dLdovLIybGvx3aQthinFS0ivgEw5ZGVdYN5ZcfoOR5JiuUuZbr57Sc9B
         +/MNPbxUJ/HF4cApMb/X+APEW2WrO00yKgY/Y2ZXb8pPW/E2klIBGPmvJZy6GkqdSM
         nvGNdTje8eggvjba3ZHkyYvkFntavsgQZe5R18SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/124] sysctl: add proc_dou8vec_minmax()
Date:   Tue, 18 Apr 2023 14:21:33 +0200
Message-Id: <20230418120312.547417388@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb9444130662c6c13022579c861098f212db2562 ]

Networking has many sysctls that could fit in one u8.

This patch adds proc_dou8vec_minmax() for this purpose.

Note that the .extra1 and .extra2 fields are pointing
to integers, because it makes conversions easier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dc5110c2d959 ("tcp: restrict net.ipv4.tcp_app_win")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c  |  6 ++++
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 65 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index cd7c6c4af83ad..1655b7b2a5abe 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1106,6 +1106,11 @@ static int sysctl_check_table_array(const char *path, struct ctl_table *table)
 			err |= sysctl_err(path, table, "array not allowed");
 	}
 
+	if (table->proc_handler == proc_dou8vec_minmax) {
+		if (table->maxlen != sizeof(u8))
+			err |= sysctl_err(path, table, "array not allowed");
+	}
+
 	return err;
 }
 
@@ -1121,6 +1126,7 @@ static int sysctl_check_table(const char *path, struct ctl_table *table)
 		    (table->proc_handler == proc_douintvec) ||
 		    (table->proc_handler == proc_douintvec_minmax) ||
 		    (table->proc_handler == proc_dointvec_minmax) ||
+		    (table->proc_handler == proc_dou8vec_minmax) ||
 		    (table->proc_handler == proc_dointvec_jiffies) ||
 		    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
 		    (table->proc_handler == proc_dointvec_ms_jiffies) ||
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 161eba9fd9122..4393de94cb32d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -53,6 +53,8 @@ int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
+int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
+			size_t *lenp, loff_t *ppos);
 int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d8b7b28463135..43e907f4cac79 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1061,6 +1061,65 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
+/**
+ * proc_dou8vec_minmax - read a vector of unsigned chars with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(u8) unsigned chars
+ * values from/to the user buffer, treated as an ASCII string. Negative
+ * strings are not allowed.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success or an error on write when the range check fails.
+ */
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp;
+	unsigned int min = 0, max = 255U, val;
+	u8 *data = table->data;
+	struct do_proc_douintvec_minmax_conv_param param = {
+		.min = &min,
+		.max = &max,
+	};
+	int res;
+
+	/* Do not support arrays yet. */
+	if (table->maxlen != sizeof(u8))
+		return -EINVAL;
+
+	if (table->extra1) {
+		min = *(unsigned int *) table->extra1;
+		if (min > 255U)
+			return -EINVAL;
+	}
+	if (table->extra2) {
+		max = *(unsigned int *) table->extra2;
+		if (max > 255U)
+			return -EINVAL;
+	}
+
+	tmp = *table;
+
+	tmp.maxlen = sizeof(val);
+	tmp.data = &val;
+	val = *data;
+	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
+				do_proc_douintvec_minmax_conv, &param);
+	if (res)
+		return res;
+	if (write)
+		*data = val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
+
 static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
 					unsigned int *valp,
 					int write, void *data)
@@ -1612,6 +1671,12 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    void *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
2.39.2



