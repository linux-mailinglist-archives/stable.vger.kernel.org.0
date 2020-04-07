Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6211A0BD3
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgDGKXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgDGKXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE4420644;
        Tue,  7 Apr 2020 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255033;
        bh=kbZl1uDjGDqe9P85bbeC5tlO3WXKxc6I56W8sgaOY54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8B8bevqcdGusAgVCN8q3YFS56P8XJ8fmuRW4uGU/TQraEKurKYqnsVBczPR+aQIX
         mqbbJ6nXkweNDrQ074AOaGB65h0k/nY8zVNnRT4/se+gnnupy84fPQCAkAnrl3093B
         mVjALNsYG2t6dQ4kO0wpwjS1vgcIYaNeA4JBbrQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/36] padata: fix uninitialized return value in padata_replace()
Date:   Tue,  7 Apr 2020 12:21:46 +0200
Message-Id: <20200407101456.064759735@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 41ccdbfd5427bbbf3ed58b16750113b38fad1780 ]

According to Geert's report[0],

  kernel/padata.c: warning: 'err' may be used uninitialized in this
    function [-Wuninitialized]:  => 539:2

Warning is seen only with older compilers on certain archs.  The
runtime effect is potentially returning garbage down the stack when
padata's cpumasks are modified before any pcrypt requests have run.

Simplest fix is to initialize err to the success value.

[0] http://lkml.kernel.org/r/20200210135506.11536-1-geert@linux-m68k.org

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fda7a7039422d..7bd37dd9ec55b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -516,7 +516,7 @@ static int padata_replace(struct padata_instance *pinst)
 {
 	int notification_mask = 0;
 	struct padata_shell *ps;
-	int err;
+	int err = 0;
 
 	pinst->flags |= PADATA_RESET;
 
-- 
2.20.1



