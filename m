Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA41213E70C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgAPRNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390669AbgAPRNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A601246A2;
        Thu, 16 Jan 2020 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194790;
        bh=FDSPOsl2IE3xgi7CEM4aPdLM4iubDmai2eRPB1R9cyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RybESspi5Jz3vAARLyul0cC6B1CGcjjVE+8BHts9Uziv6iNVoJZ39MuiGzozkwsGL
         A+6CGQcKAqoRrKEcm8/YLSubchS6kO0mmnqCu1435wwqU6Se/LH2iFwNR39Wuxn4Oe
         WyFZxEg98DWHLBjxR/pYOmNraNSRJ0oMubTA4564=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 604/671] afs: Fix missing timeout reset
Date:   Thu, 16 Jan 2020 12:04:02 -0500
Message-Id: <20200116170509.12787-341-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c74386d50fbaf4a54fd3fe560f1abc709c0cff4b ]

In afs_wait_for_call_to_complete(), rather than immediately aborting an
operation if a signal occurs, the code attempts to wait for it to
complete, using a schedule timeout of 2*RTT (or min 2 jiffies) and a
check that we're still receiving relevant packets from the server before
we consider aborting the call.  We may even ping the server to check on
the status of the call.

However, there's a missing timeout reset in the event that we do
actually get a packet to process, such that if we then get a couple of
short stalls, we then time out when progress is actually being made.

Fix this by resetting the timeout any time we get something to process.
If it's the failure of the call then the call state will get changed and
we'll exit the loop shortly thereafter.

A symptom of this is data fetches and stores failing with EINTR when
they really shouldn't.

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 2543f24d23f8..560dd5ff5a15 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -573,6 +573,7 @@ static long afs_wait_for_call_to_complete(struct afs_call *call,
 			call->need_attention = false;
 			__set_current_state(TASK_RUNNING);
 			afs_deliver_to_call(call);
+			timeout = rtt2;
 			continue;
 		}
 
-- 
2.20.1

