Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4369443
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbfGOOqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404643AbfGOOqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:46:18 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7909E20651;
        Mon, 15 Jul 2019 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201977;
        bh=6Rs2bUuMQ6X18mGwmVtlA01sUvjxLpYWwmoOaCf8gv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KvkK2teBoSK09KCy/JWJlTIuOykZsqp6D48Jazb6TAZILhDDur4QvXET7GzcND2L
         br7rwcHgZIbN0eqKZr8CJLJBtUKZEtRn1KjUzGSIxEQpF6uY1IsyfaFdM/lblh1WWv
         QQZlo8xICBby8cBZA/9wUidY4OHoqxdy/KrPV1zA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        Steve French <smfrench@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/53] signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
Date:   Mon, 15 Jul 2019 10:44:54 -0400
Message-Id: <20190715144535.11636-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 72abe3bcf0911d69b46c1e8bdb5612675e0ac42c ]

The locking in force_sig_info is not prepared to deal with a task that
exits or execs (as sighand may change).  The is not a locking problem
in force_sig as force_sig is only built to handle synchronous
exceptions.

Further the function force_sig_info changes the signal state if the
signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
delivery of the signal.  The signal SIGKILL can not be ignored and can
not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
delivered.

So using force_sig rather than send_sig for SIGKILL is confusing
and pointless.

Because it won't impact the sending of the signal and and because
using force_sig is wrong, replace force_sig with send_sig.

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Jeff Layton <jlayton@primarydata.com>
Cc: Steve French <smfrench@gmail.com>
Fixes: a5c3e1c725af ("Revert "cifs: No need to send SIGKILL to demux_thread during umount"")
Fixes: e7ddee9037e7 ("cifs: disable sharing session and tcon and add new TCP sharing code")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9cb72fd40eff..bc7c287a2e17 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2246,7 +2246,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-		force_sig(SIGKILL, task);
+		send_sig(SIGKILL, task, 1);
 }
 
 static struct TCP_Server_Info *
-- 
2.20.1

