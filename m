Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077124F3512
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiDEIkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237558AbiDEISH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E366AA7A;
        Tue,  5 Apr 2022 01:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744D6B81B18;
        Tue,  5 Apr 2022 08:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA87FC385A2;
        Tue,  5 Apr 2022 08:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146014;
        bh=8FHDcVL8IMA2bK9hMJqhL66NDK8EE4aALxP274Dn2fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxRJHtPFf43ks8unxqb4fydjAM6+u4y88/bbD5J4HfbpsCmZBI7euQfHVVLLEsv0C
         sWJJYX6IyUln0qeRB5nIbsQnxZ+xQzDStJxLiBdWiWepUwm/veZxtDHMnjN2BmT4vw
         y71xIbaidSKyiJPcnJn/OcymdcWYxnHYzSu83y1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Hou Tao <houtao1@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0611/1126] bpf, arm64: Feed byte-offset into bpf line info
Date:   Tue,  5 Apr 2022 09:22:38 +0200
Message-Id: <20220405070425.568594185@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 6a83f3070985..cbc41e261f1e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1133,6 +1133,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	prog->jited_len = prog_size;
 
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



