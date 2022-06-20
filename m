Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBC551E51
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350319AbiFTOBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351834AbiFTNz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174F6340EB;
        Mon, 20 Jun 2022 06:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 593AD60AC0;
        Mon, 20 Jun 2022 13:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62180C3411B;
        Mon, 20 Jun 2022 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731292;
        bh=KRnyYm02/M04mY5xe4aX4sVWRy2Xqe+5jAymsdFwhho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBPFwAI2k+hhmtb3ACEE5p/q7rKdx5tfUG4qAnX8cQG3HZ/Eb9mq8hJvHDowzcfRm
         R+rAn5uT482RQpBjPCv9uY5dAqf9uKSJWxFQNziF8r6qsPXLhVA7Jw9niF+CI+eLA8
         oRTWSVaRvrEFyVBRMl7/bQN8SOkIZBknsDZWQmzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/240] certs/blacklist_hashes.c: fix const confusion in certs blacklist
Date:   Mon, 20 Jun 2022 14:51:56 +0200
Message-Id: <20220620124745.202364357@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 6a1c3767d82ed8233de1263aa7da81595e176087 ]

This file fails to compile as follows:

  CC      certs/blacklist_hashes.o
certs/blacklist_hashes.c:4:1: error: ignoring attribute ‘section (".init.data")’ because it conflicts with previous ‘section (".init.rodata")’ [-Werror=attributes]
    4 | const char __initdata *const blacklist_hashes[] = {
      | ^~~~~
In file included from certs/blacklist_hashes.c:2:
certs/blacklist.h:5:38: note: previous declaration here
    5 | extern const char __initconst *const blacklist_hashes[];
      |                                      ^~~~~~~~~~~~~~~~

Apply the same fix as commit 2be04df5668d ("certs/blacklist_nohashes.c:
fix const confusion in certs blacklist").

Fixes: 734114f8782f ("KEYS: Add a system blacklist keyring")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Mickaël Salaün <mic@linux.microsoft.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/blacklist_hashes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/certs/blacklist_hashes.c b/certs/blacklist_hashes.c
index 344892337be0..d5961aa3d338 100644
--- a/certs/blacklist_hashes.c
+++ b/certs/blacklist_hashes.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "blacklist.h"
 
-const char __initdata *const blacklist_hashes[] = {
+const char __initconst *const blacklist_hashes[] = {
 #include CONFIG_SYSTEM_BLACKLIST_HASH_LIST
 	, NULL
 };
-- 
2.35.1



