Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415F73C8F9C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhGNTw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240244AbhGNTth (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B7D861427;
        Wed, 14 Jul 2021 19:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291895;
        bh=0DfvojDQtsTjKzPBJI6fP0XKs1/zGyGKKVN5ampn9VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqo6ZJsBhi4OBQZsfW4wf+V1kPphPt19rwjV0G5fgu7yJKjK2jVq4rsqsfa7U7PaI
         AIyzzGAs2UCKOGQ4OnNV9n4Gw7l2NGdrxD2DJYXLr7Emwf6PtmLHv2Yjjms7FCkZos
         xEErGG4TB93lNydvH4KkrEzE7vXY4Vs+OBamxF4N49OCLKjMR6r1LGqTx5srzJpfgv
         cYdn8QFJfnYhMzsGYyMVegwgzk5i9aMnfhVSjjqu5LaE8DC9W3/T/OIyXw89DNYq//
         7rLNImziRe7jxRAfzF1mr+XmvHG8/fVjfvTh1SsZQjE8ZEI5eMYOoaqgAovJwaqCoc
         jAuFAPBvCyABw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Maennich <maennich@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 75/88] kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set
Date:   Wed, 14 Jul 2021 15:42:50 -0400
Message-Id: <20210714194303.54028-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

