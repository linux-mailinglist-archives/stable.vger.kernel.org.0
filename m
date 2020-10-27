Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4929B533
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752086AbgJ0PJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793940AbgJ0PJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67CD20657;
        Tue, 27 Oct 2020 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811355;
        bh=x1EDnlZsOqbu2+4MmNy9W7wKce9oqgcPdzsk3pWum4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZ7/FAkup9czjJwG+efmrN3LRDv8l3xZ3zrx1o/VI+G0hExOOARqWRpkvPnoPvJDs
         wbY1YttlejNcGXuYZAqLkubsgbhJsRXts/oNyec4MJDb1BcK12lbUMhOIP+IAWCS0/
         ExDOquCy3BYhsfFRZy7ytU8Adkt+p2bokaPqc7Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 464/633] SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()
Date:   Tue, 27 Oct 2020 14:53:27 +0100
Message-Id: <20201027135544.494855204@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>

[ Upstream commit d48c8124749c9a5081fe68680f83605e272c984b ]

When the passed token is longer than 4032 bytes, the remaining part
of the token must be copied from the rqstp->rq_arg.pages. But the
copy must make sure it happens in a consecutive way.

With the existing code, the first memcpy copies 'length' bytes from
argv->iobase, but since the header is in front, this never fills the
whole first page of in_token->pages.

The mecpy in the loop copies the following bytes, but starts writing at
the next page of in_token->pages.  This leaves the last bytes of page 0
unwritten.

Symptoms were that users with many groups were not able to access NFS
exports, when using Active Directory as the KDC.

Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Fixes: 5866efa8cbfb "SUNRPC: Fix svcauth_gss_proxy_init()"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index c28051f7d217d..653c317694406 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1104,9 +1104,9 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 			       struct gssp_in_token *in_token)
 {
 	struct kvec *argv = &rqstp->rq_arg.head[0];
-	unsigned int page_base, length;
-	int pages, i, res;
-	size_t inlen;
+	unsigned int length, pgto_offs, pgfrom_offs;
+	int pages, i, res, pgto, pgfrom;
+	size_t inlen, to_offs, from_offs;
 
 	res = gss_read_common_verf(gc, argv, authp, in_handle);
 	if (res)
@@ -1134,17 +1134,24 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 	memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
 	inlen -= length;
 
-	i = 1;
-	page_base = rqstp->rq_arg.page_base;
+	to_offs = length;
+	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {
-		length = min_t(unsigned int, inlen, PAGE_SIZE);
-		memcpy(page_address(in_token->pages[i]),
-		       page_address(rqstp->rq_arg.pages[i]) + page_base,
+		pgto = to_offs >> PAGE_SHIFT;
+		pgfrom = from_offs >> PAGE_SHIFT;
+		pgto_offs = to_offs & ~PAGE_MASK;
+		pgfrom_offs = from_offs & ~PAGE_MASK;
+
+		length = min_t(unsigned int, inlen,
+			 min_t(unsigned int, PAGE_SIZE - pgto_offs,
+			       PAGE_SIZE - pgfrom_offs));
+		memcpy(page_address(in_token->pages[pgto]) + pgto_offs,
+		       page_address(rqstp->rq_arg.pages[pgfrom]) + pgfrom_offs,
 		       length);
 
+		to_offs += length;
+		from_offs += length;
 		inlen -= length;
-		page_base = 0;
-		i++;
 	}
 	return 0;
 }
-- 
2.25.1



