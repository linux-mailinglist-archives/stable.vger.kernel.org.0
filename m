Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6D5F8FF1
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiJIWTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiJIWS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:18:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094B83BC63;
        Sun,  9 Oct 2022 15:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E5F60CA0;
        Sun,  9 Oct 2022 22:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD596C433D6;
        Sun,  9 Oct 2022 22:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353696;
        bh=csB+pO8pL0qHwlqK0R5dM8S9SaeLsh5olOWztVLv/ec=;
        h=From:To:Cc:Subject:Date:From;
        b=R13aVpDr2fNJGqX+1ykGseyzdihQVkUQUgj7Ge4FGCDmOSjmTXlzEJU7kisZXnW61
         8SBxGtUh/oZHOTNBC8Znkjoyz8qZkvsomqD3MeWRmBsrqS1lYTwcDgD8XuIaBD15Tt
         qScZgP0GBZXglmVtj3RF5zopX/7RUZgndDhRYaH0HBy4OiVG7Nyq4cEzu59SBOYv2E
         H3IEtPChYaFD17S9KUkbtAFffTSxlZzSR1OqDjozgaPGONMBnzxd/+oN2Yfdvm7kfm
         +NNBFudULzaUN9jc2cd7q+kHxYZgeBJKb/pAE+obrB65z3EJIXR+h0aNHDU6mm50o5
         zCyQv7KJqox1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hengqi Chen <hengqi.chen@gmail.com>, Goro Fuji <goro@fastly.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 01/73] libbpf: Do not require executable permission for shared libraries
Date:   Sun,  9 Oct 2022 18:13:39 -0400
Message-Id: <20221009221453.1216158-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit 9e32084ef1c33a87a736d6ce3fcb95b60dac9aa1 ]

Currently, resolve_full_path() requires executable permission for both
programs and shared libraries. This causes failures on distos like Debian
since the shared libraries are not installed executable and Linux is not
requiring shared libraries to have executable permissions. Let's remove
executable permission check for shared libraries.

Reported-by: Goro Fuji <goro@fastly.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220806102021.3867130-1-hengqi.chen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 266357b1dca1..91bfe42e5cf4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11206,15 +11206,17 @@ static const char *arch_specific_lib_paths(void)
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
 	const char *search_paths[3] = {};
-	int i;
+	int i, perm;
 
 	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
+		perm = R_OK;
 	} else {
 		search_paths[0] = getenv("PATH");
 		search_paths[1] = "/usr/bin:/usr/sbin";
+		perm = R_OK | X_OK;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(search_paths); i++) {
@@ -11233,8 +11235,8 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 			if (!seg_len)
 				continue;
 			snprintf(result, result_sz, "%.*s/%s", seg_len, s, file);
-			/* ensure it is an executable file/link */
-			if (access(result, R_OK | X_OK) < 0)
+			/* ensure it has required permissions */
+			if (access(result, perm) < 0)
 				continue;
 			pr_debug("resolved '%s' to '%s'\n", file, result);
 			return 0;
-- 
2.35.1

