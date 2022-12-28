Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2EC657CA2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiL1Ped (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiL1Pec (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCE31648F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 111DEB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B22FC433EF;
        Wed, 28 Dec 2022 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241668;
        bh=CRVDmIxG1GpGqJ2uorF+vSGY0cCgEvkrIvG8qhmtQlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1qz2ucoSxhgDfpze6s3Sjl2KpNn5KWmHBUgEqwfJDVfJQbrjUZAgXvVxEliNB0IC
         zxv5RFx1aXZ9c9c9DWGvGFES3LNtC04hNqbNGbHWoLYZZjpq53z/HOox6WJfBzHD+R
         GoCkvIiJiXkK6jhca67Ezi24fhbc/M4Cvbdol/ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonghong Song <yhs@meta.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0275/1146] bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
Date:   Wed, 28 Dec 2022 15:30:14 +0100
Message-Id: <20221228144337.604964554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 261f4664caffdeb9dff4e83ee3c0334b1c3a552f ]

When support was added for spilled PTR_TO_BTF_ID to be accessed by
helper memory access, the stack slot was not overwritten to STACK_MISC
(and that too is only safe when env->allow_ptr_leaks is true).

This means that helpers who take ARG_PTR_TO_MEM and write to it may
essentially overwrite the value while the verifier continues to track
the slot for spilled register.

This can cause issues when PTR_TO_BTF_ID is spilled to stack, and then
overwritten by helper write access, which can then be passed to BPF
helpers or kfuncs.

Handle this by falling back to the case introduced in a later commit,
which will also handle PTR_TO_BTF_ID along with other pointer types,
i.e. cd17d38f8b28 ("bpf: Permits pointers on stack for helper calls").

Finally, include a comment on why REG_LIVE_WRITTEN is not being set when
clobber is set to true. In short, the reason is that while when clobber
is unset, we know that we won't be writing, when it is true, we *may*
write to any of the stack slots in that range. It may be a partial or
complete write, to just one or many stack slots.

We cannot be sure, hence to be conservative, we leave things as is and
never set REG_LIVE_WRITTEN for any stack slot. However, clobber still
needs to reset them to STACK_MISC assuming writes happened. However read
marks still need to be propagated upwards from liveness point of view,
as parent stack slot's contents may still continue to matter to child
states.

Cc: Yonghong Song <yhs@meta.com>
Fixes: 1d68f22b3d53 ("bpf: Handle spilled PTR_TO_BTF_ID properly when checking stack_boundary")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20221103191013.1236066-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 264b3dc714cc..146056c79cc9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5159,10 +5159,6 @@ static int check_stack_range_initialized(
 			goto mark;
 		}
 
-		if (is_spilled_reg(&state->stack[spi]) &&
-		    base_type(state->stack[spi].spilled_ptr.type) == PTR_TO_BTF_ID)
-			goto mark;
-
 		if (is_spilled_reg(&state->stack[spi]) &&
 		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
@@ -5193,6 +5189,11 @@ static int check_stack_range_initialized(
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
 			      state->stack[spi].spilled_ptr.parent,
 			      REG_LIVE_READ64);
+		/* We do not set REG_LIVE_WRITTEN for stack slot, as we can not
+		 * be sure that whether stack slot is written to or not. Hence,
+		 * we must still conservatively propagate reads upwards even if
+		 * helper may write to the entire memory range.
+		 */
 	}
 	return update_stack_depth(env, state, min_off);
 }
-- 
2.35.1



