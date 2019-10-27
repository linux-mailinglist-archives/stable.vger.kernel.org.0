Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2FE6826
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbfJ0VYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732602AbfJ0VYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:48 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C3DD21726;
        Sun, 27 Oct 2019 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211487;
        bh=N+kWJLwgSsVt7OHRx66ZKiIwoYg4+RuJ2BmXw6eqNzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRYxCCpyXerg9uVUzbaHHtbxx8TOwoCCbuqU2ubrQH0RiJZVTnJErKkFlKDKO0Gw+
         iFQ542MwxbK7xn/CbfIIOx3gE6OeEnxgcCvqjr8ut1xnxBpUfJkRCm5HuI/nD6xEiF
         Vio6CNPjNOtE2epNBG4tfzO60kZezmiBcLoQ3x+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.3 168/197] cifs: Fix missed free operations
Date:   Sun, 27 Oct 2019 22:01:26 +0100
Message-Id: <20191027203403.449576521@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 783bf7b8b641167fb6f3f4f787f60ae62bad41b3 upstream.

cifs_setattr_nounix has two paths which miss free operations
for xid and fullpath.
Use goto cifs_setattr_exit like other paths to fix them.

CC: Stable <stable@vger.kernel.org>
Fixes: aa081859b10c ("cifs: flush before set-info if we have writeable handles")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2465,9 +2465,9 @@ cifs_setattr_nounix(struct dentry *diren
 			rc = tcon->ses->server->ops->flush(xid, tcon, &wfile->fid);
 			cifsFileInfo_put(wfile);
 			if (rc)
-				return rc;
+				goto cifs_setattr_exit;
 		} else if (rc != -EBADF)
-			return rc;
+			goto cifs_setattr_exit;
 		else
 			rc = 0;
 	}


