Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E624C2F9E7A
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390468AbhARLkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390496AbhARLkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A52122227;
        Mon, 18 Jan 2021 11:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969965;
        bh=iHcsyarSxBgQayvhUqzeQP+lRZdsbQOwPS11N57zgkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWGo/A6QAMIDrPjLluBUlpiDvngur2PIKGM+EDB8gZnn1j43EImQJ0pqNH2AHBoyg
         7hRx7LAT1QXzsfOObehRXq79jFtkV3cArUfEOhHSXcumYwdDsNT9dFkJ0eE07cexFE
         UuFVYxa4q14lZxY5Ii2jqNB+46tByJC75py3BJn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 55/76] NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock
Date:   Mon, 18 Jan 2021 12:34:55 +0100
Message-Id: <20210118113343.614270442@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -6959,9 +6959,9 @@ static int _nfs4_do_setlk(struct nfs4_st
 					data->arg.new_lock_owner, ret);
 	} else
 		data->cancelled = true;
+	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	rpc_put_task(task);
 	dprintk("%s: done, ret = %d!\n", __func__, ret);
-	trace_nfs4_set_lock(fl, state, &data->res.stateid, cmd, ret);
 	return ret;
 }
 


