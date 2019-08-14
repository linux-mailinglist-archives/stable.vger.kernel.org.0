Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC2E8D95D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfHNRHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbfHNRHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA7E214DA;
        Wed, 14 Aug 2019 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802465;
        bh=rhZtCfUqK4UYel8UwCC363nM4+CVBChyfSHBllp7SRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Raoft7+q/ZHdybDzn1Gb1qKF4KMZw5S1io4D+OmwMpbQ4PTQ3Rbeq1e5GZGWcVhaB
         NivJr2kNNwyzscKTVQ1k0RZaMnjWtzoLRlp0WC30uiwteeayA4QmA2L9aLmjO/TgVL
         wH4yrfMrr2yfwCH2H3n0+2lSJlouskNFzZN5kPc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 136/144] NFSv4: Fix an Oops in nfs4_do_setattr
Date:   Wed, 14 Aug 2019 19:01:32 +0200
Message-Id: <20190814165805.628930185@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 09a54f0ebfe263bc27c90bbd80187b9a93283887 upstream.

If the user specifies an open mode of 3, then we don't have a NFSv4 state
attached to the context, and so we Oops when we try to dereference it.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 29b59f9416937 ("NFSv4: change nfs4_do_setattr to take...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.10: 991eedb1371dc: NFSv4: Only pass the...
Cc: stable@vger.kernel.org # v4.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3175,7 +3175,7 @@ static int _nfs4_do_setattr(struct inode
 
 	if (nfs4_copy_delegation_stateid(inode, FMODE_WRITE, &arg->stateid, &delegation_cred)) {
 		/* Use that stateid */
-	} else if (ctx != NULL) {
+	} else if (ctx != NULL && ctx->state) {
 		struct nfs_lock_context *l_ctx;
 		if (!nfs4_valid_open_stateid(ctx->state))
 			return -EBADF;


