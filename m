Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FAF4F6FFD
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbiDGBQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbiDGBPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:15:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636F3184264;
        Wed,  6 Apr 2022 18:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF0C61DB4;
        Thu,  7 Apr 2022 01:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D15C385A3;
        Thu,  7 Apr 2022 01:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293909;
        bh=D+vFXwBXRXuBTYCHEC0NVh5PkK3UKirFWkGjLaI4aUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7+jsszhLH3sn+Fz/qGeLa4u6llOkQ6jJOig1FXl0VmATLlbeZdXDjyCn6H3AdRXS
         hCu75jjfWUDRa6xNE8nu+HOJft7vcYJiw6Ly4NZLXPUAMpBcL++xFKGzceQ/uYu3Oh
         G2pe5I3qc72dQGXkWdVA3WIR/sCJJMEDam1dtKhDCLlkYYr+WEOR/rYqgyzTkyCf3o
         BCcJ7Sl6xmYc8EURQLM6P21fCAOvH50xSmkrHH/fG+7pRw2RBSLKIwEyPEj2UxWrhQ
         IPdqdyw+pqi8EghxlZEqSbY3YSXG0+nuOQ3AhHWjjLfvFMbdN6lU8J/TnOim5O71Gh
         CCThKHpaATOmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 06/30] kconfig: add fflush() before ferror() check
Date:   Wed,  6 Apr 2022 21:11:16 -0400
Message-Id: <20220407011140.113856-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 868653f421cd37e8ec3880da19f0aac93f5c46cc ]

As David Laight pointed out, there is not much point in calling
ferror() unless you call fflush() first.

Reported-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 027f4c28dc32..60545ed587fb 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -977,6 +977,7 @@ static int conf_write_autoconf_cmd(const char *autoconf_name)
 
 	fprintf(out, "\n$(deps_config): ;\n");
 
+	fflush(out);
 	ret = ferror(out); /* error check for all fprintf() calls */
 	fclose(out);
 	if (ret)
@@ -1095,6 +1096,7 @@ static int __conf_write_autoconf(const char *filename,
 		if ((sym->flags & SYMBOL_WRITE) && sym->name)
 			print_symbol(file, sym);
 
+	fflush(file);
 	/* check possible errors in conf_write_heading() and print_symbol() */
 	ret = ferror(file);
 	fclose(file);
-- 
2.35.1

