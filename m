Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0621D13FED7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391205AbgAPX3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391035AbgAPX3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E941920684;
        Thu, 16 Jan 2020 23:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217342;
        bh=+vvDOcRdhJp6OiqKi07LAjtkECQRNIemvqgQAgj+pz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hteXR38UXZIa5mpkxLhjL5m7atGwZxudclWxitjsXKXS7mHteMX/H9LFNtZxZrwUm
         PY/UryKR7mLJUGGvEk9i3m2YhgAobewJnONjBg+vjquv89Bs/is88CCs0Hr3gpnLuf
         ZJiZMZLx5b/EYNyDP0wEjiMFSissoNdbs7rlXSuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 44/84] NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutreturn
Date:   Fri, 17 Jan 2020 00:18:18 +0100
Message-Id: <20200116231718.983518480@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 5326de9e94bedcf7366e7e7625d4deb8c1f1ca8a upstream.

If nfs4_delegreturn_prepare needs to wait for a layoutreturn to complete
then make sure we drop the sequence slot if we hold it.

Fixes: 1c5bd76d17cc ("pNFS: Enable layoutreturn operation for return-on-close")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6103,8 +6103,10 @@ static void nfs4_delegreturn_prepare(str
 
 	d_data = (struct nfs4_delegreturndata *)data;
 
-	if (!d_data->lr.roc && nfs4_wait_on_layoutreturn(d_data->inode, task))
+	if (!d_data->lr.roc && nfs4_wait_on_layoutreturn(d_data->inode, task)) {
+		nfs4_sequence_done(task, &d_data->res.seq_res);
 		return;
+	}
 
 	lo = d_data->args.lr_args ? d_data->args.lr_args->layout : NULL;
 	if (lo && !pnfs_layout_is_valid(lo)) {


