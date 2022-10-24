Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4575160A8BF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiJXNKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiJXNJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:09:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20241A030F;
        Mon, 24 Oct 2022 05:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14C9ECE1323;
        Mon, 24 Oct 2022 12:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07669C433C1;
        Mon, 24 Oct 2022 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614024;
        bh=MDq74IDoaSx8NT65BkbK9O4FQ2r6jWC7helViqns7qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGNg8/nO8KpojkhvCZYzbc/zOfDKT/LV2foTfWPpsW0qXnqCa4ubUGnQQTVaIcC+f
         jIpEo2qku5Ej/p4RrvU1vYLa/mjzGCmAkrSiwlvxJh3mFx+WueIrZ7Dxmk90aK34t2
         0jR73aYfPrI2jBv1iGLOF6n6zBZLVGCYAPVbhKbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lam Thai <lamthai@arista.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/390] bpftool: Fix a wrong type cast in btf_dumper_int
Date:   Mon, 24 Oct 2022 13:28:20 +0200
Message-Id: <20221024113027.058117575@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0e9310727281..13be48763199 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -416,7 +416,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
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



