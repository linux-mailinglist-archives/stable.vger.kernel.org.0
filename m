Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF256B4197
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCJNyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjCJNye (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1100412875
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A085D617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2DDC433EF;
        Fri, 10 Mar 2023 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456473;
        bh=QnUHI5LBCcAy/kdv7Y3sD6nd8AzqimP2Of9ufRjUfak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFEpCgp8XTzfDPE7J6a4DTnOa8Bi5xtUgkR68sUje2mNjPvBCW/C7WRrMZS0PMpy/
         xl5u+CmoIYXz8GtmCey0hYxqeAG88CJBHQWKY8Gq+lenBj+yQC8oSsTpRM6rGiK0OF
         Xl6op8apDSu4saQUJX74/ZnpC31sU0ULYPAarfMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 007/211] objtool: Fix memory leak in create_static_call_sections()
Date:   Fri, 10 Mar 2023 14:36:27 +0100
Message-Id: <20230310133718.944315713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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
index b1a5f658673f0..ea1e7cdeb1b34 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -688,6 +688,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
 			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
 			WARN("static_call: trampoline name malformed: %s", key_name);
+			free(key_name);
 			return -1;
 		}
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
@@ -697,6 +698,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (!key_sym) {
 			if (!opts.module) {
 				WARN("static_call: can't find static_call_key symbol: %s", tmp);
+				free(key_name);
 				return -1;
 			}
 
-- 
2.39.2



