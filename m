Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1234BDBCD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbiBUJOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241798AbiBUJNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:13:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D18526118;
        Mon, 21 Feb 2022 01:06:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B9CACE0E86;
        Mon, 21 Feb 2022 09:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C89BC340E9;
        Mon, 21 Feb 2022 09:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434383;
        bh=Iu10TYzWNrgXeQsfppIYu11B1WF3/PSnjsNid03wlWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3aa06zup9qnuoQo+xEJ+r/EgEpaqAnNEbtcVWPe3ZpygrJM3cAf06FGMAn9M2zOY
         u8Xa94UNW7CsIBbUba5tyaX/auf3AXrZqpKD1hHAVrPhJ687iNl+lNgMM2p6jc2Plg
         zwZALu/8FcZKFmkCFm+ZoH+1Vp9ofCLi6gtY3R3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/121] kconfig: fix failing to generate auto.conf
Date:   Mon, 21 Feb 2022 09:50:02 +0100
Message-Id: <20220221084924.918764463@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
index a39d93e3c6ae8..867b06c6d2797 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -968,14 +968,19 @@ static int conf_write_dep(const char *name)
 
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



