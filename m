Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F067A3D29D3
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhGVQG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhGVQFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F0A361CBF;
        Thu, 22 Jul 2021 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972369;
        bh=0DfvojDQtsTjKzPBJI6fP0XKs1/zGyGKKVN5ampn9VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJTpUKydcRKnQ74UR6E/zwpy4VEmkZ5c9mTRTILAPZD7x8xh82qoA5e5K7LLVl0qU
         F299+W56EntsF29Q3IQcOGTwKEJ6p8u+bLtf54ONHSzWSooJOf7lr07kbeqfT/eyHP
         xYJZkTNvamO2gfs8M5SvR4jUH60AYBP1mW16eWrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 088/156] kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set
Date:   Thu, 22 Jul 2021 18:31:03 +0200
Message-Id: <20210722155631.229329270@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Maennich <maennich@google.com>

[ Upstream commit a979522a1a88556e42a22ce61bccc58e304cb361 ]

To avoid unnecessary recompilations, mkcompile_h does not regenerate
compile.h if just the timestamp changed.
Though, if KBUILD_BUILD_TIMESTAMP is set, an explicit timestamp for the
build was requested, in which case we should not ignore it.

If a user follows the documentation for reproducible builds [1] and
defines KBUILD_BUILD_TIMESTAMP as the git commit timestamp, a clean
build will have the correct timestamp. A subsequent cherry-pick (or
amend) changes the commit timestamp and if an incremental build is done
with a different KBUILD_BUILD_TIMESTAMP now, that new value is not taken
into consideration. But it should for reproducibility.

Hence, whenever KBUILD_BUILD_TIMESTAMP is explicitly set, do not ignore
UTS_VERSION when making a decision about whether the regenerated version
of compile.h should be moved into place.

[1] https://www.kernel.org/doc/html/latest/kbuild/reproducible-builds.html

Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mkcompile_h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index 4ae735039daf..a72b154de7b0 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -70,15 +70,23 @@ UTS_VERSION="$(echo $UTS_VERSION $CONFIG_FLAGS $TIMESTAMP | cut -b -$UTS_LEN)"
 # Only replace the real compile.h if the new one is different,
 # in order to preserve the timestamp and avoid unnecessary
 # recompilations.
-# We don't consider the file changed if only the date/time changed.
+# We don't consider the file changed if only the date/time changed,
+# unless KBUILD_BUILD_TIMESTAMP was explicitly set (e.g. for
+# reproducible builds with that value referring to a commit timestamp).
 # A kernel config change will increase the generation number, thus
 # causing compile.h to be updated (including date/time) due to the
 # changed comment in the
 # first line.
 
+if [ -z "$KBUILD_BUILD_TIMESTAMP" ]; then
+   IGNORE_PATTERN="UTS_VERSION"
+else
+   IGNORE_PATTERN="NOT_A_PATTERN_TO_BE_MATCHED"
+fi
+
 if [ -r $TARGET ] && \
-      grep -v 'UTS_VERSION' $TARGET > .tmpver.1 && \
-      grep -v 'UTS_VERSION' .tmpcompile > .tmpver.2 && \
+      grep -v $IGNORE_PATTERN $TARGET > .tmpver.1 && \
+      grep -v $IGNORE_PATTERN .tmpcompile > .tmpver.2 && \
       cmp -s .tmpver.1 .tmpver.2; then
    rm -f .tmpcompile
 else
-- 
2.30.2



