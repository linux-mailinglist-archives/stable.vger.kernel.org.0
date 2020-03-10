Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED95017FB9D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbgCJNPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731999AbgCJNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:15:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5817F208E4;
        Tue, 10 Mar 2020 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846111;
        bh=dJeKi+R32ZhJSaKkqRgirh033mtVSJyG7ZWIYC80IkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThhA7cqgLKN7dsuMA3p4VdqHTja0wlQlN4oCQR0n7Oid7EnTgoXpY70k1MLRkIJHJ
         GxA5ulRodBVbq2/OlVFSiYYP91x5jtKOtXZbgUSAQW1MDpoFU2Ant4cvqMIzdUPTL0
         TiUVoEbUEqQYMZt0sUZEvJX69WxPmBMh8rIfNq9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cb0c054eabfba4342146@syzkaller.appspotmail.com,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 73/86] RDMA/iwcm: Fix iwcm work deallocation
Date:   Tue, 10 Mar 2020 13:45:37 +0100
Message-Id: <20200310124534.708408359@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

commit 810dbc69087b08fd53e1cdd6c709f385bc2921ad upstream.

The dealloc_work_entries() function must update the work_free_list pointer
while freeing its entries, since potentially called again on same list. A
second iteration of the work list caused system crash. This happens, if
work allocation fails during cma_iw_listen() and free_cm_id() tries to
free the list again during cleanup.

Fixes: 922a8e9fb2e0 ("RDMA: iWARP Connection Manager.")
Link: https://lore.kernel.org/r/20200302181614.17042-1-bmt@zurich.ibm.com
Reported-by: syzbot+cb0c054eabfba4342146@syzkaller.appspotmail.com
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/iwcm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -158,8 +158,10 @@ static void dealloc_work_entries(struct
 {
 	struct list_head *e, *tmp;
 
-	list_for_each_safe(e, tmp, &cm_id_priv->work_free_list)
+	list_for_each_safe(e, tmp, &cm_id_priv->work_free_list) {
+		list_del(e);
 		kfree(list_entry(e, struct iwcm_work, free_list));
+	}
 }
 
 static int alloc_work_entries(struct iwcm_id_private *cm_id_priv, int count)


