Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB80259774
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgIAQOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbgIAPfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F0D21534;
        Tue,  1 Sep 2020 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974518;
        bh=6rbQeazlOHI8QHX/gELFfQVrLBu/1GXRAgCTuifkOAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o50LXZrzKk9yk+xkFj4iokOItu0O1CxC06xwG6oDBznmXUS8GqGd44mWRhVwUfqXJ
         MBz4WlM1QsKvQ5iTKKnQGMeqsNTlhS4oDO9Odwhhi79GmBQxIMAKIXTh3mcbzOpy2P
         i7w939iZImhkDkfUD3NJ4q/ZRmhz8zDVFmqPnVEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.4 208/214] kheaders: remove the last bashism to allow sh to run it
Date:   Tue,  1 Sep 2020 17:11:28 +0200
Message-Id: <20200901151002.887700110@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 1463f74f492eea7191f0178e01f3d38371a48210 upstream.

'pushd' ... 'popd' is the last bash-specific code in this script.
One way to avoid it is to run the code in a sub-shell.

With that addressed, you can run this script with sh.

I replaced $(BASH) with $(CONFIG_SHELL), and I changed the hashbang
to #!/bin/sh.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/Makefile        |    2 +-
 kernel/gen_kheaders.sh |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -128,7 +128,7 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG)
 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
 
 quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
-      cmd_genikh = $(BASH) $(srctree)/kernel/gen_kheaders.sh $@
+      cmd_genikh = $(CONFIG_SHELL) $(srctree)/kernel/gen_kheaders.sh $@
 $(obj)/kheaders_data.tar.xz: FORCE
 	$(call cmd,genikh)
 
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
 # This script generates an archive consisting of kernel headers
@@ -57,11 +57,12 @@ rm -rf $cpio_dir
 mkdir $cpio_dir
 
 if [ "$building_out_of_srctree" ]; then
-	pushd $srctree > /dev/null
-	for f in $dir_list
-		do find "$f" -name "*.h";
-	done | cpio --quiet -pd $cpio_dir
-	popd > /dev/null
+	(
+		cd $srctree
+		for f in $dir_list
+			do find "$f" -name "*.h";
+		done | cpio --quiet -pd $cpio_dir
+	)
 fi
 
 # The second CPIO can complain if files already exist which can happen with out


