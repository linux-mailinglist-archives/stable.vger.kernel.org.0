Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0438045C595
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350278AbhKXN7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353071AbhKXN4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4730161245;
        Wed, 24 Nov 2021 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759221;
        bh=FqHcIn2DzJJUPtFmIwdeo8h1JK3qpuMF+tJF8AUKSx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mftTnQZ7W119huyV2jXJEXS8iKAWiIwHBmr5Eiss517J9PTAUbOG0mCPgYonowQ5a
         SLXqRVf46JufHaq4Ej2YSyVAYrSdtxoygiriJbk3oA0ab31ByqyuH2NT7zkj4FDcN4
         jy+xoSbLTlxM/uwIN7zJCW9JILttI/8RYVijLEdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/279] ptp: ocp: Fix a couple NULL vs IS_ERR() checks
Date:   Wed, 24 Nov 2021 12:57:39 +0100
Message-Id: <20211124115724.679685074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c7521d3aa2fa7fc785682758c99b5bcae503f6be ]

The ptp_ocp_get_mem() function does not return NULL, it returns error
pointers.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index caf9b37c5eb1e..e238ae8e94709 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1049,10 +1049,11 @@ ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
 	if (!ext)
 		return -ENOMEM;
 
-	err = -EINVAL;
 	ext->mem = ptp_ocp_get_mem(bp, r);
-	if (!ext->mem)
+	if (IS_ERR(ext->mem)) {
+		err = PTR_ERR(ext->mem);
 		goto out;
+	}
 
 	ext->bp = bp;
 	ext->info = r->extra;
@@ -1122,8 +1123,8 @@ ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r)
 	void __iomem *mem;
 
 	mem = ptp_ocp_get_mem(bp, r);
-	if (!mem)
-		return -EINVAL;
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
 
 	bp_assign_entry(bp, r, mem);
 
-- 
2.33.0



