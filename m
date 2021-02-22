Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCC32175F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhBVMrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:47:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhBVMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BEE564F34;
        Mon, 22 Feb 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997612;
        bh=Y4EgobtCuJy6vPELmhRZdgR6r4br66n4aCvLTUoZy6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN0iwdpB/Nmvam94N9LpW1MwGc/T3Pv9U1YKhcOChudx/x+xaVMuHF1rXFw1soG8D
         VylBg0bJnV4jU3LDQ4gsnnjrrq9ZcdZ2Z9O8QlQlvip63GfE0B/qE/FFWTVXKQE+aA
         4Pzj3/TBlxglCtLLiy9k44Sdnyvq8bPqaapmA1fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 31/35] xen-netback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:36:27 +0100
Message-Id: <20210222121022.171009617@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 3194a1746e8aabe86075fd3c5e7cf1f4632d7f16 upstream.

In particular -ENOMEM may come back here, from set_foreign_p2m_mapping().
Don't make problems worse, the more that handling elsewhere (together
with map's status fields now indicating whether a mapping wasn't even
attempted, and hence has to be considered failed) doesn't require this
odd way of dealing with errors.

This is part of XSA-362.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/netback.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1792,13 +1792,11 @@ int xenvif_tx_action(struct xenvif_queue
 		return 0;
 
 	gnttab_batch_copy(queue->tx_copy_ops, nr_cops);
-	if (nr_mops != 0) {
+	if (nr_mops != 0)
 		ret = gnttab_map_refs(queue->tx_map_ops,
 				      NULL,
 				      queue->pages_to_map,
 				      nr_mops);
-		BUG_ON(ret);
-	}
 
 	work_done = xenvif_tx_submit(queue);
 


