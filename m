Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C34F6F7C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiDGBMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiDGBMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:12:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE7657AC;
        Wed,  6 Apr 2022 18:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F41AB8268D;
        Thu,  7 Apr 2022 01:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C85C385A6;
        Thu,  7 Apr 2022 01:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293838;
        bh=9TYJYF+vIYn4Rauou50K/Dlok5Da5u2dcSEtn1x3pCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyXLFSXS8ni/BIHniAR6+AagvNrDA0Kp0G12KPSvBmbGIS8HTFVhwuDwjpnbPuiSi
         czXhW7+WSvgI2nxqPz2+gIHFuoS/3t5eB7aqdCOZmrTBGQCmv2swzf/TW1TF11cE9j
         PTdQsyLKFPuGQIeyJgLET8FaxLrUdcHE8XA+A3cLKxylW02Jg/o7FFuGUlYEP6VU6Q
         ynvxfaM4Y54rsM45xXZWc+qLzIAjvXN6W5PK/uD9b4fi/xmxtDK0mSARCsS5cKQjrJ
         x9itlPnSsLgqWt0xk46Z6kBiTmOkNNnZIOv8SmwKbGcdV6op8gN1HUllKidkZnR8AC
         Rm/kMcqVNHUgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 06/31] kconfig: add fflush() before ferror() check
Date:   Wed,  6 Apr 2022 21:10:04 -0400
Message-Id: <20220407011029.113321-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
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
index d3c3a61308ad..94dcec2cc803 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -979,6 +979,7 @@ static int conf_write_autoconf_cmd(const char *autoconf_name)
 
 	fprintf(out, "\n$(deps_config): ;\n");
 
+	fflush(out);
 	ret = ferror(out); /* error check for all fprintf() calls */
 	fclose(out);
 	if (ret)
@@ -1097,6 +1098,7 @@ static int __conf_write_autoconf(const char *filename,
 		if ((sym->flags & SYMBOL_WRITE) && sym->name)
 			print_symbol(file, sym);
 
+	fflush(file);
 	/* check possible errors in conf_write_heading() and print_symbol() */
 	ret = ferror(file);
 	fclose(file);
-- 
2.35.1

