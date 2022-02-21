Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456AB4BE56F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiBUKAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:00:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353575AbiBUJ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A955A330;
        Mon, 21 Feb 2022 01:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62BA8B80EBB;
        Mon, 21 Feb 2022 09:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878FDC340E9;
        Mon, 21 Feb 2022 09:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435617;
        bh=9Dj2S3rmu+atdgPw4d5KgzUpQOmctFRQN5kYq9qjlHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAIS9j0CeIdx6jQ1BGsXfyu5KqcC1T9Yoatrj3dbvMA4PGxj/ADh5eosWC1xOLX8A
         KTgBm+tkGxHKQ6WFoo60xvYyUW4mrC5sh1XXK6aG4yw/Ryget04O0PjLLpC217O6oh
         e0G0nMTq7W8lLh4vBPueBJgXNZ9fK5Bx2SLfWqi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 227/227] kconfig: fix failing to generate auto.conf
Date:   Mon, 21 Feb 2022 09:50:46 +0100
Message-Id: <20220221084942.338752004@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jing Leng <jleng@ambarella.com>

[ Upstream commit 1b9e740a81f91ae338b29ed70455719804957b80 ]

When the KCONFIG_AUTOCONFIG is specified (e.g. export \
KCONFIG_AUTOCONFIG=output/config/auto.conf), the directory of
include/config/ will not be created, so kconfig can't create deps
files in it and auto.conf can't be generated.

Signed-off-by: Jing Leng <jleng@ambarella.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 00284c03da4d3..027f4c28dc320 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -992,14 +992,19 @@ static int conf_write_autoconf_cmd(const char *autoconf_name)
 
 static int conf_touch_deps(void)
 {
-	const char *name;
+	const char *name, *tmp;
 	struct symbol *sym;
 	int res, i;
 
-	strcpy(depfile_path, "include/config/");
-	depfile_prefix_len = strlen(depfile_path);
-
 	name = conf_get_autoconfig_name();
+	tmp = strrchr(name, '/');
+	depfile_prefix_len = tmp ? tmp - name + 1 : 0;
+	if (depfile_prefix_len + 1 > sizeof(depfile_path))
+		return -1;
+
+	strncpy(depfile_path, name, depfile_prefix_len);
+	depfile_path[depfile_prefix_len] = 0;
+
 	conf_read_simple(name, S_DEF_AUTO);
 	sym_calc_value(modules_sym);
 
-- 
2.34.1



