Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2F4B707F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiBOPhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbiBOPf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781FAA00D;
        Tue, 15 Feb 2022 07:31:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB40B81AF7;
        Tue, 15 Feb 2022 15:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6EDC340F2;
        Tue, 15 Feb 2022 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939075;
        bh=Nx8I+gibSos3xMV/GicdB2i4/EZI7310QJI1YsXKSUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7+8CgKcxw58jst/94v0ADWOPByTcrWQoDDYv2r6pelPB3ewW0toxiPlE+eNzx2r6
         oGHshMXXNzLl4CNmhvy+jYYRDzwm3qEnAxl3f2Vt9fPtod7qFwyDbegJic57DAtbPO
         AdBEv7HbbMRwFmGPabenytu95JO6TosJVA1ikPfHqWeAIZ79LEmvfe9yLhWc4iHCOh
         z/bW2gTKhlo3rZn+ZTLpYWS16dUrJTV70Y5gy163W1IVLWqQGsznHgfqh3RM0Vpx/h
         oimfg/lg1gKsXLdMW/4O+JJySqOH44PUBKOyhMwHvgy8Gcj4uT05rwXh8OWhpYBpBM
         naDilNtLQ95fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brenda Streiff <brenda.streiff@ni.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/11] kconfig: let 'shell' return enough output for deep path names
Date:   Tue, 15 Feb 2022 10:30:59 -0500
Message-Id: <20220215153104.581786-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153104.581786-1-sashal@kernel.org>
References: <20220215153104.581786-1-sashal@kernel.org>
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
index 389814b02d06b..8c7e51a6273cc 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -138,7 +138,7 @@ static char *do_lineno(int argc, char *argv[])
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

