Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4642EA251
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbhAEBBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbhAEBBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F1A22B48;
        Tue,  5 Jan 2021 01:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808426;
        bh=gWKgDk65pk4N3a3WPjK1gyEft3PaJi9n7dDh+HCNjlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzCf7fJkUtBgIRq9EdJTkYbcBk7jufJOVLRwGxw8bKNSxmTt2taAMfOU0RpvcFjn0
         e//Cn8c4PzSf85ST7IH/9QIPGBty7yTXEmUfgPxMD3v700l9pPrMmYKkInbhuE8IGA
         9dp8wdLjoBKc6jh/ErESUQYBHzeulKv2BCSzHqWK8hEd/W5fNRyNpBl7aSwQMVK8Nv
         +YYQECb1M1Yysq+6IA9JkblPts8Luo9OKg9QVcu8vo3wDlrk/nI8IeAkm1iZyiLyHC
         +TQ61nt9iwnnEWHbai1SbbAAhgGaBruUiGzESQZVNYQln+utT6X254GPV5TcZpljc8
         6wjhdGjS/svoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 4/4] depmod: handle the case of /sbin/depmod without /sbin in PATH
Date:   Mon,  4 Jan 2021 20:00:21 -0500
Message-Id: <20210105010021.3954725-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105010021.3954725-1-sashal@kernel.org>
References: <20210105010021.3954725-1-sashal@kernel.org>
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
index baedaef53ca05..b0cb89e73bc56 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -14,6 +14,8 @@ if ! test -r System.map ; then
 	exit 0
 fi
 
+# legacy behavior: "depmod" in /sbin, no /sbin in PATH
+PATH="$PATH:/sbin"
 if [ -z $(command -v $DEPMOD) ]; then
 	echo "Warning: 'make modules_install' requires $DEPMOD. Please install it." >&2
 	echo "This is probably in the kmod package." >&2
-- 
2.27.0

