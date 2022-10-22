Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9A6086A1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiJVHvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiJVHtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACF229C4A8;
        Sat, 22 Oct 2022 00:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0500460BA1;
        Sat, 22 Oct 2022 07:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F76C433D6;
        Sat, 22 Oct 2022 07:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424608;
        bh=nWPW16Q4nBgN2GQRonT5pZsCqcDqtb3Q2XgWjNdjRxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHrMRUZierzEz1Xv3S+M7eDho54hpEKD0p2I2zzcJon1RmV+3gO4lFpyRs+so+/W1
         eDiRvX/oXY8qKqJ6dwe9wV1iEIMENpNeRFz15jaZ0Qg4wijebPsyG9e4vPb8TMpk1S
         xhHF9r3ftM4JWTqazdQnO6V3qH2EJZAD0mQI+KR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lam Thai <lamthai@arista.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 210/717] bpftool: Fix a wrong type cast in btf_dumper_int
Date:   Sat, 22 Oct 2022 09:21:29 +0200
Message-Id: <20221022072452.433485524@linuxfoundation.org>
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

From: Lam Thai <lamthai@arista.com>

[ Upstream commit 7184aef9c0f7a81db8fd18d183ee42481d89bf35 ]

When `data` points to a boolean value, casting it to `int *` is problematic
and could lead to a wrong value being passed to `jsonw_bool`. Change the
cast to `bool *` instead.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Lam Thai <lamthai@arista.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220824225859.9038-1-lamthai@arista.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index f5dddf8ef404..6d041d1f5395 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -426,7 +426,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 					     *(char *)data);
 		break;
 	case BTF_INT_BOOL:
-		jsonw_bool(jw, *(int *)data);
+		jsonw_bool(jw, *(bool *)data);
 		break;
 	default:
 		/* shouldn't happen */
-- 
2.35.1



