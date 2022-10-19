Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181D560411B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiJSKiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiJSKhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:37:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B2B108254;
        Wed, 19 Oct 2022 03:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D0C5B8238A;
        Wed, 19 Oct 2022 08:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE0BC433D6;
        Wed, 19 Oct 2022 08:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169493;
        bh=cSXhoQQnS0sgrIV1JzC+sZBN08NptzZPX3j/Utqtc7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKjD8QTLm/a+WfkIty0SGGd/vBQn+xADypRod55e0jZl1FYDODChzbeIXb3ELnTrr
         /qOW162DDPuYSapBV7B4tME2mRifdMVRK+kZGGIluhFNodWdYToBZHBu9TFq/pIduC
         pXJrK3UsAKf5OBzfjMwEs2ZRbfdYX4NdSrvLnh6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 296/862] libbpf: Fix crash if SEC("freplace") programs dont have attach_prog_fd set
Date:   Wed, 19 Oct 2022 10:26:23 +0200
Message-Id: <20221019083303.081773927@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 749c202cb6ea40f4d7ac95c4a1217a7b506f43a8 ]

Fix SIGSEGV caused by libbpf trying to find attach type in vmlinux BTF
for freplace programs. It's wrong to search in vmlinux BTF and libbpf
doesn't even mark vmlinux BTF as required for freplace programs. So
trying to search anything in obj->vmlinux_btf might cause NULL
dereference if nothing else in BPF object requires vmlinux BTF.

Instead, error out if freplace (EXT) program doesn't specify
attach_prog_fd during at the load time.

Fixes: 91abb4a6d79d ("libbpf: Support attachment of BPF tracing programs to kernel modules")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220909193053.577111-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9056,11 +9056,15 @@ static int libbpf_find_attach_btf_id(str
 	int err = 0;
 
 	/* BPF program's BTF ID */
-	if (attach_prog_fd) {
+	if (prog->type == BPF_PROG_TYPE_EXT || attach_prog_fd) {
+		if (!attach_prog_fd) {
+			pr_warn("prog '%s': attach program FD is not set\n", prog->name);
+			return -EINVAL;
+		}
 		err = libbpf_find_prog_btf_id(attach_name, attach_prog_fd);
 		if (err < 0) {
-			pr_warn("failed to find BPF program (FD %d) BTF ID for '%s': %d\n",
-				 attach_prog_fd, attach_name, err);
+			pr_warn("prog '%s': failed to find BPF program (FD %d) BTF ID for '%s': %d\n",
+				 prog->name, attach_prog_fd, attach_name, err);
 			return err;
 		}
 		*btf_obj_fd = 0;
@@ -9077,7 +9081,8 @@ static int libbpf_find_attach_btf_id(str
 		err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
 	}
 	if (err) {
-		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
+		pr_warn("prog '%s': failed to find kernel BTF type ID of '%s': %d\n",
+			prog->name, attach_name, err);
 		return err;
 	}
 	return 0;


