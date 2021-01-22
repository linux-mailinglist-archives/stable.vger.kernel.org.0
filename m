Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69BE300D38
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbhAVT75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbhAVORh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D95B23A53;
        Fri, 22 Jan 2021 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324831;
        bh=75UUVu8A3X5wPaztfrcbVR40m5wOKk18KPjs9M73CDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHB2ovxP7+jGqQpi7EVFies5hIIh946GiWblv353Lpp5duQhRnH+Hu06siGqx8E58
         d1m1LdW3rsoa5FljK3EZokqXlPx7S1CAqAOqXKarBpp/SWekk/JYTsZpFNomHY0GpA
         r9hQkU3uSFWgDfVm6tAFGWSlJ1+uBKVn8DgWimKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 22/50] NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock
Date:   Fri, 22 Jan 2021 15:12:03 +0100
Message-Id: <20210122135736.093950838@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -6395,9 +6395,9 @@ static int _nfs4_do_setlk(struct nfs4_st
 					data->arg.new_lock_owner, ret);
 	} else
 		data->cancelled = true;
+	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	rpc_put_task(task);
 	dprintk("%s: done, ret = %d!\n", __func__, ret);
-	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	return ret;
 }
 


