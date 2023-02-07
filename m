Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707B068D7C2
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjBGNDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjBGNC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F237EE4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 171F4B81979
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D98C433EF;
        Tue,  7 Feb 2023 13:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774959;
        bh=MD9RcAccVG2aSKGg6cMa2PfqMKg1BGDfhdXtOS/+uko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvpiVFh65fVFt/Df51DmI7UiV6J3sWrVICCgBzDlwr56b+KAzeJE/8iotquQXEkK9
         nX2IxqZHIGC5DR0hCUuRcCMBUouzzZVDSMgc17yfdPWtM/TVT3XG00nNIFj06LiCG2
         +jjjqL+fAd4aaBcugDxoEGVzVLc4jqfMWgDyuwtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Luebbe <jlu@pengutronix.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/208] certs: Fix build error when PKCS#11 URI contains semicolon
Date:   Tue,  7 Feb 2023 13:55:45 +0100
Message-Id: <20230207125638.479822972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Luebbe <jlu@pengutronix.de>

[ Upstream commit b1c3d2beed8ef3699fab106340e33a79052df116 ]

When CONFIG_MODULE_SIG_KEY is PKCS#11 URI (pkcs11:*) and contains a
semicolon, signing_key.x509 fails to build:

  certs/extract-cert pkcs11:token=foo;object=bar;pin-value=1111 certs/signing_key.x509
  Usage: extract-cert <source> <dest>

Add quotes to the extract-cert argument to avoid splitting by the shell.

This approach was suggested by Masahiro Yamada <masahiroy@kernel.org>.

Fixes: 129ab0d2d9f3 ("kbuild: do not quote string values in include/config/auto.conf")
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/certs/Makefile b/certs/Makefile
index 9486ed924731..799ad7b9e68a 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -23,8 +23,8 @@ $(obj)/blacklist_hash_list: $(CONFIG_SYSTEM_BLACKLIST_HASH_LIST) FORCE
 targets += blacklist_hash_list
 
 quiet_cmd_extract_certs  = CERT    $@
-      cmd_extract_certs  = $(obj)/extract-cert $(extract-cert-in) $@
-extract-cert-in = $(or $(filter-out $(obj)/extract-cert, $(real-prereqs)),"")
+      cmd_extract_certs  = $(obj)/extract-cert "$(extract-cert-in)" $@
+extract-cert-in = $(filter-out $(obj)/extract-cert, $(real-prereqs))
 
 $(obj)/system_certificates.o: $(obj)/x509_certificate_list
 
-- 
2.39.0



