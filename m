Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3338D5F8F5C
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiJIWIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiJIWIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1666A275D5;
        Sun,  9 Oct 2022 15:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A78C560C93;
        Sun,  9 Oct 2022 22:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252CFC4347C;
        Sun,  9 Oct 2022 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353279;
        bh=rtZm1ZNYm9K689JvinO0L3Z4ajEDSTjzpaS8oPPrgBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJN4bnnSc7NRFwWg4AsG2fNjfGxlqKZaKA2giKBpo0kVDlVggAplfetauU609J8BK
         +XKCJXkcenB2/TTXThUDdP2S1Ou+v2VNhd1x8XI9alvbq4js6v+4u/sr/x78SnMX9o
         QD7tZK67B/iCzgGV3skaiK53G+8Jm9CRrBBM6tXAdtQUoeQhOLiIknvLponB/U65je
         L+lt/6REVkMaNgwmwcHbgoxT8o6bkXcrBDDC8cVLB7oNCy0/t9ex6kndigt5SGkeCW
         MbrIcIYX2kYIbBpAYTP4r9yQ3uRL4yKAosjhBcC1IZ1FKRMdJq/ScixF3Gd4WPfu6Y
         AYNRTQ3LRKW6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hengqi Chen <hengqi.chen@gmail.com>, Goro Fuji <goro@fastly.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/77] libbpf: Do not require executable permission for shared libraries
Date:   Sun,  9 Oct 2022 18:06:39 -0400
Message-Id: <20221009220754.1214186-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index 50d41815f431..c09a781d31bb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10662,15 +10662,17 @@ static const char *arch_specific_lib_paths(void)
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
@@ -10689,8 +10691,8 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
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

