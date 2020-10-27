Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4EF29B0E4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368335AbgJ0OY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758879AbgJ0OYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF4520773;
        Tue, 27 Oct 2020 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808683;
        bh=a3Rtrrw597lRuz2gXXHK/RbcloQuVq/Nc/s+pRMcebs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVU3U1reH06ha5PMHmyBanVPaXFe0Lh+WBL3G7dRJmJCpa4++t9hO0TE7XVQamzDp
         Mhaien3EzkIeki5UIceBxyOdV5W1RffX7eLrvaHjQkcFbLvezN0rnOnSsZPjqdcksR
         NJHEp3pQS1GfsPIdlof5sXFHZDfonktM6KOtDcKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/264] svcrdma: fix bounce buffers for unaligned offsets and multiple pages
Date:   Tue, 27 Oct 2020 14:53:55 +0100
Message-Id: <20201027135438.995333002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan@kernelim.com>

[ Upstream commit c327a310ec4d6ecbea13185ed56c11def441d9ab ]

This was discovered using O_DIRECT at the client side, with small
unaligned file offsets or IOs that span multiple file pages.

Fixes: e248aa7be86 ("svcrdma: Remove max_sge check at connect time")
Signed-off-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index aa4d19a780d78..4062cd624b26f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -639,10 +639,11 @@ static int svc_rdma_pull_up_reply_msg(struct svcxprt_rdma *rdma,
 		while (remaining) {
 			len = min_t(u32, PAGE_SIZE - pageoff, remaining);
 
-			memcpy(dst, page_address(*ppages), len);
+			memcpy(dst, page_address(*ppages) + pageoff, len);
 			remaining -= len;
 			dst += len;
 			pageoff = 0;
+			ppages++;
 		}
 	}
 
-- 
2.25.1



