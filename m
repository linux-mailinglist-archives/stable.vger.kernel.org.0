Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CA373EA4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbfGXThi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389493AbfGXThh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A6B8214AF;
        Wed, 24 Jul 2019 19:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997057;
        bh=4eUvF33BJGJmLIcTfsllVxlZ1WR6hcuXpNWqFJYb9Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPF+vJFbP3+Np21HzXy9jBj29Rq91r65zOYt3c8yb0+44QviQ6NX4C2OKTnfqaRha
         YybWN7XKJn5xep7H+Qg5hMzB8nnGIlOeHYF44cuQQTUz1RWj/mko248M1eI2jfGIdm
         /9hpZO7WEOQ9hC9PHFj+9jPOFL/yHcwOvLeg8qbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 307/413] pnfs: Fix a problem where we gratuitously start doing I/O through the MDS
Date:   Wed, 24 Jul 2019 21:19:58 +0200
Message-Id: <20190724191757.731577559@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 58bbeab425c6c5e318f5b6ae31d351331ddfb34b upstream.

If the client has to stop in pnfs_update_layout() to wait for another
layoutget to complete, it currently exits and defaults to I/O through
the MDS if the layoutget was successful.

Fixes: d03360aaf5cc ("pNFS: Ensure we return the error if someone kills...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1890,7 +1890,7 @@ lookup_again:
 		spin_unlock(&ino->i_lock);
 		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
 					!atomic_read(&lo->plh_outstanding)));
-		if (IS_ERR(lseg) || !list_empty(&lo->plh_segs))
+		if (IS_ERR(lseg))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);
 		goto lookup_again;


