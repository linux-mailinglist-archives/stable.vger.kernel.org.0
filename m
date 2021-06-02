Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A82B397F79
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFBD3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:29:47 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45700 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231214AbhFBD3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:29:46 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S3;
        Wed, 02 Jun 2021 11:27:59 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 1/9] bpf: fix test suite to enable all unpriv program types
Date:   Wed,  2 Jun 2021 11:27:45 +0800
Message-Id: <1622604473-781-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyDZr43ArW7Cr18GFyUKFg_yoW8uF4rpa
        s7Ja1qkFyDWFy2qF18ArW8ZFZ5KFs7Jay0kFZ2yw1jva13XaySqryxKFW5JF93CryFvF1f
        Z343Gr1q9F1DZFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBYb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48MxAIw28IcxkI7V
        AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5X4S5UUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 36641ad61db5ce9befd5eb0071abb36eaff16cfc upstream

Given BPF_PROG_TYPE_CGROUP_SKB program types are also valid in an
unprivileged setting, lets not omit these tests and potentially
have issues fall through the cracks. Make this more obvious by
adding a small test_as_unpriv() helper.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/testing/selftests/bpf/test_verifier.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index e1e4b6a..d33d1d7 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -4798,6 +4798,7 @@ static struct bpf_test tests[] = {
 		.fixup_cgroup_storage = { 1 },
 		.result = REJECT,
 		.errstr = "get_local_storage() doesn't support non-zero flags",
+		.errstr_unpriv = "R2 leaks addr into helper function",
 		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
 	},
 	{
@@ -12963,6 +12964,13 @@ static void get_unpriv_disabled()
 	fclose(fd);
 }
 
+static bool test_as_unpriv(struct bpf_test *test)
+{
+	return !test->prog_type ||
+	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
+	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
+}
+
 static int do_test(bool unpriv, unsigned int from, unsigned int to)
 {
 	int i, passes = 0, errors = 0, skips = 0;
@@ -12973,10 +12981,10 @@ static int do_test(bool unpriv, unsigned int from, unsigned int to)
 		/* Program types that are not supported by non-root we
 		 * skip right away.
 		 */
-		if (!test->prog_type && unpriv_disabled) {
+		if (test_as_unpriv(test) && unpriv_disabled) {
 			printf("#%d/u %s SKIP\n", i, test->descr);
 			skips++;
-		} else if (!test->prog_type) {
+		} else if (test_as_unpriv(test)) {
 			if (!unpriv)
 				set_admin(false);
 			printf("#%d/u %s ", i, test->descr);
-- 
2.1.0

