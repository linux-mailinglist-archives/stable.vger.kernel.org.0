Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B53603BFE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJSImN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJSIl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C758A7EFFB;
        Wed, 19 Oct 2022 01:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF652617E8;
        Wed, 19 Oct 2022 08:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E69C433D7;
        Wed, 19 Oct 2022 08:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168756;
        bh=CJh7BEGtcX3x0wey5F8aR0SgwStg4GuMXPmHzzulGjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xp8LemG4PfsYLsu6Nl8h/LFAFYI0FSYHGf1gVquXAaZqlPLVnj/kuxunZ5SHiZ6xm
         AHyanN3gfFXtHLVJqE4w7jrPYEoOlx1z8x696lce1g0co0USNT92VTYKFTEM65H/do
         aDl07haLg4G8KvH3N7z5CBemyp8tfcfcmO07Bui0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 044/862] btf: Export bpf_dynptr definition
Date:   Wed, 19 Oct 2022 10:22:11 +0200
Message-Id: <20221019083251.945344355@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


