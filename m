Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8693360B84C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiJXTny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiJXTmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C995106934;
        Mon, 24 Oct 2022 11:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC4F0B818B1;
        Mon, 24 Oct 2022 12:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242E2C433D6;
        Mon, 24 Oct 2022 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615923;
        bh=aB5UaX4PEnngZ+QuGyOLg8annvuPF1tnFpPw2lzRz5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZVeE84GjkkHwwfdzq7WSu2MPwYaVw3t5AxKZbFWCk7oznvF0MsGs07i3eFuYDp5n
         8isylQHx792Ox9RM+Yvg7twQvq7ynEpvemdcTWFqIt6WMEWovy7lhzkXzd8ok4sSr7
         bSqyqAR+GHExeCho/bJ6aXsKPRTCAt4NeYWofRlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/530] kbuild: rpm-pkg: fix breakage when V=1 is used
Date:   Mon, 24 Oct 2022 13:32:16 +0200
Message-Id: <20221024113102.807560086@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

[ Upstream commit 2e07005f4813a9ff6e895787e0c2d1fea859b033 ]

Doing make V=1 binrpm-pkg results in:

 Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.EgV6qJ
 + umask 022
 + cd .
 + /bin/rm -rf /home/scgl/rpmbuild/BUILDROOT/kernel-6.0.0_rc5+-1.s390x
 + /bin/mkdir -p /home/scgl/rpmbuild/BUILDROOT
 + /bin/mkdir /home/scgl/rpmbuild/BUILDROOT/kernel-6.0.0_rc5+-1.s390x
 + mkdir -p /home/scgl/rpmbuild/BUILDROOT/kernel-6.0.0_rc5+-1.s390x/boot
 + make -f ./Makefile image_name
 + cp test -e include/generated/autoconf.h -a -e include/config/auto.conf || ( \ echo >&2; \ echo >&2 " ERROR: Kernel configuration is invalid."; \ echo >&2 " include/generated/autoconf.h or include/config/auto.conf are missing.";\ echo >&2 " Run 'make oldconfig && make prepare' on kernel src to fix it."; \ echo >&2 ; \ /bin/false) arch/s390/boot/bzImage /home/scgl/rpmbuild/BUILDROOT/kernel-6.0.0_rc5+-1.s390x/boot/vmlinuz-6.0.0-rc5+
 cp: invalid option -- 'e'
 Try 'cp --help' for more information.
 error: Bad exit status from /var/tmp/rpm-tmp.EgV6qJ (%install)

Because the make call to get the image name is verbose and prints
additional information.

Fixes: 993bdde94547 ("kbuild: add image_name to no-sync-config-targets")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkspec | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 7c477ca7dc98..951cc60e5a90 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -85,10 +85,10 @@ $S
 	mkdir -p %{buildroot}/boot
 	%ifarch ia64
 	mkdir -p %{buildroot}/boot/efi
-	cp \$($MAKE image_name) %{buildroot}/boot/efi/vmlinuz-$KERNELRELEASE
+	cp \$($MAKE -s image_name) %{buildroot}/boot/efi/vmlinuz-$KERNELRELEASE
 	ln -s efi/vmlinuz-$KERNELRELEASE %{buildroot}/boot/
 	%else
-	cp \$($MAKE image_name) %{buildroot}/boot/vmlinuz-$KERNELRELEASE
+	cp \$($MAKE -s image_name) %{buildroot}/boot/vmlinuz-$KERNELRELEASE
 	%endif
 $M	$MAKE %{?_smp_mflags} INSTALL_MOD_PATH=%{buildroot} modules_install
 	$MAKE %{?_smp_mflags} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
-- 
2.35.1



