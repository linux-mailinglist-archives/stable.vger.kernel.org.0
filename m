Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE52979A7
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 01:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758616AbgJWXYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 19:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758543AbgJWXYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 19:24:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73308C0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:24:24 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z5so4580151ejw.7
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bakNZ2VxMsli77njVy36n+7MORbCxzqoWw0AiOVluF4=;
        b=iz+NkY2IanXu72Rv1QYvfjlTOtnuaAUlwksEvDUQruD8QsjgATO+0LPKSOKksJAY7C
         0JXUwhnu46otSLZHeiIgrL64mgdfzpcJFXhrsRdYGx+uVeewojTq9Xj3jDAIGjf2afyl
         8qB0mTZ0szeiZaBecm0JTO5bm182jM450/ZYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bakNZ2VxMsli77njVy36n+7MORbCxzqoWw0AiOVluF4=;
        b=tO7zTbVvNWXVRc29nXs1aOVsWJNqv7P2c8QFULCZRJ9GabEZWvrHm3I5k50W0oE8Rx
         Tq2rrr9FH0vnXBsU+1tsJ2xblUDR3zhQIdgbUGEzXvJstDbDg8T3DTemOc+3OjDiF4pk
         jEEVGJL2iBmXfMMuUJ8IjVq/37zwe8fWQB/yh1h+5PhOWWqHSALGyzTDklBJOoXu7/Qt
         eTeHblQ3H4T2w+pk2rtgHIbUyc3suSA3Y8LFQYYU/dnxWnEQNenkK0U8ijUmzMLGR2G9
         pvCh3PWfa4s50nxDi5lkiXSySqPXkDJUHVU2KgOqlUZP49rhD+SS9YaB8VuKNRAjXZAl
         6P3g==
X-Gm-Message-State: AOAM532f5H2vN2NfHULLYYw7VXCs5sJzjnwxwmGgMkULrU0LALFluCM2
        YzUpiaQ4nlSY33bBR+vvw/W3hT3rXgyDt1FZBPQ=
X-Google-Smtp-Source: ABdhPJzZvXqe/36xmQvP05KrNQXTq+6w6fuS2Vo2XhODnS25gIVlyiDq5r3n/RV2rVQm1Rs8IkTtjw==
X-Received: by 2002:a17:906:bc4b:: with SMTP id s11mr4487956ejv.437.1603495462848;
        Fri, 23 Oct 2020 16:24:22 -0700 (PDT)
Received: from prevas-ravi.aaad.autarch.net (5.186.115.188.cgn.fibianet.dk. [5.186.115.188])
        by smtp.gmail.com with ESMTPSA id i27sm1358189edy.5.2020.10.23.16.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 16:24:22 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 5.8-stable] scripts/setlocalversion: make git describe output more reliable
Date:   Sat, 24 Oct 2020 01:24:20 +0200
Message-Id: <20201023232420.10907-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8 upstream.

When building for an embedded target using Yocto, we're sometimes
observing that the version string that gets built into vmlinux (and
thus what uname -a reports) differs from the path under /lib/modules/
where modules get installed in the rootfs, but only in the length of
the -gabc123def suffix. Hence modprobe always fails.

The problem is that Yocto has the concept of "sstate" (shared state),
which allows different developers/buildbots/etc. to share build
artifacts, based on a hash of all the metadata that went into building
that artifact - and that metadata includes all dependencies (e.g. the
compiler used etc.). That normally works quite well; usually a clean
build (without using any sstate cache) done by one developer ends up
being binary identical to a build done on another host. However, one
thing that can cause two developers to end up with different builds
[and thus make one's vmlinux package incompatible with the other's
kernel-dev package], which is not captured by the metadata hashing, is
this `git describe`: The output of that can be affected by

(1) git version: before 2.11 git defaulted to a minimum of 7, since
2.11 (git.git commit e6c587) the default is dynamic based on the
number of objects in the repo
(2) hence even if both run the same git version, the output can differ
based on how many remotes are being tracked (or just lots of local
development branches or plain old garbage)
(3) and of course somebody could have a core.abbrev config setting in
~/.gitconfig

So in order to avoid `uname -a` output relying on such random details
of the build environment which are rather hard to ensure are
consistent between developers and buildbots, make sure the abbreviated
sha1 always consists of exactly 12 hex characters. That is consistent
with the current rule for -stable patches, and is almost always enough
to identify the head commit unambigously - in the few cases where it
does not, the v5.4.3-00021- prefix would certainly nail it down.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/setlocalversion | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 20f2efd57b11aadff650..bb709eda96cdf01eb271 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -45,7 +45,7 @@ scm_version()
 
 	# Check for git and a git repo.
 	if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
-	   head=$(git rev-parse --verify --short HEAD 2>/dev/null); then
+	   head=$(git rev-parse --verify HEAD 2>/dev/null); then
 
 		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
 		# it, because this version is defined in the top level Makefile.
@@ -59,11 +59,22 @@ scm_version()
 			fi
 			# If we are past a tagged commit (like
 			# "v2.6.30-rc5-302-g72357d5"), we pretty print it.
-			if atag="$(git describe 2>/dev/null)"; then
-				echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
-
-			# If we don't have a tag at all we print -g{commitish}.
+			#
+			# Ensure the abbreviated sha1 has exactly 12
+			# hex characters, to make the output
+			# independent of git version, local
+			# core.abbrev settings and/or total number of
+			# objects in the current repository - passing
+			# --abbrev=12 ensures a minimum of 12, and the
+			# awk substr() then picks the 'g' and first 12
+			# hex chars.
+			if atag="$(git describe --abbrev=12 2>/dev/null)"; then
+				echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),substr($(NF),0,13))}'
+
+			# If we don't have a tag at all we print -g{commitish},
+			# again using exactly 12 hex chars.
 			else
+				head="$(echo $head | cut -c1-12)"
 				printf '%s%s' -g $head
 			fi
 		fi
-- 
2.23.0

