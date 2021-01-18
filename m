Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0112FAAA0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437146AbhART0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390401AbhARLhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DE9822AB0;
        Mon, 18 Jan 2021 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969795;
        bh=Guk+tDRocdXKoGM5SsT7ipzRXI/FFxIVhCa+YVQQgm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kq0jtIl25IB6SCGemH106OTohIrI7KHyaii0oISzmZklCKKcsYEhYrlyeTGFvgKts
         U11hSHjkkEZq1Sq+1cDESJhCjjkwIXZR05nkSIe4fPzuktc+ODcqT6MchwXD0CBI45
         jHaOqjwVnZTqA2F5S7/SUSH5b0YwpR/cC/mhrX9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 29/43] NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock
Date:   Mon, 18 Jan 2021 12:34:52 +0100
Message-Id: <20210118113336.354763875@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

commit 3d1a90ab0ed93362ec8ac85cf291243c87260c21 upstream.

It is only safe to call the tracepoint before rpc_put_task() because
'data' is freed inside nfs4_lock_release (rpc_release).

Fixes: 48c9579a1afe ("Adding stateid information to tracepoints")
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6721,9 +6721,9 @@ static int _nfs4_do_setlk(struct nfs4_st
 					data->arg.new_lock_owner, ret);
 	} else
 		data->cancelled = true;
+	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	rpc_put_task(task);
 	dprintk("%s: done, ret = %d!\n", __func__, ret);
-	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	return ret;
 }
 


