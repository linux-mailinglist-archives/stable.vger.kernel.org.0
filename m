Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3568D3C9EBC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhGOMjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhGOMjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B72E61374;
        Thu, 15 Jul 2021 12:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352575;
        bh=NGBGKRKOifI8pVOearqX4iMW4off5zLoDl0gTyOhQHE=;
        h=Subject:To:Cc:From:Date:From;
        b=XIHc0Gg1x2JaSOP4nYaLsar4f7q6aqjFciSbExkAVpRvG6PrnkRpr+3QY+CXy8+jd
         6d6NkQe2W5W2ysc1uUFzo8YcDAJOOh6aM2FWvKliKxA78xz8QBrJ1k6OSmEEPHc2Et
         m+zbQ8rKlR9jTgEs62+0hgRCFdBKTQsBwoUz6j2g=
Subject: FAILED: patch "[PATCH] docs: Makefile: Use CONFIG_SHELL not SHELL" failed to apply to 5.10-stable tree
To:     keescook@chromium.org, corbet@lwn.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:36:13 +0200
Message-ID: <1626352573178162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 222a28edce38b62074a950fb243df621c602b4d3 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Thu, 17 Jun 2021 15:58:08 -0700
Subject: [PATCH] docs: Makefile: Use CONFIG_SHELL not SHELL

Fix think-o about which variable to find the Kbuild-configured shell.
This has accidentally worked due to most shells setting $SHELL by
default.

Fixes: 51e46c7a4007 ("docs, parallelism: Rearrange how jobserver reservations are made")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210617225808.3907377-1-keescook@chromium.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 9c42dde97671..c3feb657b654 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -76,7 +76,7 @@ quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4)
 	PYTHONDONTWRITEBYTECODE=1 \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
 	$(PYTHON3) $(srctree)/scripts/jobserver-exec \
-	$(SHELL) $(srctree)/Documentation/sphinx/parallel-wrapper.sh \
+	$(CONFIG_SHELL) $(srctree)/Documentation/sphinx/parallel-wrapper.sh \
 	$(SPHINXBUILD) \
 	-b $2 \
 	-c $(abspath $(srctree)/$(src)) \

