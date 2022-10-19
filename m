Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC99A604270
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiJSLDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiJSLCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCD0AE86A;
        Wed, 19 Oct 2022 03:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81632B824AC;
        Wed, 19 Oct 2022 09:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94EAC433D7;
        Wed, 19 Oct 2022 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170590;
        bh=ViUItGQxEFe5clm+nOnl0yUEomw7O/ntvn4zFXwEoTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/wul6mNsT4M/WLJKotjcoXs18B+ZrXfyZNIODJpDMRxg0Y4wt+YYVh/Gvv6Q7C8F
         kgAVWYwlGZPjG0lOLFRXZoQTbARXDVYkJ0FEjdSczZKlFz+/Jjkys5M/aqN/0KyUn+
         rXnOxkkZNZqvZH/3mCI5FkvbfMYxCLHct4exXcSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goro Fuji <goro@fastly.com>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 680/862] libbpf: Do not require executable permission for shared libraries
Date:   Wed, 19 Oct 2022 10:32:47 +0200
Message-Id: <20221019083320.022071682@linuxfoundation.org>
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
 tools/lib/bpf/libbpf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10667,15 +10667,17 @@ static const char *arch_specific_lib_pat
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
@@ -10694,8 +10696,8 @@ static int resolve_full_path(const char
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


