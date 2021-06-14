Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA46A3A6186
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhFNKs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhFNKqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:46:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B36761448;
        Mon, 14 Jun 2021 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667003;
        bh=RBVnKv1EWldhZPvFAZoMw1gA/3S46GLVj4xr2NRhhuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQFRmGLAF7llVrzjwBPdm5m5VDDqZRdRhxn0qp+H1GxUSt6ZwNgV+t1fvzhM0HyvH
         3Rr4DvtYPHGhyUIpqRxlaHv1v07CHHWWFzzwSg+CqAIX3dYgfZkDgP0MGgBVoo30jT
         OAfrc9GbfIxf8JdartYr2kgN7vTPkNbUelU3/e10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 60/67] NFS: Fix use-after-free in nfs4_init_client()
Date:   Mon, 14 Jun 2021 12:27:43 +0200
Message-Id: <20210614102645.796928451@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

commit 476bdb04c501fc64bf3b8464ffddefc8dbe01577 upstream.

KASAN reports a use-after-free when attempting to mount two different
exports through two different NICs that belong to the same server.

Olga was able to hit this with kernels starting somewhere between 5.7
and 5.10, but I traced the patch that introduced the clear_bit() call to
4.13. So something must have changed in the refcounting of the clp
pointer to make this call to nfs_put_client() the very last one.

Fixes: 8dcbec6d20 ("NFSv41: Handle EXCHID4_FLAG_CONFIRMED_R during NFSv4.1 migration")
Cc: stable@vger.kernel.org # 4.13+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -431,8 +431,8 @@ struct nfs_client *nfs4_init_client(stru
 		 */
 		nfs_mark_client_ready(clp, -EPERM);
 	}
-	nfs_put_client(clp);
 	clear_bit(NFS_CS_TSM_POSSIBLE, &clp->cl_flags);
+	nfs_put_client(clp);
 	return old;
 
 error:


