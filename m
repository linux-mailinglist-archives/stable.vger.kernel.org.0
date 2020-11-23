Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A42C06F9
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbgKWMgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbgKWMgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863A22065E;
        Mon, 23 Nov 2020 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134965;
        bh=SQEwHf3JHZSKznBe9IeJQOSiOB0cMsDK0N1wUX1gEqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a44QMAST3xJbe0Rx+uF2LPeDqbFe3kSq3gFISATnRUefNe/3EMIlKdtPuBNqoT6vE
         9CPrdtgOM2xxJFo+mDPv7Ed71xebZn4jePaCSw//mfZku41Tw2VuJGO4FCp+9DwdBp
         Sm0mNX7QvMgsZ4RHWS/kXIKZ1wIBHy0Hh6XnJ4cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 025/158] qed: fix error return code in qed_iwarp_ll2_start()
Date:   Mon, 23 Nov 2020 13:20:53 +0100
Message-Id: <20201123121821.149010744@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit cb47d16ea21045c66eebbf5ed792e74a8537e27a ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 469981b17a4f ("qed: Add unaligned and packed packet processing")
Fixes: fcb39f6c10b2 ("qed: Add mpa buffer descriptors for storing and processing mpa fpdus")
Fixes: 1e28eaad07ea ("qed: Add iWARP support for fpdu spanned over more than two tcp packets")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Link: https://lore.kernel.org/r/1605532033-27373-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2742,14 +2742,18 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_h
 	iwarp_info->partial_fpdus = kcalloc((u16)p_hwfn->p_rdma_info->num_qps,
 					    sizeof(*iwarp_info->partial_fpdus),
 					    GFP_KERNEL);
-	if (!iwarp_info->partial_fpdus)
+	if (!iwarp_info->partial_fpdus) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	iwarp_info->max_num_partial_fpdus = (u16)p_hwfn->p_rdma_info->num_qps;
 
 	iwarp_info->mpa_intermediate_buf = kzalloc(buff_size, GFP_KERNEL);
-	if (!iwarp_info->mpa_intermediate_buf)
+	if (!iwarp_info->mpa_intermediate_buf) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	/* The mpa_bufs array serves for pending RX packets received on the
 	 * mpa ll2 that don't have place on the tx ring and require later
@@ -2759,8 +2763,10 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_h
 	iwarp_info->mpa_bufs = kcalloc(data.input.rx_num_desc,
 				       sizeof(*iwarp_info->mpa_bufs),
 				       GFP_KERNEL);
-	if (!iwarp_info->mpa_bufs)
+	if (!iwarp_info->mpa_bufs) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
 	INIT_LIST_HEAD(&iwarp_info->mpa_buf_pending_list);
 	INIT_LIST_HEAD(&iwarp_info->mpa_buf_list);


