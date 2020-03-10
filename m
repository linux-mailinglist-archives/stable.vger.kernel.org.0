Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2417017FE2F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgCJMsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgCJMr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:47:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB2512468D;
        Tue, 10 Mar 2020 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844476;
        bh=/RtocEC+iLNR/9RT9a7srULExoLFSwUr55SBVusUmN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaGyH2Emg3yrvL+3kp0GuXrC44aL5yYtdWsqPozwFHE2z6WEErMuAGeEgzSeMNXdB
         1FxA0OeQUuyW+gnlXqiXXxNBd8xl78iLRtNadSz9SskDSmvJ4XSUxylwZLtsAAi7rp
         v9GWBfPPiv5DU00pYGUhPfphKsFpYQCuOFLPYE+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cb0c054eabfba4342146@syzkaller.appspotmail.com,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9 81/88] RDMA/iwcm: Fix iwcm work deallocation
Date:   Tue, 10 Mar 2020 13:39:29 +0100
Message-Id: <20200310123624.586962529@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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
@@ -137,8 +137,10 @@ static void dealloc_work_entries(struct
 {
 	struct list_head *e, *tmp;
 
-	list_for_each_safe(e, tmp, &cm_id_priv->work_free_list)
+	list_for_each_safe(e, tmp, &cm_id_priv->work_free_list) {
+		list_del(e);
 		kfree(list_entry(e, struct iwcm_work, free_list));
+	}
 }
 
 static int alloc_work_entries(struct iwcm_id_private *cm_id_priv, int count)


