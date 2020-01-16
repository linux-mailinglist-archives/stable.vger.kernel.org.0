Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC1113FD46
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgAPXYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgAPXYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26383206D9;
        Thu, 16 Jan 2020 23:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217042;
        bh=llcbE1wcQpude3dpR8hju5BDyHfnYm//qk0xuoLs8uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1lQG5leIO8vKbxEu1tEL5ItnICkqKlr8ACoXscCveavOrsUHQ0RUzRsf2yqSwuvo
         ioE+LCC+Un95GmJw6dnnevvd6lOlyDRgD/ylPn2BnYxrBKvoHeHaF5yYiXQA5XSB7k
         2AAOKVo3iel5DatwpopgCRFvmkLj9ff+mD5LzY0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 108/203] NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutreturn
Date:   Fri, 17 Jan 2020 00:17:05 +0100
Message-Id: <20200116231754.960143265@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
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
@@ -6252,8 +6252,10 @@ static void nfs4_delegreturn_prepare(str
 
 	d_data = (struct nfs4_delegreturndata *)data;
 
-	if (!d_data->lr.roc && nfs4_wait_on_layoutreturn(d_data->inode, task))
+	if (!d_data->lr.roc && nfs4_wait_on_layoutreturn(d_data->inode, task)) {
+		nfs4_sequence_done(task, &d_data->res.seq_res);
 		return;
+	}
 
 	lo = d_data->args.lr_args ? d_data->args.lr_args->layout : NULL;
 	if (lo && !pnfs_layout_is_valid(lo)) {


