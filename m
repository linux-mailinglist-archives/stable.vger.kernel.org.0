Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326632C0659
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgKWMaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbgKWMaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E13320857;
        Mon, 23 Nov 2020 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134600;
        bh=AOB30L8ww43v7wr6brdJId+AsaRQj64ltkSfM+gFsw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyEeMsJ9u4F9F9XBypC30J0Mp442l/x/mGVQ1Ho2O3hzwxBg+ySG4aeayQp4LtLzb
         OYIGI6y48la3nI3MkQh1aocEBpB8kjyQQkHUvh+/1CN/iqkabziM2tD6MkLOnaCkCf
         S9OTkRH4aE86pdFI4QDlAwl5JEIAZpidQ6OipaNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 17/91] net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request
Date:   Mon, 23 Nov 2020 13:21:37 +0100
Message-Id: <20201123121810.143254246@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 4ee18c179e5e815fa5575e0d2db0c05795a804ee ]

The x25_disconnect function in x25_subr.c would decrease the refcount of
"x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.

However, the x25_rx_call_request function in af_x25.c, which is called
when we receive a connection request, does not increase the refcount when
it assigns the pointer.

Fix this issue by increasing the refcount of "struct x25_neigh" in
x25_rx_call_request.

This patch fixes frequent kernel crashes when using AF_X25 sockets.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Link: https://lore.kernel.org/r/20201112103506.5875-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1049,6 +1049,7 @@ int x25_rx_call_request(struct sk_buff *
 	makex25->lci           = lci;
 	makex25->dest_addr     = dest_addr;
 	makex25->source_addr   = source_addr;
+	x25_neigh_hold(nb);
 	makex25->neighbour     = nb;
 	makex25->facilities    = facilities;
 	makex25->dte_facilities= dte_facilities;


