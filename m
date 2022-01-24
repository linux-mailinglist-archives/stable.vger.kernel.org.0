Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1CA49A271
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365761AbiAXXvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837936AbiAXWpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:45:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9170DC0550D7;
        Mon, 24 Jan 2022 13:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31AF961320;
        Mon, 24 Jan 2022 21:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C610C340E5;
        Mon, 24 Jan 2022 21:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058364;
        bh=7wStGB7xxU3AA3sGqmsWeIoblbJjCxRP7FitXitWhZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMdrdQHw85vb4M/Erlj3HszYx8vCgq5Xt+laSZu5xpGjux330dJLsbUlzA051WSgz
         ZI8DGh61x6Buqc9dJQqX25zfCkGmwXT8dhQ8B1HV6IEpbJQ59v/lwqDD81M9agc7fv
         qoDISpUqu7eI6mqsMTAuggsybhg2f3oOb+D+5bkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0233/1039] bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
Date:   Mon, 24 Jan 2022 19:33:42 +0100
Message-Id: <20220124184133.145073433@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 866de407444398bc8140ea70de1dba5f91cc34ac ]

BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
to set log level as BPF_LOG_KERNEL. The same checking has already
been done in bpf_check(), so factor out a helper to check the
validity of log attributes and use it in both places.

Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20211203053001.740945-1-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 7 +++++++
 kernel/bpf/btf.c             | 3 +--
 kernel/bpf/verifier.c        | 6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c8a78e830fcab..182b16a910849 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -396,6 +396,13 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 		 log->level == BPF_LOG_KERNEL);
 }
 
+static inline bool
+bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
+{
+	return log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
+	       log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
+}
+
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0cb1ceb91ca96..5e037070cb656 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4460,8 +4460,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf) {
+		if (!bpf_verifier_log_attr_valid(log)) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4e51bf3f9603a..8ebabae31a431 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13960,11 +13960,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		log->ubuf = (char __user *) (unsigned long) attr->log_buf;
 		log->len_total = attr->log_size;
 
-		ret = -EINVAL;
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
+		if (!bpf_verifier_log_attr_valid(log)) {
+			ret = -EINVAL;
 			goto err_unlock;
+		}
 	}
 
 	if (IS_ERR(btf_vmlinux)) {
-- 
2.34.1



