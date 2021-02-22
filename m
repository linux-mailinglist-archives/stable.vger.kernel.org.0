Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1532161D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhBVMRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhBVMPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754B864EEF;
        Mon, 22 Feb 2021 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996125;
        bh=eptyiKcxa2IQuv43NO582Oq2wn+WSgujbiylpCj8u1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYT556qEUvg6SCHW5uovsmbmjhGV5wnDFErM6iGc1dYzDI1lJz0XLJqYHPd19RRnP
         tve0rDLkONJkWHfDIJWWMcj36rTNfNn+4qSZV27j4JFSnXp1POFd9KPhjHS/IiJXCa
         7TmFtjysgsS19yvCOHdcyluLJMIv/m6eGJMIQsN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 10/13] xen-netback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:13:27 +0100
Message-Id: <20210222121018.854444187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
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
@@ -1335,13 +1335,11 @@ int xenvif_tx_action(struct xenvif_queue
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
 


