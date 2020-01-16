Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751C013FFCC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbgAPXpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390930AbgAPXWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABEED2073A;
        Thu, 16 Jan 2020 23:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216964;
        bh=9ITxoowF2Q9BKaua2GgD1VgfPPCxkh1E619v+x2pD5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TebuaVUR5PFf6bMUmv+a2yjx3aD3wNliR7GUhvFVj6EIf2T3HT3q9gFcXesXHB4Cy
         e1gYmjCe2Xun2ZqgFqziXOSNFfAcyF/aPr3vg7UyCP6N9Vzi865Smz9qWd+a+aFF30
         orQiuSkMYtbo+EH8XwGvidUshdK2aUNsGMph59SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 084/203] keys: Fix request_key() cache
Date:   Fri, 17 Jan 2020 00:16:41 +0100
Message-Id: <20200116231752.593225123@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 8379bb84be757d5df2d818509faec5d66adb861d upstream.

When the key cached by request_key() and co.  is cleaned up on exit(),
the code looks in the wrong task_struct, and so clears the wrong cache.
This leads to anomalies in key refcounting when doing, say, a kernel
build on an afs volume, that then trigger kasan to report a
use-after-free when the key is viewed in /proc/keys.

Fix this by making exit_creds() look in the passed-in task_struct rather
than in current (the task_struct cleanup code is deferred by RCU and
potentially run in another task).

Fixes: 7743c48e54ee ("keys: Cache result of request_key*() temporarily in task_struct")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cred.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -175,8 +175,8 @@ void exit_creds(struct task_struct *tsk)
 	put_cred(cred);
 
 #ifdef CONFIG_KEYS_REQUEST_CACHE
-	key_put(current->cached_requested_key);
-	current->cached_requested_key = NULL;
+	key_put(tsk->cached_requested_key);
+	tsk->cached_requested_key = NULL;
 #endif
 }
 


