Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA286086ED
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiJVHzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiJVHxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB4F2CA7F8;
        Sat, 22 Oct 2022 00:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F20B760B43;
        Sat, 22 Oct 2022 07:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14033C433D6;
        Sat, 22 Oct 2022 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424753;
        bh=TJ2z8sKjOboAwl+iRlgwNORc3olWsnilEuqNtwDNJQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlsCcCqzXltBBqs9UpK62k9WOji7a/dSaXd/Jad8/4XT4frmFyMetkyH+vvakEgN4
         +AQLQboNSjYwq9/wCKkVGzRJllnGSdvbtXFa+8kvxpolXWf4P364Ikyp0mm4oLZaJo
         Lx/QOB7RD8ZDCRvm6OQbtm7tienOY8H8mAGoE50I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Lorenz Bauer <oss@lmb.io>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 234/717] bpf: btf: fix truncated last_member_type_id in btf_struct_resolve
Date:   Sat, 22 Oct 2022 09:21:53 +0200
Message-Id: <20221022072456.420768790@linuxfoundation.org>
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

From: Lorenz Bauer <oss@lmb.io>

[ Upstream commit a37a32583e282d8d815e22add29bc1e91e19951a ]

When trying to finish resolving a struct member, btf_struct_resolve
saves the member type id in a u16 temporary variable. This truncates
the 32 bit type id value if it exceeds UINT16_MAX.

As a result, structs that have members with type ids > UINT16_MAX and
which need resolution will fail with a message like this:

    [67414] STRUCT ff_device size=120 vlen=12
        effect_owners type_id=67434 bits_offset=960 Member exceeds struct_size

Fix this by changing the type of last_member_type_id to u32.

Fixes: a0791f0df7d2 ("bpf: fix BTF limits")
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Lorenz Bauer <oss@lmb.io>
Link: https://lore.kernel.org/r/20220910110120.339242-1-oss@lmb.io
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eb12d4f705cc..ff4a2c0b14ea 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3120,7 +3120,7 @@ static int btf_struct_resolve(struct btf_verifier_env *env,
 	if (v->next_member) {
 		const struct btf_type *last_member_type;
 		const struct btf_member *last_member;
-		u16 last_member_type_id;
+		u32 last_member_type_id;
 
 		last_member = btf_type_member(v->t) + v->next_member - 1;
 		last_member_type_id = last_member->type;
-- 
2.35.1



