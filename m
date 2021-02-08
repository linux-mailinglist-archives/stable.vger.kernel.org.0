Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560CF3137B2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBHP3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhBHPZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABEC364F1B;
        Mon,  8 Feb 2021 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797315;
        bh=ZIaY/+E9j/6JBq23Zsdk3Qjd+AUNB8uNIfk4Df16bYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBeqsbk/NqjrziMauW62eXVhfozTqofaytMK7MQswuH+YudlNGGnAGg/WOcf0lBNg
         o/1zdI5oS0GDMRcwexwnfg9OKMDqMKx0mJfUK6OKn/r68X6ToC4qBf8LY5JPPVaRDS
         J6wMQeP7oRE/sGvFA0x6TzxIsyLwS2d714ZtDZ6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "A. Duvnjak" <avian@extremenerds.net>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/120] SUNRPC: Fix NFS READs that start at non-page-aligned offsets
Date:   Mon,  8 Feb 2021 16:00:22 +0100
Message-Id: <20210208145819.792600794@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bad4c6eb5eaa8300e065bd4426727db5141d687d ]

Anj Duvnjak reports that the Kodi.tv NFS client is not able to read
video files from a v5.10.11 Linux NFS server.

The new sendpage-based TCP sendto logic was not attentive to non-
zero page_base values. nfsd_splice_read() sets that field when a
READ payload starts in the middle of a page.

The Linux NFS client rarely emits an NFS READ that is not page-
aligned. All of my testing so far has been with Linux clients, so I
missed this one.

Reported-by: A. Duvnjak <avian@extremenerds.net>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211471
Fixes: 4a85a6a3320b ("SUNRPC: Handle TCP socket sends with kernel_sendpage() again")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: A. Duvnjak <avian@extremenerds.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 4404c491eb388..fa7b7ae2c2c5f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1113,14 +1113,15 @@ static int svc_tcp_sendmsg(struct socket *sock, struct msghdr *msg,
 		unsigned int offset, len, remaining;
 		struct bio_vec *bvec;
 
-		bvec = xdr->bvec;
-		offset = xdr->page_base;
+		bvec = xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
+		offset = offset_in_page(xdr->page_base);
 		remaining = xdr->page_len;
 		flags = MSG_MORE | MSG_SENDPAGE_NOTLAST;
 		while (remaining > 0) {
 			if (remaining <= PAGE_SIZE && tail->iov_len == 0)
 				flags = 0;
-			len = min(remaining, bvec->bv_len);
+
+			len = min(remaining, bvec->bv_len - offset);
 			ret = kernel_sendpage(sock, bvec->bv_page,
 					      bvec->bv_offset + offset,
 					      len, flags);
-- 
2.27.0



