Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5946C6AF4A7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCGTSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbjCGTRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF12C4895
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27BCCB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BFFC433EF;
        Tue,  7 Mar 2023 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215713;
        bh=MDrfGfSgoBEGqplHjaBJsPg8MbP5AfXhL9GYLigsNlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtmnWyvWYCZVoS3O3v03oDVXz0FSXzwzaFQ+294b0PWIAT3UlvPnytQu5Tgpm9OgT
         Zykd5xS1WsflOyTu2Wcsyz2ekJ0IVdkvZ/YKRPd0KPhxPQNIAZVJA5t0RvAcfw+UvQ
         +ijktRrsO3i9zTqswxLgSsf+/DJu9MaUrd0GZvGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bastian Germann <bage@linutronix.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/567] builddeb: clean generated package content
Date:   Tue,  7 Mar 2023 18:01:26 +0100
Message-Id: <20230307165921.029141501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 60a2a63a5e900..32d528a367868 100755
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



