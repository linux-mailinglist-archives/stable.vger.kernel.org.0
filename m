Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E495BDF0A
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 10:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiITIB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 04:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiITIBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 04:01:06 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134C9389F;
        Tue, 20 Sep 2022 01:01:05 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4MWv4x0SPgz9xHMH;
        Tue, 20 Sep 2022 15:56:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAno13_ciljaChgAA--.64537S4;
        Tue, 20 Sep 2022 09:00:35 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        dhowells@redhat.com, jarkko@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        deso@posteo.net, memxor@gmail.com,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v18 02/13] btf: Export bpf_dynptr definition
Date:   Tue, 20 Sep 2022 09:59:40 +0200
Message-Id: <20220920075951.929132-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920075951.929132-1-roberto.sassu@huaweicloud.com>
References: <20220920075951.929132-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwAno13_ciljaChgAA--.64537S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw47JF4UCFy5JFyxurWUCFg_yoW8ZrW3pa
        1rG3y2yr4vqFyxuw1UAr4093ySyw4kXw17CFyvvrWYvrsIqryqqF4UKr43Wr95tryDWFWY
        kF1agr4Yva4UZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbp6wtUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgABBF1jj39AmAABsQ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

eBPF dynamic pointers is a new feature recently added to upstream. It binds
together a pointer to a memory area and its size. The internal kernel
structure bpf_dynptr_kern is not accessible by eBPF programs in user space.
They instead see bpf_dynptr, which is then translated to the internal
kernel structure by the eBPF verifier.

The problem is that it is not possible to include at the same time the uapi
include linux/bpf.h and the vmlinux BTF vmlinux.h, as they both contain the
definition of some structures/enums. The compiler complains saying that the
structures/enums are redefined.

As bpf_dynptr is defined in the uapi include linux/bpf.h, this makes it
impossible to include vmlinux.h. However, in some cases, e.g. when using
kfuncs, vmlinux.h has to be included. The only option until now was to
include vmlinux.h and add the definition of bpf_dynptr directly in the eBPF
program source code from linux/bpf.h.

Solve the problem by using the same approach as for bpf_timer (which also
follows the same scheme with the _kern suffix for the internal kernel
structure).

Add the following line in one of the dynamic pointer helpers,
bpf_dynptr_from_mem():

BTF_TYPE_EMIT(struct bpf_dynptr);

Cc: stable@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>
Fixes: 97e03f521050c ("bpf: Add verifier support for dynptrs")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/helpers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 41aeaf3862ec..7ce1f583b929 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1446,6 +1446,8 @@ BPF_CALL_4(bpf_dynptr_from_mem, void *, data, u32, size, u64, flags, struct bpf_
 {
 	int err;
 
+	BTF_TYPE_EMIT(struct bpf_dynptr);
+
 	err = bpf_dynptr_check_size(size);
 	if (err)
 		goto error;
-- 
2.25.1

