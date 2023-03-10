Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16446B49D8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjCJPQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjCJPP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:15:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C058926C1F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C5961ADB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361E1C433EF;
        Fri, 10 Mar 2023 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460734;
        bh=V3dQUIx3an1IdFmcrBuU+MmfXEpMJCj/2PIUur3Whn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpcwC/SU4jpGW9zQHiHTeVk7ynseTtjdf/DXu+tzY+MOLcAcRIfAOObf7fzTyaQ1g
         fVtB346TWV+T0RSWWDkwIIfChn2/Viwnlz5eNdWcDgZtOSshz4Z4dB0vfykdfWdS4g
         aeE7MtdnbUDtO34273z1ub8W1J10Vyjyunl72UU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/529] objtool: Fix memory leak in create_static_call_sections()
Date:   Fri, 10 Mar 2023 14:39:36 +0100
Message-Id: <20230310133824.993245887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 3da73f102309fe29150e5c35acd20dd82063ff67 ]

strdup() allocates memory for key_name. We need to release the memory in
the following error paths. Add free() to avoid memory leak.

Fixes: 1e7e47883830 ("x86/static_call: Add inline static call implementation for x86-64")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20221205080642.558583-1-linmq006@gmail.com
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5c4190382a51a..9a0a54194636c 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -572,6 +572,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
 			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
 			WARN("static_call: trampoline name malformed: %s", key_name);
+			free(key_name);
 			return -1;
 		}
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
@@ -581,6 +582,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (!key_sym) {
 			if (!module) {
 				WARN("static_call: can't find static_call_key symbol: %s", tmp);
+				free(key_name);
 				return -1;
 			}
 
-- 
2.39.2



