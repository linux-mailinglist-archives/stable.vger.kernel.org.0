Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1547420CA3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhJDNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234311AbhJDNFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB7A61881;
        Mon,  4 Oct 2021 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352465;
        bh=vsfflQ1PSiWJiD7au0Cb8ohyavdgndNjXMlp98azXSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcEZ4iM9KvlHkeogUj4LXm7aUteGASYCowXgDgLM1T0TKUW0sUsyCr7QNvLNjPLmv
         StWyNVPZSH0mH9RTTL5QkPqCojLxZIUx9slo8/Pc0QJROv/3QQORHI09bzCc/kmnuf
         9/Xa2RzVshYvhG26SgHLu16k+CDo0MOnN4yV3vTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 40/75] xen/balloon: fix balloon kthread freezing
Date:   Mon,  4 Oct 2021 14:52:15 +0200
Message-Id: <20211004125032.861655682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
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
@@ -602,8 +602,8 @@ static int balloon_thread(void *unused)
 			timeout = 3600 * HZ;
 		credit = current_credit();
 
-		wait_event_interruptible_timeout(balloon_thread_wq,
-				 balloon_thread_cond(state, credit), timeout);
+		wait_event_freezable_timeout(balloon_thread_wq,
+			balloon_thread_cond(state, credit), timeout);
 
 		if (kthread_should_stop())
 			return 0;


