Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFAA49A3E1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369058AbiAYAAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582577AbiAXXSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F57DC07E2B6;
        Mon, 24 Jan 2022 11:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2921AB811FB;
        Mon, 24 Jan 2022 19:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6CCC340E5;
        Mon, 24 Jan 2022 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053666;
        bh=NIojz0mwTHuakUmqbFqSQLDvgevWrG2IYU8Sb4U4LNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlTs+cbkx0l4wm+GjDh3NlYKU/RiGbYxErmGbmAiIify5E8oTrJXNSuUvPFgJJpkp
         EPlTYYUI2XiOKxPuuG6pVDOmT2gOjJB27WzSxvIhFVGWSpSez5xIxMxWOUagjXjN2i
         HZ1uPpSIj0JuIGrRM+rj+yuGQwOvh5lpW6uwp9Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/563] bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
Date:   Mon, 24 Jan 2022 19:38:22 +0100
Message-Id: <20220124184029.137867989@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 6e330ff2f28df..391bc1480dfb1 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -367,6 +367,13 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
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
index 72534a6f4b96e..dc497eaf22663 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4135,8 +4135,7 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 		log->len_total = log_size;
 
 		/* log attributes have to be sane */
-		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
-		    !log->level || !log->ubuf) {
+		if (!bpf_verifier_log_attr_valid(log)) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b43c9de34a2c2..c623c3e549210 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12349,11 +12349,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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



