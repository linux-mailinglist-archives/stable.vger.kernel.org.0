Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13415317C1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiEWRa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239982AbiEWR2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF81185ED4;
        Mon, 23 May 2022 10:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3E760B35;
        Mon, 23 May 2022 17:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A50C385A9;
        Mon, 23 May 2022 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326663;
        bh=9TYJYF+vIYn4Rauou50K/Dlok5Da5u2dcSEtn1x3pCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sX1LJoZwNZHRLiKnRdbdwI6wgmZdpAB8Y/lNE/ONMT1NeiYJkHSr70ymaqvyb4hPr
         i+l9kVqEz3Eqvghkw6+4cWWJpWJ1ZXJN+YWvVoIxkDoey07oae1fHw8+O/DojjWXaL
         2yM3ZzU+wA1LTNkvjoFq0C5MnqZdchrPbPfhldW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 021/158] kconfig: add fflush() before ferror() check
Date:   Mon, 23 May 2022 19:02:58 +0200
Message-Id: <20220523165834.123495216@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



