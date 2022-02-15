Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769D14B72DE
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbiBOPb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:31:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240309AbiBOPbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:31:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFFAC2E75;
        Tue, 15 Feb 2022 07:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 395C1B81AEF;
        Tue, 15 Feb 2022 15:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C327C340ED;
        Tue, 15 Feb 2022 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938946;
        bh=mlCVfXCI/MPFLPPvRfg1e5hONyIiSJQMvH37hKzLE5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoyYXbKcRDmC13M5fgpYVIHYA9IV2q0ZUyK3T5HJo1l4AxszjeN5wOUyLW94ohi+v
         yvqIftoOWsVnNAhsrliWw90GtDm7Lf7agv0klShjNo3U6DZd30GhNEdYz2ZPo/qsmd
         aNhvZshonLOYbyGSwQRLgFKChQTdCgn5OwEfi3Y1coyPZknOEa8u9Qw9KkSPgPzFas
         +E0diZ83MQV4b6rWfHsYSN684k7lnF9uWg2k/XLmUOSzfXn8SPD6fwfh7WoONSYVI4
         5PrXjAiyArqrzM+DHy6BQAkQiai3lheSpvDRa79A9MshrUO8xz/glk0MD4R/LRt+mM
         qf0gEOhie2J5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brenda Streiff <brenda.streiff@ni.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/33] kconfig: let 'shell' return enough output for deep path names
Date:   Tue, 15 Feb 2022 10:28:17 -0500
Message-Id: <20220215152831.580780-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brenda Streiff <brenda.streiff@ni.com>

[ Upstream commit 8a4c5b2a6d8ea079fa36034e8167de87ab6f8880 ]

The 'shell' built-in only returns the first 256 bytes of the command's
output. In some cases, 'shell' is used to return a path; by bumping up
the buffer size to 4096 this lets us capture up to PATH_MAX.

The specific case where I ran into this was due to commit 1e860048c53e
("gcc-plugins: simplify GCC plugin-dev capability test"). After this
change, we now use `$(shell,$(CC) -print-file-name=plugin)` to return
a path; if the gcc path is particularly long, then the path ends up
truncated at the 256 byte mark, which makes the HAVE_GCC_PLUGINS
depends test always fail.

Signed-off-by: Brenda Streiff <brenda.streiff@ni.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/preprocess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/preprocess.c b/scripts/kconfig/preprocess.c
index 0590f86df6e40..748da578b418c 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -141,7 +141,7 @@ static char *do_lineno(int argc, char *argv[])
 static char *do_shell(int argc, char *argv[])
 {
 	FILE *p;
-	char buf[256];
+	char buf[4096];
 	char *cmd;
 	size_t nread;
 	int i;
-- 
2.34.1

