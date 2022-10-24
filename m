Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0160A53D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiJXMWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiJXMUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C91E7C1AD;
        Mon, 24 Oct 2022 04:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A468A612C5;
        Mon, 24 Oct 2022 11:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CAAC433D6;
        Mon, 24 Oct 2022 11:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612685;
        bh=mjCwChMoj0gYfMSKB/1bs/M2Mqi6HjkqAeGsiTHVQ1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXVcrBkg3n+V3dfWIyv7JHmlwjjuKH37UFD9s9DuulHuqay6Zdn73E3b3eX8BG/8U
         XtJ0YE+Wi8QIXdLx1Gah1k2CU9Ek53YAxMIRE/o8t7R8q6EvbSFMOE2VtIp0RhlYSM
         sM0D1f/SmTLnSHqJ+DGXvTbGlujEQOhWuRmxxpQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Lorenz Bauer <oss@lmb.io>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/229] bpf: btf: fix truncated last_member_type_id in btf_struct_resolve
Date:   Mon, 24 Oct 2022 13:29:58 +0200
Message-Id: <20221024113001.628698887@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index 471cc5c117a5..62e05b6283c0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1660,7 +1660,7 @@ static int btf_struct_resolve(struct btf_verifier_env *env,
 	if (v->next_member) {
 		const struct btf_type *last_member_type;
 		const struct btf_member *last_member;
-		u16 last_member_type_id;
+		u32 last_member_type_id;
 
 		last_member = btf_type_member(v->t) + v->next_member - 1;
 		last_member_type_id = last_member->type;
-- 
2.35.1



