Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C016E2EA259
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbhAEBB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbhAEBB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E421F22B51;
        Tue,  5 Jan 2021 01:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808431;
        bh=gWKgDk65pk4N3a3WPjK1gyEft3PaJi9n7dDh+HCNjlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIZdvZSrJfFqnynzy9F7VChHBVKgcXOxNYmFGSt33yXib5xeBQJBwwlmO9xhk8GR8
         4A3ctW19btSYurmeEimwmPHipb15BlsOkNKlMIJ32QrtEI3udZ3e/fuQvDmVpA6Ek3
         osrfynGEqnA1+lQv8wqkxKQKehguYzRpCFNW54EByRaJjjUcJ0C0YPGNu50YWM6Uv3
         93A4UV6vZtK4ylK2/iJeg5AhRd9sJnP0adaeSo5322tO9VEe41kbhUVXwQ7JM61hMF
         w7A4UPXCyYsrCOLN+0YItcL6fSktqHXWyGrVF1XfuPS3jo4EPWkY80PspCMQB3AxA5
         Dx7F3Wo0vZcGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 3/3] depmod: handle the case of /sbin/depmod without /sbin in PATH
Date:   Mon,  4 Jan 2021 20:00:27 -0500
Message-Id: <20210105010027.3954808-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105010027.3954808-1-sashal@kernel.org>
References: <20210105010027.3954808-1-sashal@kernel.org>
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

