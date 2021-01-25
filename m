Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA15C304AAE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbhAZE74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbhAYSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28F8221E3;
        Mon, 25 Jan 2021 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600599;
        bh=uH+diHvqLRpY7zcz5jfIN7OJGEpyTCxurNx5avkHbnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dauOeMAS7w9qEDJUq7fl8FONBMF4zVMlVVNzogtem/yVUlkYFCYx8hpiLPPfVumLm
         GZstZFnBZjOaQBz1JAYH/rwiZHqSaSMH1za5PqEcpw3WmXDC2Da4zX6/4OmweNlS3x
         7jdfvoli6H4tXVvo3pupHIqReI7rqKGxW1hQtWcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/199] nfsd: Dont set eof on a truncated READ_PLUS
Date:   Mon, 25 Jan 2021 19:38:19 +0100
Message-Id: <20210125183219.514358431@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b68f0cbd3f95f2df81e525c310a41fc73c2ed0d3 ]

If the READ_PLUS operation was truncated due to an error, then ensure we
clear the 'eof' flag.

Fixes: 9f0b5792f07d ("NFSD: Encode a full READ_PLUS reply")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 26f6e277101de..5f5169b9c2e90 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4736,14 +4736,15 @@ out:
 	if (nfserr && segments == 0)
 		xdr_truncate_encode(xdr, starting_len);
 	else {
-		tmp = htonl(eof);
-		write_bytes_to_xdr_buf(xdr->buf, starting_len,     &tmp, 4);
-		tmp = htonl(segments);
-		write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
 		if (nfserr) {
 			xdr_truncate_encode(xdr, last_segment);
 			nfserr = nfs_ok;
+			eof = 0;
 		}
+		tmp = htonl(eof);
+		write_bytes_to_xdr_buf(xdr->buf, starting_len,     &tmp, 4);
+		tmp = htonl(segments);
+		write_bytes_to_xdr_buf(xdr->buf, starting_len + 4, &tmp, 4);
 	}
 
 	return nfserr;
-- 
2.27.0



