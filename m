Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8D0603D1C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiJSI5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiJSI4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B947CE85;
        Wed, 19 Oct 2022 01:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442906187C;
        Wed, 19 Oct 2022 08:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D8BC433C1;
        Wed, 19 Oct 2022 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169511;
        bh=G3B/VF+S16OMDOiqigw8aZvlTpB0ciFKkf7elAxmEL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmHHcEOZZLP1W7dByqKbK4yIZh7tRb8IHVlN6d5+8W+REWJ80L3OVdRAu61Kjph+D
         ga3QvgKlp5nAKuP7MWnYrpup4tUQP0LCMe4+jLhqszkSleb50NfNAnrCsJMIeKiDml
         ZDgZXXMz/sd6N/oKbb5CRuMC/zN1bfdsOovWJADg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Lorenz Bauer <oss@lmb.io>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 271/862] bpf: btf: fix truncated last_member_type_id in btf_struct_resolve
Date:   Wed, 19 Oct 2022 10:25:58 +0200
Message-Id: <20221019083302.004100561@linuxfoundation.org>
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
index 7e64447659f3..36fd4b509294 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3128,7 +3128,7 @@ static int btf_struct_resolve(struct btf_verifier_env *env,
 	if (v->next_member) {
 		const struct btf_type *last_member_type;
 		const struct btf_member *last_member;
-		u16 last_member_type_id;
+		u32 last_member_type_id;
 
 		last_member = btf_type_member(v->t) + v->next_member - 1;
 		last_member_type_id = last_member->type;
-- 
2.35.1



