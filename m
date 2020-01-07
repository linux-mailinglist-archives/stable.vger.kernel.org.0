Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2FD1333EA
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgAGVBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbgAGVBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26834214D8;
        Tue,  7 Jan 2020 21:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430896;
        bh=VsAKcuwz34bLlP+Y3q+0drDh08CUdjD6iUtyB1R+Apc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijOWSk6lpN9p3aIuO4kJkv5FuNnaOqQ78POgi1boe3qfmIn+3R3YSMPQf9Fi6LrvW
         ebMB6aOW9A+t+4U2fK17fJqbgcZe2mVf5QYo/8eDMh5oax8u2u/mDWQE4eFA676Msm
         V7yByWWi9aP463wu+kZx5UEh2Si9v2+ahQp+b6nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jory A. Pratt" <anarchy@gentoo.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 124/191] gen_initramfs_list.sh: fix bad variable name error
Date:   Tue,  7 Jan 2020 21:54:04 +0100
Message-Id: <20200107205339.616130663@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit cc976614f59bd8e45de8ce988a6bcb5de711d994 upstream.

Prior to commit 858805b336be ("kbuild: add $(BASH) to run scripts with
bash-extension"), this shell script was almost always run by bash since
bash is usually installed on the system by default.

Now, this script is run by sh, which might be a symlink to dash. On such
distributions, the following code emits an error:

  local dev=`LC_ALL=C ls -l "${location}"`

You can reproduce the build error, for example by setting
CONFIG_INITRAMFS_SOURCE="/dev".

    GEN     usr/initramfs_data.cpio.gz
  ./usr/gen_initramfs_list.sh: 131: local: 1: bad variable name
  make[1]: *** [usr/Makefile:61: usr/initramfs_data.cpio.gz] Error 2

This is because `LC_ALL=C ls -l "${location}"` contains spaces.
Surrounding it with double-quotes fixes the error.

Fixes: 858805b336be ("kbuild: add $(BASH) to run scripts with bash-extension")
Reported-by: Jory A. Pratt <anarchy@gentoo.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 usr/gen_initramfs_list.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/usr/gen_initramfs_list.sh
+++ b/usr/gen_initramfs_list.sh
@@ -128,7 +128,7 @@ parse() {
 			str="${ftype} ${name} ${location} ${str}"
 			;;
 		"nod")
-			local dev=`LC_ALL=C ls -l "${location}"`
+			local dev="`LC_ALL=C ls -l "${location}"`"
 			local maj=`field 5 ${dev}`
 			local min=`field 6 ${dev}`
 			maj=${maj%,}


