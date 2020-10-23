Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53F9297998
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 01:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754267AbgJWXWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 19:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbgJWXWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 19:22:16 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF12C0613D2
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:22:15 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h24so4565086ejg.9
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++BugjGu7Yhj4JJ5Ke8vw5pSfa1dW+nAyP06MUn3l9A=;
        b=fR0nhC4hwwjEQcrMhtmyY8sKhRj7dxdyF2zz4p2zmTkw1Z0wFyN6uM8KqqmqF9puaD
         azZCsjAie4XeXmRw8k5oFcVimIPj5arVNPrWI/4l7+qfonfFuq1dSKSgUP+3yJoNTWGY
         PK6TCb5HWFqHN0sC5H3zBhkAPcfUPFCdkfRjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++BugjGu7Yhj4JJ5Ke8vw5pSfa1dW+nAyP06MUn3l9A=;
        b=o9GhR7dV6gxsmoKBx2kyqA0KZ8uX8UL16rtUP7Cx6bwSY51da0oh2OSfgGULa+MI2c
         11/7CvDTTMv5Ud14pOueuqT7vq0meHxxabgKRGEkts5vTxTyZneSghO5vlPk957yCG+E
         5KHVdioutWlUABinvEWyqrxeXAyxPQvY4s5NxZJ1Fir7jfsNwrjhBUM3VOLigaYI4YHl
         ++s7UzYP96+dN9W7XcLYb8nAZliI8C9gKfCRdH5TJot0keAuBvO2/+39mqLzIb3wfQUg
         DcFB1vpRWSlWV2wxHSgCVs/MzmskSEGtJ4QC0/qR5c/KdjX14Xqjf7d0d9iVyIN36usA
         POTA==
X-Gm-Message-State: AOAM530koWr1i3xx4MbE5y+L3Giit2jRqnycSMzmTptIUSu41q5MMZlz
        IEZ5DVW6CXHOOUfFd/p7yiks3YeLhzwBPHCU//A=
X-Google-Smtp-Source: ABdhPJy+FWvlI+Yb5UgOMrRC0uoX6rrAlvnu2D+ZLWWHSqFs6mIC+Extu8sxGFc3rWBf00r8KmBxUg==
X-Received: by 2002:a17:906:4d59:: with SMTP id b25mr4565331ejv.404.1603495334032;
        Fri, 23 Oct 2020 16:22:14 -0700 (PDT)
Received: from prevas-ravi.aaad.autarch.net (5.186.115.188.cgn.fibianet.dk. [5.186.115.188])
        by smtp.gmail.com with ESMTPSA id q25sm1447937eja.86.2020.10.23.16.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 16:22:13 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4.4-stable] scripts/setlocalversion: make git describe output more reliable
Date:   Sat, 24 Oct 2020 01:22:07 +0200
Message-Id: <20201023232207.10373-1-linux@rasmusvillemoes.dk>
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

[Adapt to `` vs $() differences between 4.4 and upstream.]

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/setlocalversion | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index aa28c3f29809314bfa58..0c8741b795d0c82a38c9 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -44,7 +44,7 @@ scm_version()
 
 	# Check for git and a git repo.
 	if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
-	   head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
+	   head=$(git rev-parse --verify HEAD 2>/dev/null); then
 
 		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
 		# it, because this version is defined in the top level Makefile.
@@ -58,11 +58,22 @@ scm_version()
 			fi
 			# If we are past a tagged commit (like
 			# "v2.6.30-rc5-302-g72357d5"), we pretty print it.
-			if atag="`git describe 2>/dev/null`"; then
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

