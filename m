Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5083C558473
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiFWRnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiFWRka (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311D997A9C;
        Thu, 23 Jun 2022 10:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9312861D17;
        Thu, 23 Jun 2022 17:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75482C341C5;
        Thu, 23 Jun 2022 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004186;
        bh=KRnyYm02/M04mY5xe4aX4sVWRy2Xqe+5jAymsdFwhho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9zNpoPgr9pSxTnR1avjqNNq63ZsBsCKu41j7hZHhg5K1DZdL3I5DOHY97HnZ6j4R
         lyHsrSfyjBpE/ytfDSIU0FRiU3c/cGSx6WvwRXCaU2qrdweGe7nTD0A79UgwzwMnLP
         emMEynBgXcWDngUYy9rv1cOgFO+WoJn0/V1ZS7Is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 215/237] certs/blacklist_hashes.c: fix const confusion in certs blacklist
Date:   Thu, 23 Jun 2022 18:44:09 +0200
Message-Id: <20220623164349.335280309@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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



