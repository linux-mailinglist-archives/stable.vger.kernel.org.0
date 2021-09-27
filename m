Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD43419CDB
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbhI0Rci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237024AbhI0Rae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8279A6139F;
        Mon, 27 Sep 2021 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763106;
        bh=eJQXPnNG74y+9NZ6TFaJhgpavFc0wb/46GG4b/cUM3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtU6ffsuqojTqQSpKQj3D3zy1RR3LtR6bbjllImQG/o3zFCRtXqSTjGO0TIW29oeP
         xsj9FwZLe4H6PRvqE3Hu3vw9bSzIpST4++e1GV1lvaTfnwxZYErJPXbvIHVpbKJKCX
         iHYND7xpWvEQ/0wDuwmCGHQUOYmT0OXXbbKO2uX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.14 158/162] xen/balloon: fix balloon kthread freezing
Date:   Mon, 27 Sep 2021 19:03:24 +0200
Message-Id: <20210927170238.891716108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 96f5bd03e1be606987644b71899ea56a8d05f825 upstream.

Commit 8480ed9c2bbd56 ("xen/balloon: use a kernel thread instead a
workqueue") switched the Xen balloon driver to use a kernel thread.
Unfortunately the patch omitted to call try_to_freeze() or to use
wait_event_freezable_timeout(), causing a system suspend to fail.

Fixes: 8480ed9c2bbd56 ("xen/balloon: use a kernel thread instead a workqueue")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210920100345.21939-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/balloon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -522,8 +522,8 @@ static int balloon_thread(void *unused)
 			timeout = 3600 * HZ;
 		credit = current_credit();
 
-		wait_event_interruptible_timeout(balloon_thread_wq,
-				 balloon_thread_cond(state, credit), timeout);
+		wait_event_freezable_timeout(balloon_thread_wq,
+			balloon_thread_cond(state, credit), timeout);
 
 		if (kthread_should_stop())
 			return 0;


