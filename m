Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061F42F179B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbhAKOI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbhAKNDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D377822BED;
        Mon, 11 Jan 2021 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370187;
        bh=gWKgDk65pk4N3a3WPjK1gyEft3PaJi9n7dDh+HCNjlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7qPUF1h780eePLvdtBJpg2qc042srl05wcG+SXkcWQnXabDsqD7jtfnh6WY/Kf3I
         GilPv/3a2GVdrI+IzGLU0IBxIMFJdwEMPr/QhLH4AqXU/SM9RYp0H0urGugv7gg1bb
         IerohrwLbIdMBA1mTYrTNZlMX2Os5proz7p2fYeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 4.9 04/45] depmod: handle the case of /sbin/depmod without /sbin in PATH
Date:   Mon, 11 Jan 2021 14:00:42 +0100
Message-Id: <20210111130033.894454623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



