Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C502ABDAD
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgKINsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgKIMz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:55:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09E32083B;
        Mon,  9 Nov 2020 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926555;
        bh=AztB8MVXQZdYwfXZ7uEqQsU1R83qfU9ZPAlsqcv9pnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMJQWqESorcDrKTFwQ0+aKBkt/ABYpJ0tcqXohyWZJEoyTT8wKROZXQRaJLQsBkQb
         1gU3iNi+LAznSZUvdcHDYUF6sXJ3FleqGtQ/wp1Me4YFOfEfBzSpe75ddvM4ETtCCK
         KJ5RIiMH3Qex2esM7czUcdpx0SrlOwpVFo5rsEgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.4 02/86] scripts/setlocalversion: make git describe output more reliable
Date:   Mon,  9 Nov 2020 13:54:09 +0100
Message-Id: <20201109125020.969475865@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

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

[Adapt to `` vs $() differences between 5.4 and upstream.]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/setlocalversion |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

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
 
-			# If we don't have a tag at all we print -g{commitish}.
+			# If we don't have a tag at all we print -g{commitish},
+			# again using exactly 12 hex chars.
 			else
+				head="$(echo $head | cut -c1-12)"
 				printf '%s%s' -g $head
 			fi
 		fi


