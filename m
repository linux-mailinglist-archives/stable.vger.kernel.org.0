Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19112411FB7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345278AbhITRo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348934AbhITRmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91E161B67;
        Mon, 20 Sep 2021 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157733;
        bh=aQ3ss94Ysz8Z2rgJ7EBicK34Av2AyGubTaj1Y/1YGx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTxl1rDcpTVT9d2ifPXn9z6X+S+BXEytGyj5m7LRXjtTDi+0ssvcjwCS0S9eTCEiM
         NQvyGgzXYdfJ7u7XB0PXvIBoP2tX4T6nwJzRCNPppr7/QOa0rO4mInLZWiqOgxrymu
         3rxSY8fFj7H1at62+p6XbJjfj9QqHAYF9X4TwVzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.19 126/293] 9p/xen: Fix end of loop tests for list_for_each_entry
Date:   Mon, 20 Sep 2021 18:41:28 +0200
Message-Id: <20210920163937.570612652@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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


