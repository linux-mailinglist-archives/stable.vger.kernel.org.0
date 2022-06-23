Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3CF5586CC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiFWSRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiFWSQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89098137;
        Thu, 23 Jun 2022 10:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 210A361EB7;
        Thu, 23 Jun 2022 17:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3755C341C4;
        Thu, 23 Jun 2022 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004970;
        bh=KRnyYm02/M04mY5xe4aX4sVWRy2Xqe+5jAymsdFwhho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+v7DcLlygmYsZ0Ko3d3IGiLdalDbjsAglP41Zelb/9QQIPNCuL+MQXsFdoeCagY7
         GBN2f3bZqFfWq2O7lxinat2RHZQd4D+4+AqwwiwCCkB3xnfagGmOluQtm30eKicDAG
         OvZTn/YPtOrT1jqlUQSRG4jl5+BFJxIQVBtBwbiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/234] certs/blacklist_hashes.c: fix const confusion in certs blacklist
Date:   Thu, 23 Jun 2022 18:44:34 +0200
Message-Id: <20220623164348.908685918@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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



