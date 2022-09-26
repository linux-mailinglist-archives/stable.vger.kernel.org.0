Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BB95EA51F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbiIZL6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238922AbiIZL45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FF67A753;
        Mon, 26 Sep 2022 03:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 086F0B80760;
        Mon, 26 Sep 2022 10:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5211AC433C1;
        Mon, 26 Sep 2022 10:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189465;
        bh=Fc/MREbXhmqSicKDRHd8xiGwpUeUqcIPl54MgKzE5XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7Mjmb5c496CU8tstQINkerewr6u4TvlH717HZ22fzEvO/Y28DEEP80V5NX34tkEA
         K0PyzgzLt6kxVVadbIw+t1OghxdQil3g2EdJNZOw27jVTzu/bIoI1jEfRBgoXBSTOa
         CJPffmMJYOvbmZYDyjOuCxxEAYF6JZxXKBRBF2/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 196/207] certs: make system keyring depend on built-in x509 parser
Date:   Mon, 26 Sep 2022 12:13:05 +0200
Message-Id: <20220926100815.371137182@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 2154aca21408752eaa3eeaf2ba6e942724ff2a4d ]

Commit e90886291c7c ("certs: make system keyring depend on x509 parser")
is not the right fix because x509_load_certificate_list() can be modular.

The combination of CONFIG_SYSTEM_TRUSTED_KEYRING=y and
CONFIG_X509_CERTIFICATE_PARSER=m still results in the following error:

    LD      .tmp_vmlinux.kallsyms1
  ld: certs/system_keyring.o: in function `load_system_certificate_list':
  system_keyring.c:(.init.text+0x8c): undefined reference to `x509_load_certificate_list'
  make: *** [Makefile:1169: vmlinux] Error 1

Fixes: e90886291c7c ("certs: make system keyring depend on x509 parser")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/certs/Kconfig b/certs/Kconfig
index bf9b511573d7..1f109b070877 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -43,7 +43,7 @@ config SYSTEM_TRUSTED_KEYRING
 	bool "Provide system-wide ring of trusted keys"
 	depends on KEYS
 	depends on ASYMMETRIC_KEY_TYPE
-	depends on X509_CERTIFICATE_PARSER
+	depends on X509_CERTIFICATE_PARSER = y
 	help
 	  Provide a system keyring to which trusted keys can be added.  Keys in
 	  the keyring are considered to be trusted.  Keys may be added at will
-- 
2.35.1



