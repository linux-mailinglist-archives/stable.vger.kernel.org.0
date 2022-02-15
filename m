Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424944B7051
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbiBOPcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:32:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiBOPcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:32:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1D9AF1ED;
        Tue, 15 Feb 2022 07:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F1ECB81AEF;
        Tue, 15 Feb 2022 15:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C74C36AE2;
        Tue, 15 Feb 2022 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938996;
        bh=SZn9YT+v2QlZSehP82U1/aaErN9Any7H5WRysuZTHaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDOgOJvjvHLZgt8Pp9LXvsH0H/UrbmWaQQ0YkiYCY35QrE8dUfAyTJpu6V5tPt9eg
         SI38KMwkd0zKi0bDDu+PPyd8NRgg2o99P6/aWfRlsDI2u3LJmaVxXN0o8Mqc8+tOwR
         YksSPAC1d5SK/gRDDqWJHOsFyz8uHQ931nBbCfjaiIxXnxxfqP5J+74cc0So5L/Y1Z
         45/8aXhB2uGURtvSSI/ZgCArCUF28vJti/PDpE92E0IiyP45i/xtaSUTBlGMVWwab4
         Rhn76QOx7kxxDdV/Uuy2hWamgRFDvpadzHII000HhWzz0LxWsDUfQhkETfuiitU3ze
         9y822X+2ibejg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/33] kconfig: fix failing to generate auto.conf
Date:   Tue, 15 Feb 2022 10:28:31 -0500
Message-Id: <20220215152831.580780-33-sashal@kernel.org>
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
index cf72680cd7692..4a828bca071e8 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -983,14 +983,19 @@ static int conf_write_dep(const char *name)
 
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

