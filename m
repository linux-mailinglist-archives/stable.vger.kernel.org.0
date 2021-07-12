Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76523C492B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhGLGmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236742AbhGLGlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D6BA601FC;
        Mon, 12 Jul 2021 06:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071897;
        bh=ah73J0cUkajOLCAuOZwOrSk3V2wqOwzt7M7gw3BeJ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIhVCSTvRj7d6w+9ykrqM5uzXPuDSmbnkuMTYU5qDP6Ot8jZK15lPSHKSWK2cCTN2
         npKDwQCHutnSk8a1lTsjSzY68kUDmRa0XtOQA8WWS3b4KzN8WKT+pRzhEzPesblQnE
         xck/Vo7W61AenArHV9oGOnMU1ZwexSPwUK2pIick=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/593] lockdep: Fix wait-type for empty stack
Date:   Mon, 12 Jul 2021 08:07:07 +0200
Message-Id: <20210712060912.823340442@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f8b298cc39f0619544c607eaef09fd0b2afd10f3 ]

Even the very first lock can violate the wait-context check, consider
the various IRQ contexts.

Fixes: de8f5e4f2dc1 ("lockdep: Introduce wait-type checks")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20210617190313.256987481@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 788629c06ce9..8ae9d7abebc0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4626,7 +4626,7 @@ static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 	short curr_inner;
 	int depth;
 
-	if (!curr->lockdep_depth || !next_inner || next->trylock)
+	if (!next_inner || next->trylock)
 		return 0;
 
 	if (!next_outer)
-- 
2.30.2



