Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A32979A8
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 01:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758627AbgJWXYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 19:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbgJWXYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 19:24:41 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52C7C0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:24:40 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id c15so4614018ejs.0
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 16:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bakNZ2VxMsli77njVy36n+7MORbCxzqoWw0AiOVluF4=;
        b=SVzlXkuASrpe6CvIGPLz9rNQdD/0UEapNPjodWnU0PWiJlXAbgn55doUTy5skHPs17
         FAx223ujGfM3D9OiEfRE0doO39O61t+nKNrqatpJVQafiWZh0pVl6Sxj4BZI29ZGORY1
         d9NgWb7thkyA13q3YT8zxMyDCe0/g/cgkd0i4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bakNZ2VxMsli77njVy36n+7MORbCxzqoWw0AiOVluF4=;
        b=AG4yTZfOdwdq0gGRNtNW8VN3SegAfqUawpn9lioD/Uq6AENl7513VT2V46eXwmQcSz
         c8nP4dYGKMsVSY19sU8GWvF3ukHqu673ow6yoX3fpaX7+9uJdwnRCBhTdLM3NZyRrbUv
         6r27zuZeYugDYB+bAq4HShCEmQY7d3Qtu9P6duurB6tDmTQEVH9AV70BVnBF1whwmGvV
         9vOEKaUbC5APQ1IuQHhtj4qcE3msimoFE5GzcwzVHS4LmjCR7Z8G0IYwr2q4LhGAupsg
         2ZKsiw2hIukgIJNAu8rh175SG1MpV+SyG8PFk+m7DQfcd++neHdKpOfbF8x7LlQoqa0A
         uifQ==
X-Gm-Message-State: AOAM5312WHF9bXL6+2C0hntREXROuN5zH7moRIVnhwUmfUAvAHhT/BTM
        WFwZXPy+xoFIHgtzXa6BYqeN1vFXhVcMoDA2YGs=
X-Google-Smtp-Source: ABdhPJxDIjp0Hh/VsdI5Od5uavZ8LYJfBl1vrVdy0LV4CdFN9aK6/Eo7lCoTGuMUeIGqAcnGcUdBlA==
X-Received: by 2002:a17:906:f14b:: with SMTP id gw11mr4590506ejb.41.1603495479220;
        Fri, 23 Oct 2020 16:24:39 -0700 (PDT)
Received: from prevas-ravi.aaad.autarch.net (5.186.115.188.cgn.fibianet.dk. [5.186.115.188])
        by smtp.gmail.com with ESMTPSA id x21sm1366667edq.88.2020.10.23.16.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 16:24:38 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 5.9-stable] scripts/setlocalversion: make git describe output more reliable
Date:   Sat, 24 Oct 2020 01:24:34 +0200
Message-Id: <20201023232434.10987-1-linux@rasmusvillemoes.dk>
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

