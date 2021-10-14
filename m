Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1462142DCA5
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhJNPAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhJNO7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774AD61184;
        Thu, 14 Oct 2021 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223446;
        bh=B9lYIyXKlaMzMrhHVEVyaQkl2AXM0CEJIRfOu5A7bVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM0cApO+c72xYWOfwNyBa3hzLazrkLYVmJw866kT2CL25FIw95gj8DFEajBK/R0eO
         wubHkn7p5JTB+QbzdSzP5Vu+bek/6RtWYAXCAVYwrQdvVzgm3qqBHg+oVQnyVVyPuz
         6ekyEjb3kunLDHvxSkiImHSjmBcjwe6o2CZiM7l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.14 05/33] nfsd4: Handle the NFSv4 READDIR dircount hint being zero
Date:   Thu, 14 Oct 2021 16:53:37 +0200
Message-Id: <20211014145208.956289908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit f2e717d655040d632c9015f19aa4275f8b16e7f2 upstream.

RFC3530 notes that the 'dircount' field may be zero, in which case the
recommendation is to ignore it, and only enforce the 'maxcount' field.
In RFC5661, this recommendation to ignore a zero valued field becomes a
requirement.

Fixes: aee377644146 ("nfsd4: fix rd_dircount enforcement")
Cc: <stable@vger.kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3082,15 +3082,18 @@ nfsd4_encode_dirent(void *ccdv, const ch
 		goto fail;
 	cd->rd_maxcount -= entry_bytes;
 	/*
-	 * RFC 3530 14.2.24 describes rd_dircount as only a "hint", so
-	 * let's always let through the first entry, at least:
+	 * RFC 3530 14.2.24 describes rd_dircount as only a "hint", and
+	 * notes that it could be zero. If it is zero, then the server
+	 * should enforce only the rd_maxcount value.
 	 */
-	if (!cd->rd_dircount)
-		goto fail;
-	name_and_cookie = 4 + 4 * XDR_QUADLEN(namlen) + 8;
-	if (name_and_cookie > cd->rd_dircount && cd->cookie_offset)
-		goto fail;
-	cd->rd_dircount -= min(cd->rd_dircount, name_and_cookie);
+	if (cd->rd_dircount) {
+		name_and_cookie = 4 + 4 * XDR_QUADLEN(namlen) + 8;
+		if (name_and_cookie > cd->rd_dircount && cd->cookie_offset)
+			goto fail;
+		cd->rd_dircount -= min(cd->rd_dircount, name_and_cookie);
+		if (!cd->rd_dircount)
+			cd->rd_maxcount = 0;
+	}
 
 	cd->cookie_offset = cookie_offset;
 skip_entry:


