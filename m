Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DA2395E4C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhEaN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233180AbhEaNyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06CF8613F0;
        Mon, 31 May 2021 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468030;
        bh=h0leL4LZ00p1Dww/hrwEsCVuYcN1DOIeLraIJHIBU3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agcc7PuUR/KScRrP49L8ZZODALfZWeu5eG5Ap78mjosuhWNUYpHjXuksKwmo1QsEw
         klv9jIw8m5TTRBOIrHZ+CME7w6EHFOKXkSHujCuv2F2kQfYKaPHccbNrgPgfh4HBRp
         gtrshKzGGZ/A6QXhj4ZVMTH0Yqqg5NHMZVwQxjsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhouchuangao <zhouchuangao@vivo.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 091/252] fs/nfs: Use fatal_signal_pending instead of signal_pending
Date:   Mon, 31 May 2021 15:12:36 +0200
Message-Id: <20210531130701.058058672@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhouchuangao <zhouchuangao@vivo.com>

commit bb002388901151fe35b6697ab116f6ed0721a9ed upstream.

We set the state of the current process to TASK_KILLABLE via
prepare_to_wait(). Should we use fatal_signal_pending() to detect
the signal here?

Fixes: b4868b44c562 ("NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE")
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1688,7 +1688,7 @@ static void nfs_set_open_stateid_locked(
 		rcu_read_unlock();
 		trace_nfs4_open_stateid_update_wait(state->inode, stateid, 0);
 
-		if (!signal_pending(current)) {
+		if (!fatal_signal_pending(current)) {
 			if (schedule_timeout(5*HZ) == 0)
 				status = -EAGAIN;
 			else
@@ -3463,7 +3463,7 @@ static bool nfs4_refresh_open_old_statei
 		write_sequnlock(&state->seqlock);
 		trace_nfs4_close_stateid_update_wait(state->inode, dst, 0);
 
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			status = -EINTR;
 		else
 			if (schedule_timeout(5*HZ) != 0)


