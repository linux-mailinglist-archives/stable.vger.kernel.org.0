Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B908A1C137B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgEAN36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729848AbgEAN3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140FA208DB;
        Fri,  1 May 2020 13:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339795;
        bh=QpvCLsMVUmPNvhbcAdhLPAMk2bdjVhQBVqFvBHaLzLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnwx1B2AQlCbcy+p2IjfwpVPyUOhscy/nLu1rHaPcr4N+i784okClnVpoMVplWnFY
         Hfrzg2zpZUdTLoCG6GyoHU9VPO5mEdWuFh98tSW0NN/ENZ4aZyPedHGmqPgTSqrx0v
         O9QmJUnQvsw2I0jUw2tuBYDE7MotVSHQCAoavr98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.9 63/80] nfsd: memory corruption in nfsd4_lock()
Date:   Fri,  1 May 2020 15:21:57 +0200
Message-Id: <20200501131532.279438484@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit e1e8399eee72e9d5246d4d1bcacd793debe34dd3 upstream.

New struct nfsd4_blocked_lock allocated in find_or_allocate_block()
does not initialized nbl_list and nbl_lru.
If conflock allocation fails rollback can call list_del_init()
access uninitialized fields and corrupt memory.

v2: just initialize nbl_list and nbl_lru right after nbl allocation.

Fixes: 76d348fadff5 ("nfsd: have nfsd4_lock use blocking locks for v4.1+ lock")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -246,6 +246,8 @@ find_or_allocate_block(struct nfs4_locko
 	if (!nbl) {
 		nbl= kmalloc(sizeof(*nbl), GFP_KERNEL);
 		if (nbl) {
+			INIT_LIST_HEAD(&nbl->nbl_list);
+			INIT_LIST_HEAD(&nbl->nbl_lru);
 			fh_copy_shallow(&nbl->nbl_fh, fh);
 			locks_init_lock(&nbl->nbl_lock);
 			nfsd4_init_cb(&nbl->nbl_cb, lo->lo_owner.so_client,


