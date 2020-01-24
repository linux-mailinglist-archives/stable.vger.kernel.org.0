Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0468B14836B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbgAXLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:35:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387523AbgAXLf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:35:56 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF01D22464;
        Fri, 24 Jan 2020 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865755;
        bh=fvlAEjBEWR/oecRoP9PlSXWln1msywgc0bm9ei2Y2gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYeCNU6L/no465kAWp7hU3ZmM7FRGfDQ43P0mtnOY0vNZ9szK0EKxBS713hxUIJ4Q
         cLAQeUH2BdlHtfmRKgja4GQBSQRypoKq9rOwYqYXkEKlPWbBAtpxMAT0pN6yg65GcE
         +v8GzTtGbkmmN6OB2rNsNyzr5SGWeLQGWUuk0LkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 613/639] afs: Fix missing timeout reset
Date:   Fri, 24 Jan 2020 10:33:03 +0100
Message-Id: <20200124093206.260681306@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2543f24d23f8d..560dd5ff5a151 100644
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



