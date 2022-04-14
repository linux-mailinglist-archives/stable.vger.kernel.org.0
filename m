Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7415014C3
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345397AbiDNNuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344459AbiDNNle (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293291C6;
        Thu, 14 Apr 2022 06:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75356190F;
        Thu, 14 Apr 2022 13:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE959C385A1;
        Thu, 14 Apr 2022 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943549;
        bh=JdJ0HbSg4MeXgHJUdgd3PfEa8l1Ei+cKC1N15FFxCi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3WrijyKoh+qgwyI5IXAbn05/xtu8XZ2RvZVyTOtx5GCXL9mObTpcH1UnFjFP2BuN
         Dfov58XWGRHA4fCvSsN5tmNtJPQDZWPCRRGdNUTF4c3osLng7HitRTqJ+bUXLK5iKo
         1TMOTKk+mVDuz4ePHd4nSEYAQXNRZ4wvY4EQ2amU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Hou Tao <houtao1@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/475] bpf, arm64: Feed byte-offset into bpf line info
Date:   Thu, 14 Apr 2022 15:09:40 +0200
Message-Id: <20220414110900.587468458@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit dda7596c109fc382876118627e29db7607cde35d ]

insn_to_jit_off passed to bpf_prog_fill_jited_linfo() is calculated in
instruction granularity instead of bytes granularity, but BPF line info
requires byte offset.

bpf_prog_fill_jited_linfo() will be the last user of ctx.offset before
it is freed, so convert the offset into byte-offset before calling into
bpf_prog_fill_jited_linfo() in order to fix the line info dump on arm64.

Fixes: 37ab566c178d ("bpf: arm64: Enable arm64 jit to provide bpf_line_info")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220226121906.5709-3-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 6332288dfb44..17a8d1484f9b 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -986,6 +986,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	prog->jited_len = image_size;
 
 	if (!prog->is_func || extra_pass) {
+		int i;
+
+		/* offset[prog->len] is the size of program */
+		for (i = 0; i <= prog->len; i++)
+			ctx.offset[i] *= AARCH64_INSN_SIZE;
 		bpf_prog_fill_jited_linfo(prog, ctx.offset + 1);
 out_off:
 		kfree(ctx.offset);
-- 
2.34.1



