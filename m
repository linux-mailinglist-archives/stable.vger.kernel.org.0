Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8806A2EA2A0
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbhAEBEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbhAEBBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FA522B3F;
        Tue,  5 Jan 2021 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808420;
        bh=xPVYCDo7m9vj/HyfSA/Rfwh14AAcJNulQJp97M2XknU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyxF6Qq+COFKXsJBaGiQ3ePFKA0mqd9xzqUHzmlzojBny2csjKL7e1EmE7j4sTsop
         KRY6MuRHPWZE0jq5YUuQ2ACP9gwMzhjZ9C29oSntXZLvc1qRqU72tMbmBBRWLXLyAJ
         K1R2Kla1K+1iBhLM6uFnvcVTv8kvkcF8hkWrQfbqELEZu6a1Bvm9qSTFNN/IgQ4OeF
         zGM2S7X0rViq4g0cixiG584LiXkQeKZa9aI8VBdNIbiRgyF0Lx19mZFhsXfygR8/qw
         1sf2aSyi4q+Xx7KaVimFLSUuY3E7oUgH9mqm0NY4djCFzQ/s51boftFA04IO4xAJBi
         A/PXjp/DO/CuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 6/6] depmod: handle the case of /sbin/depmod without /sbin in PATH
Date:   Mon,  4 Jan 2021 20:00:12 -0500
Message-Id: <20210105010012.3954626-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105010012.3954626-1-sashal@kernel.org>
References: <20210105010012.3954626-1-sashal@kernel.org>
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
index cf5b2b24b3cf1..c7b8f827c4b09 100755
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

