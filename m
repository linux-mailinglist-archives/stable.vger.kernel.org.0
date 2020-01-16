Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1813D13FE27
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404245AbgAPXc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404242AbgAPXc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD42520661;
        Thu, 16 Jan 2020 23:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217578;
        bh=jEAbR/1ZgIGRRPwckSUIX+BWqvXCJwQeMJLOwfEju6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0JdCNbAF7/dFWajJXcWS3gtAHNwlV+W3cBMxTNSvEnis31zhauKPOlB3sPQnLenC
         g+z7SGS/Fkd9HQFsl3bkkwbwCV1ZtIOdV9siKRHPmaRrPDGbuayb/l3+mckjXlvQ+L
         GuHOSpaUad1oiOfUpDocxqF0+m72TN3hLGzLM1wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 29/71] btrfs: simplify inode locking for RWF_NOWAIT
Date:   Fri, 17 Jan 2020 00:18:27 +0100
Message-Id: <20200116231713.729416326@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

commit 9cf35f673583ccc9f3e2507498b3079d56614ad3 upstream.

This is similar to 942491c9e6d6 ("xfs: fix AIM7 regression"). Apparently
our current rwsem code doesn't like doing the trylock, then lock for
real scheme. This causes extra contention on the lock and can be
measured eg. by AIM7 benchmark.  So change our read/write methods to
just do the trylock for the RWF_NOWAIT case.

Fixes: edf064e7c6fe ("btrfs: nowait aio support")
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1890,9 +1890,10 @@ static ssize_t btrfs_file_write_iter(str
 	    (iocb->ki_flags & IOCB_NOWAIT))
 		return -EOPNOTSUPP;
 
-	if (!inode_trylock(inode)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
 			return -EAGAIN;
+	} else {
 		inode_lock(inode);
 	}
 


