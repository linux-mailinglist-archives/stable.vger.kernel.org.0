Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2CB6AF079
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCGSas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjCGSaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FFAA5681
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B119B819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BF7C433EF;
        Tue,  7 Mar 2023 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213422;
        bh=65L7r7KkuKdNh2+PpDwe3TFSMNcLF7zCCeHEDyVM7io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJtmgJKsYQ/HGyr2tYVzbrHE7NEWLhazHJQMmhu/JbnFkcJHkQUKUd5Xz1Vh717QF
         d/BBwdTntGwYMQqmNJqgJz8775it/soKP2rwJruD3ypOBRlqpsYCF0VxDPOPI4tASH
         IVQzjaFm9kqhg8bhn9aOUhX1Q0p7Nqdo2g22TBxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bastian Germann <bage@linutronix.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 500/885] builddeb: clean generated package content
Date:   Tue,  7 Mar 2023 17:57:14 +0100
Message-Id: <20230307170024.182721485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

[ Upstream commit c9f9cf2560e40b62015c6c4a04be60f55ce5240e ]

For each binary Debian package, a directory with the package name is
created in the debian directory. Correct the generated file matches in the
package's clean target, which were renamed without adjusting the target.

Fixes: 1694e94e4f46 ("builddeb: match temporary directory name to the package name")
Signed-off-by: Bastian Germann <bage@linutronix.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkdebian | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index a3ac5a716e9fc..5be7e627e7513 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -236,7 +236,7 @@ binary-arch: build-arch
 	KBUILD_BUILD_VERSION=${revision} -f \$(srctree)/Makefile intdeb-pkg
 
 clean:
-	rm -rf debian/*tmp debian/files
+	rm -rf debian/files debian/linux-*
 	\$(MAKE) clean
 
 binary: binary-arch
-- 
2.39.2



