Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399CF397F8B
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFBDaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:30:15 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45918 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231266AbhFBDaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:30:13 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S11;
        Wed, 02 Jun 2021 11:28:27 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 4.19 9/9] selftests/bpf: Avoid running unprivileged tests with alignment requirements
Date:   Wed,  2 Jun 2021 11:27:53 +0800
Message-Id: <1622604473-781-10-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S11
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW5XrWUCw1rAF4fXr4DCFg_yoW8tr1rpF
        4kGasIkF1kKr17Wry7A3yUWFWFgFyvvrW3tF1rA345Zr4xJ34Iqr4xKFyjqr9xCrZYqr1S
        va4a9345Xw15XFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBSb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
        z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
        AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
        3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIx
        AIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF
        0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87
        Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUyw05UUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>

commit c77b0589ca29ad1859fe7d7c1ecd63c0632379fa upstream

Some architectures have strict alignment requirements. In that case,
the BPF verifier detects if a program has unaligned accesses and
rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
override this check. That, however, will only work when a privileged
user loads a program. An unprivileged user loading a program with this
flag will be rejected prior entering the verifier.

Hence, it does not make sense to load unprivileged programs without
strict alignment when testing the verifier. This patch avoids exactly
that.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Luke Nelson <luke.r.nels@gmail.com>
Link: https://lore.kernel.org/bpf/20201118071640.83773-3-bjorn.topel@gmail.com
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b0fd67c..b443245 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -13045,6 +13045,19 @@ static void get_unpriv_disabled()
 
 static bool test_as_unpriv(struct bpf_test *test)
 {
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	/* Some architectures have strict alignment requirements. In
+	 * that case, the BPF verifier detects if a program has
+	 * unaligned accesses and rejects them. A user can pass
+	 * BPF_F_ANY_ALIGNMENT to a program to override this
+	 * check. That, however, will only work when a privileged user
+	 * loads a program. An unprivileged user loading a program
+	 * with this flag will be rejected prior entering the
+	 * verifier.
+	 */
+	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
+		return false;
+#endif
 	return !test->prog_type ||
 	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
 	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
-- 
2.1.0

