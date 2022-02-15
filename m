Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2514B72E2
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbiBOPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:35:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbiBOPfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D032F125C9E;
        Tue, 15 Feb 2022 07:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC09615F5;
        Tue, 15 Feb 2022 15:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25922C340F4;
        Tue, 15 Feb 2022 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939052;
        bh=mlCVfXCI/MPFLPPvRfg1e5hONyIiSJQMvH37hKzLE5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skp+IFe+AwBpTnODOC1ml1KxeXWf58SzmRr94ISQsgzDVPespP1DaT1GHpO/BMNtu
         i/v+huyMaAKgV/LndJZC6067fXbCVXR5Z1Tk1V70wAOOLOBIug7LzCtv5nY39srECo
         bEkf0POWa8IyBMA2dWznLs3RqKPAowYJQjOUZonWyE/ARJs7FBMPJ6RPccdCugkcBm
         kkblqZrPg8h8wsvDi2cOljG+Rli1YqB9mdClTHulHk/23VXdKTZZCkLBHBqBzM8KQ2
         rnZbBYwuGB2J0y3uVfO98Khj/rfB0rOmDDt5dLKGyxPIqWBDeySlWf7z1YeeOPSk6E
         wbpjCQOXOopLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brenda Streiff <brenda.streiff@ni.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/17] kconfig: let 'shell' return enough output for deep path names
Date:   Tue, 15 Feb 2022 10:30:29 -0500
Message-Id: <20220215153037.581579-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153037.581579-1-sashal@kernel.org>
References: <20220215153037.581579-1-sashal@kernel.org>
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

