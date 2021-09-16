Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E789B40E16C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240632AbhIPQae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236611AbhIPQ1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B78F61555;
        Thu, 16 Sep 2021 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809056;
        bh=aQ3ss94Ysz8Z2rgJ7EBicK34Av2AyGubTaj1Y/1YGx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu2XxU7wsY4p+bWmos8vzp0jwQRb5iTkfiHdtS9Lezb/xQ9KQfDvGqExB+1XuWlEg
         ZLzxEshcqENCHXdrob/WFFIlpFcMJkyC388k9s+/e6Jt0sCgDW8XahnycvdYeJuh8M
         Gge5aM3nF4EyiNq6wSEUmLaaVO6naizhywM2zf6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.13 015/380] 9p/xen: Fix end of loop tests for list_for_each_entry
Date:   Thu, 16 Sep 2021 17:56:12 +0200
Message-Id: <20210916155804.487482613@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

commit 732b33d0dbf17e9483f0b50385bf606f724f50a2 upstream.

This patch addresses the following problems:
 - priv can never be NULL, so this part of the check is useless
 - if the loop ran through the whole list, priv->client is invalid and
it is more appropriate and sufficient to check for the end of
list_for_each_entry loop condition.

Link: http://lkml.kernel.org/r/20210727000709.225032-1-harshvardhan.jha@oracle.com
Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Tested-by: Stefano Stabellini <sstabellini@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_xen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen
 
 static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 {
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
 	u32 size = p9_req->tc.size;
@@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_clie
 			break;
 	}
 	read_unlock(&xen_9pfs_lock);
-	if (!priv || priv->client != client)
+	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
 		return -EINVAL;
 
 	num = p9_req->tc.tag % priv->num_rings;


