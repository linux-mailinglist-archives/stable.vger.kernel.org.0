Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7B42EA23D
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbhAEBBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbhAEBBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DEEF22CA1;
        Tue,  5 Jan 2021 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808411;
        bh=H3Vg39PJBb8bU4b9uFjLwWenejDhGNvVdsLhkM1vwtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPx3uc1AA6QSCYQDN/pvGtz/yV6CwxOYQZn483y25oaekLDwvjH1/8ONRZFf2RUCe
         hIP7BbS6ygnkU5tUlRbs8RTuSvwfnwWE2x2pHphW/pUwORTkr0uy/O5sZstOpjC4TA
         qi/Fzq16uGSZSr6F95KLbYaN24qaInog/mGRKt/1BdT7P3M2QAXspLQUcjUnDsBSf+
         EMROqjUkbZOkvhtfkEvxmKWbXyndjH9sHsA2gz25Osyl+TaaIzCW5XKuwFRRDWw33Z
         kHbj6C+N4Ka/UKp+2/7Z0G11DfZrXbWevrjnnksM6rowZGiEXLi9tQc9sXna1qPp/o
         OJ9GfESMghICA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 8/8] depmod: handle the case of /sbin/depmod without /sbin in PATH
Date:   Mon,  4 Jan 2021 19:59:59 -0500
Message-Id: <20210105005959.3954510-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005959.3954510-1-sashal@kernel.org>
References: <20210105005959.3954510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cedd1862be7e666be87ec824dabc6a2b05618f36 ]

Commit 436e980e2ed5 ("kbuild: don't hardcode depmod path") stopped
hard-coding the path of depmod, but in the process caused trouble for
distributions that had that /sbin location, but didn't have it in the
PATH (generally because /sbin is limited to the super-user path).

Work around it for now by just adding /sbin to the end of PATH in the
depmod.sh script.

Reported-and-tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/depmod.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index e083bcae343f3..3643b4f896ede 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -15,6 +15,8 @@ if ! test -r System.map ; then
 	exit 0
 fi
 
+# legacy behavior: "depmod" in /sbin, no /sbin in PATH
+PATH="$PATH:/sbin"
 if [ -z $(command -v $DEPMOD) ]; then
 	echo "Warning: 'make modules_install' requires $DEPMOD. Please install it." >&2
 	echo "This is probably in the kmod package." >&2
-- 
2.27.0

