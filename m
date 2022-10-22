Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8156087E6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiJVIHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiJVIFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2862C6E26;
        Sat, 22 Oct 2022 00:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423F560ADE;
        Sat, 22 Oct 2022 07:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CE8C433D6;
        Sat, 22 Oct 2022 07:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424228;
        bh=CJh7BEGtcX3x0wey5F8aR0SgwStg4GuMXPmHzzulGjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsFjGY/O5L3RP3TCR/3fHwBe/YmAhXpJFoUokAYYPKhmz05fqbSSUvAtEfrIKoRT4
         XG3x265OKh1z/ZfMXZ+Li3p1516Q4mhfruSuZOUJKWHpAvf22fe5rkX/D3eyaM4J/i
         KIsc6VPkTQPxRRnfhTUN64jKkjarT+Y0C7gjpssY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 039/717] btf: Export bpf_dynptr definition
Date:   Sat, 22 Oct 2022 09:18:38 +0200
Message-Id: <20221022072422.045996090@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 00f146413ccb6c84308e559281449755c83f54c5 upstream.

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
Tested-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/r/20220920075951.929132-3-roberto.sassu@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1468,6 +1468,8 @@ BPF_CALL_4(bpf_dynptr_from_mem, void *,
 {
 	int err;
 
+	BTF_TYPE_EMIT(struct bpf_dynptr);
+
 	err = bpf_dynptr_check_size(size);
 	if (err)
 		goto error;


