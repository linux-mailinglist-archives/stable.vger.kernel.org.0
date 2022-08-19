Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886B059A16A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351302AbiHSQLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351858AbiHSQKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:10:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E971D11232B;
        Fri, 19 Aug 2022 08:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83FDC614DA;
        Fri, 19 Aug 2022 15:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C1BC433C1;
        Fri, 19 Aug 2022 15:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924619;
        bh=OrNeTHxlYDIcYbDW02upfTtUi0ToYWNUAMpL14jUXmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJv23HXYzG/KJaCBssesTZEcGmvuWaLN7IUe0ZFBAnyd4j1SlzW8nqFqIgxicQK/b
         Upl6IfjsoWbf14SaKoXO0K9aFBw3FlzlD1Vj9Tg58aWgDUEQYcTbvKUo+tz0HRu7vG
         gGfDbo+DM+u3rC9Mulx4/v+xHuwNNNqw429MvUxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/545] bpf: Fix subprog names in stack traces.
Date:   Fri, 19 Aug 2022 17:39:59 +0200
Message-Id: <20220819153839.610541820@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 9c7c48d6a1e2eb5192ad5294c1c4dbd42a88e88b ]

The commit 7337224fc150 ("bpf: Improve the info.func_info and info.func_info_rec_size behavior")
accidently made bpf_prog_ksym_set_name() conservative for bpf subprograms.
Fixed it so instead of "bpf_prog_tag_F" the stack traces print "bpf_prog_tag_full_subprog_name".

Fixes: 7337224fc150 ("bpf: Improve the info.func_info and info.func_info_rec_size behavior")
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220714211637.17150-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15ddc4292bc0..de636b7445b1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11152,6 +11152,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		/* Below members will be freed only at prog->aux */
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
+		func[i]->aux->func_info_cnt = prog->aux->func_info_cnt;
 		func[i]->aux->poke_tab = prog->aux->poke_tab;
 		func[i]->aux->size_poke_tab = prog->aux->size_poke_tab;
 
@@ -11164,9 +11165,6 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 				poke->aux = func[i]->aux;
 		}
 
-		/* Use bpf_prog_F_tag to indicate functions in stack traces.
-		 * Long term would need debug info to populate names
-		 */
 		func[i]->aux->name[0] = 'F';
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
-- 
2.35.1



