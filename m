Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E563232EA07
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhCEMgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhCEMfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A80F65027;
        Fri,  5 Mar 2021 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947736;
        bh=acKLn+rjEj4GLNjnDvR2gDy/O+xFPyGO2hiJrIVlMqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCyPnl2Dgzc8plwv9+KEVcI0nuYodUWfPHkhjPG6PYVoeDoAwzYey3UWtsCYopjCW
         YXMalXXWxqwS9urXgqVCEnfjdgv0xYW9trc2bqOffaSfQnOtyko3suGLCUqsTMxVnh
         BIwWNkzH/rMllForm8aJzmkMtTibDM7WVU8y374w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 66/72] xen-netback: respect gnttab_map_refs()s return value
Date:   Fri,  5 Mar 2021 13:22:08 +0100
Message-Id: <20210305120900.569399337@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 2991397d23ec597405b116d96de3813420bdcbc3 upstream.

Commit 3194a1746e8a ("xen-netback: don't "handle" error by BUG()")
dropped respective a BUG_ON() without noticing that with this the
variable's value wouldn't be consumed anymore. With gnttab_set_map_op()
setting all status fields to a non-zero value, in case of an error no
slot should have a status of GNTST_okay (zero).

This is part of XSA-367.

Cc: <stable@vger.kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/d933f495-619a-0086-5fb4-1ec3cf81a8fc@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1335,11 +1335,21 @@ int xenvif_tx_action(struct xenvif_queue
 		return 0;
 
 	gnttab_batch_copy(queue->tx_copy_ops, nr_cops);
-	if (nr_mops != 0)
+	if (nr_mops != 0) {
 		ret = gnttab_map_refs(queue->tx_map_ops,
 				      NULL,
 				      queue->pages_to_map,
 				      nr_mops);
+		if (ret) {
+			unsigned int i;
+
+			netdev_err(queue->vif->dev, "Map fail: nr %u ret %d\n",
+				   nr_mops, ret);
+			for (i = 0; i < nr_mops; ++i)
+				WARN_ON_ONCE(queue->tx_map_ops[i].status ==
+				             GNTST_okay);
+		}
+	}
 
 	work_done = xenvif_tx_submit(queue);
 


