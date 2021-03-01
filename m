Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF491328994
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhCAR7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236508AbhCARyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E67264F1D;
        Mon,  1 Mar 2021 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620946;
        bh=Jybc4OSgugDEd+WnNlYBs51KPhRzswDmRbeEr8mZtRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZpjGLj8FWB4nswArVeyBzL09wlqgPV5GJl6nbrJRhqa3Mb4yqWMfvuVuArDn+gMq
         tNSsTn9lo+4oSuUeJNSqICuomINjF9YbxFAKEgf7CHspuKB0RT9ciODHkReNtgDONU
         JCgxd3Cb2WTvXYlZ3aq2p361x9hQyrPJBFYOcDP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 297/775] ubifs: replay: Fix high stack usage, again
Date:   Mon,  1 Mar 2021 17:07:45 +0100
Message-Id: <20210301161216.303024093@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 410b6de702ef84fea6e7abcb6620ef8bfc112fae ]

An earlier commit moved out some functions to not be inlined by gcc, but
after some other rework to remove one of those, clang started inlining
the other one and ran into the same problem as gcc did before:

fs/ubifs/replay.c:1174:5: error: stack frame size of 1152 bytes in function 'ubifs_replay_journal' [-Werror,-Wframe-larger-than=]

Mark the function as noinline_for_stack to ensure it doesn't happen
again.

Fixes: f80df3851246 ("ubifs: use crypto_shash_tfm_digest()")
Fixes: eb66eff6636d ("ubifs: replay: Fix high stack usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/replay.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index 79801c9a5b874..0f8a6a16421b4 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -559,7 +559,9 @@ static int is_last_bud(struct ubifs_info *c, struct ubifs_bud *bud)
 }
 
 /* authenticate_sleb_hash is split out for stack usage */
-static int authenticate_sleb_hash(struct ubifs_info *c, struct shash_desc *log_hash, u8 *hash)
+static int noinline_for_stack
+authenticate_sleb_hash(struct ubifs_info *c,
+		       struct shash_desc *log_hash, u8 *hash)
 {
 	SHASH_DESC_ON_STACK(hash_desc, c->hash_tfm);
 
-- 
2.27.0



