Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6C226875
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387816AbgGTQLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732830AbgGTQLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A74712065E;
        Mon, 20 Jul 2020 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261492;
        bh=GFr+mlrtKxpz0IzEPdW/LVs/ydHxwPDNZhkA3xjK2B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+Y5Xk5sVLvC+WGMKiN7Dc6SPXJyktTCaCU/G3tJx39UH2lxJKySKvurNEeogDwdz
         X8WxVP3pNmPGyQjQluTlamwq3gsyW6xHiV6Zn9x2y+nLSwAe7Wl8dOgCRjtZbZ6MmI
         nVeIVLTE7mKFDUWHMOKBgsGGk6aCXPB6bFvJPzLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 108/244] fuse: dont ignore errors from fuse_writepages_fill()
Date:   Mon, 20 Jul 2020 17:36:19 +0200
Message-Id: <20200720152830.966261311@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 7779b047a57f6824a43d0e1f70de2741b7426b9d ]

fuse_writepages() ignores some errors taken from fuse_writepages_fill() I
believe it is a bug: if .writepages is called with WB_SYNC_ALL it should
either guarantee that all data was successfully saved or return error.

Fixes: 26d614df1da9 ("fuse: Implement writepages callback")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e3afceecaa6b1..93763e844cd42 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2148,10 +2148,8 @@ static int fuse_writepages(struct address_space *mapping,
 
 	err = write_cache_pages(mapping, wbc, fuse_writepages_fill, &data);
 	if (data.wpa) {
-		/* Ignore errors if we can write at least one page */
 		WARN_ON(!data.wpa->ia.ap.num_pages);
 		fuse_writepages_send(&data);
-		err = 0;
 	}
 	if (data.ff)
 		fuse_file_put(data.ff, false, false);
-- 
2.25.1



