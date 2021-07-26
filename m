Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF13D5E22
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhGZPFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235974AbhGZPF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FF386056C;
        Mon, 26 Jul 2021 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314356;
        bh=iW3+8FrBSNcMwp6wf21zNU4q6SBh7OzuKFjuDmBZ5rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okf1jj/8f6AzwaAdTlCcmcb6/IuT7j6WECKUgIJDJjJlPn/eCSqpoCrkGlBQ6gcjq
         voeHBzCUHw6xaRjMnBcODAA1nOgt/cFSynh8i660LQ7bPr8z2nS8kHt/Fn1fYMmtC0
         5djU9VBObA3XE5oA4K2Bs3n0/84U5QCt6o/Wxq/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/82] kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set
Date:   Mon, 26 Jul 2021 17:38:18 +0200
Message-Id: <20210726153828.751616687@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 959199c3147e..49f92fffa098 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -83,15 +83,23 @@ UTS_TRUNCATE="cut -b -$UTS_LEN"
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



