Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF51F119A3E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfLJVvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbfLJVII (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C01D2469E;
        Tue, 10 Dec 2019 21:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012087;
        bh=Kj9F+E8kssmWLrGlaaPjGhscFWLYKxX1BArT3M5lpTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEOTgXibgN3Dp5Nz+PJwq3YRioGG2gReyaAJCovVKKqVQV1V0sSD7NgSyksGwI+Tm
         /fMGuTJCrje0+oWjxPGqh+1ziZvx6aqQ6AoRAl1BFBDuYTc85ssCl4dZOzFsd67auI
         WF6frQMlAbTYQDD/EzK1hlVOMp82VMvjN7lACtXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 065/350] tools/memory-model: Fix data race detection for unordered store and load
Date:   Tue, 10 Dec 2019 16:02:50 -0500
Message-Id: <20191210210735.9077-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit daebf24a8e8c6064cba3a330db9fe9376a137d2c ]

Currently the Linux Kernel Memory Model gives an incorrect response
for the following litmus test:

C plain-WWC

{}

P0(int *x)
{
	WRITE_ONCE(*x, 2);
}

P1(int *x, int *y)
{
	int r1;
	int r2;
	int r3;

	r1 = READ_ONCE(*x);
	if (r1 == 2) {
		smp_rmb();
		r2 = *x;
	}
	smp_rmb();
	r3 = READ_ONCE(*x);
	WRITE_ONCE(*y, r3 - 1);
}

P2(int *x, int *y)
{
	int r4;

	r4 = READ_ONCE(*y);
	if (r4 > 0)
		WRITE_ONCE(*x, 1);
}

exists (x=2 /\ 1:r2=2 /\ 2:r4=1)

The memory model says that the plain read of *x in P1 races with the
WRITE_ONCE(*x) in P2.

The problem is that we have a write W and a read R related by neither
fre or rfe, but rather W ->coe W' ->rfe R, where W' is an intermediate
write (the WRITE_ONCE() in P0).  In this situation there is no
particular ordering between W and R, so either a wr-vis link from W to
R or an rw-xbstar link from R to W would prove that the accesses
aren't concurrent.

But the LKMM only looks for a wr-vis link, which is equivalent to
assuming that W must execute before R.  This is not necessarily true
on non-multicopy-atomic systems, as the WWC pattern demonstrates.

This patch changes the LKMM to accept either a wr-vis or a reverse
rw-xbstar link as a proof of non-concurrency.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/memory-model/linux-kernel.cat | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/memory-model/linux-kernel.cat b/tools/memory-model/linux-kernel.cat
index ea2ff4b940749..2a9b4fe4a84eb 100644
--- a/tools/memory-model/linux-kernel.cat
+++ b/tools/memory-model/linux-kernel.cat
@@ -197,7 +197,7 @@ empty (wr-incoh | rw-incoh | ww-incoh) as plain-coherence
 (* Actual races *)
 let ww-nonrace = ww-vis & ((Marked * W) | rw-xbstar) & ((W * Marked) | wr-vis)
 let ww-race = (pre-race & co) \ ww-nonrace
-let wr-race = (pre-race & (co? ; rf)) \ wr-vis
+let wr-race = (pre-race & (co? ; rf)) \ wr-vis \ rw-xbstar^-1
 let rw-race = (pre-race & fr) \ rw-xbstar
 
 flag ~empty (ww-race | wr-race | rw-race) as data-race
-- 
2.20.1

