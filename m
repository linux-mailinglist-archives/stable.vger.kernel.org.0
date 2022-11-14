Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB44C627FD5
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiKNNCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiKNNB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5A12A24A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3844D61175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457CFC433C1;
        Mon, 14 Nov 2022 13:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430914;
        bh=EN8PDTYrlJ4aRx+LtqkFD4q3I7pYiy/YQ2/dhRRdkyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByqI0WNOkJhjy9d9fLEXfbu45Z+rmdFaiTDZlqxUAUTLgwOsIXvS70cQ4E1pwNf0T
         JAh25Bxg4G5uGllmX/kQKSQIRJoCsY5KFAmaEwh/AMutgU8M0ASk5uR7j6WZSEj+zs
         kUnY9roGHsfuSQhOC9mTCfMhHuUCRLY43vYk/rW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Youlin Li <liulin063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 033/190] bpf: Fix wrong reg type conversion in release_reference()
Date:   Mon, 14 Nov 2022 13:44:17 +0100
Message-Id: <20221114124500.214780132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Youlin Li <liulin063@gmail.com>

[ Upstream commit f1db20814af532f85e091231223e5e4818e8464b ]

Some helper functions will allocate memory. To avoid memory leaks, the
verifier requires the eBPF program to release these memories by calling
the corresponding helper functions.

When a resource is released, all pointer registers corresponding to the
resource should be invalidated. The verifier use release_references() to
do this job, by apply  __mark_reg_unknown() to each relevant register.

It will give these registers the type of SCALAR_VALUE. A register that
will contain a pointer value at runtime, but of type SCALAR_VALUE, which
may allow the unprivileged user to get a kernel pointer by storing this
register into a map.

Using __mark_reg_not_init() while NOT allow_ptr_leaks can mitigate this
problem.

Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
Signed-off-by: Youlin Li <liulin063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221103093440.3161-1-liulin063@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7bfeb249214e..69fb46fdf763 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6552,8 +6552,12 @@ static int release_reference(struct bpf_verifier_env *env,
 		return err;
 
 	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
-		if (reg->ref_obj_id == ref_obj_id)
-			__mark_reg_unknown(env, reg);
+		if (reg->ref_obj_id == ref_obj_id) {
+			if (!env->allow_ptr_leaks)
+				__mark_reg_not_init(env, reg);
+			else
+				__mark_reg_unknown(env, reg);
+		}
 	}));
 
 	return 0;
-- 
2.35.1



