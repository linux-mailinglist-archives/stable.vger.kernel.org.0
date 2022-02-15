Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8DA4B7275
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiBOPaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:30:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240089AbiBOP3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E44BF521;
        Tue, 15 Feb 2022 07:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE250615E6;
        Tue, 15 Feb 2022 15:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44F0C340EB;
        Tue, 15 Feb 2022 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938909;
        bh=RzY8vR9pOqT3Q4SfGqSnnyOelhCAOz02hOIQHVh8MHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fh6LgercNfw9nMTwNJfq4KrWYMq60LL/0koKHqW69Y8rAx0uY2h6icYaYI4RiJcJq
         swnN6WHLidLqGhSMNw8amfOg76dFURnlDsUy1b3/DuCK8h5/IE6y95+2YbeFpbOmB8
         PPMFtsVzifL96VEBpmHXlH7q3w+brs1aALi118ykHdN+NyxjyxxmfcFjaS1TVun0hy
         FAo9BD+zrnML68mQjYJkfjqFjJ4bQZfK7SN+mJAH4sbYpHbX+naAytavnbRsyYkRQX
         F+eCIcRK2ssPUAIkGJEgABetI7IaiuUJ1AGtrIlXHFJ6fv/jIXTw2QiD4GW7/X12Gu
         dyMO0N0wKOIPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 34/34] kconfig: fix failing to generate auto.conf
Date:   Tue, 15 Feb 2022 10:26:57 -0500
Message-Id: <20220215152657.580200-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
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
index 42bc56ee238c8..8954e28a225cb 100644
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

