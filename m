Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637E12FA40B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390188AbhARLmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390678AbhARLlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEDDF224B0;
        Mon, 18 Jan 2021 11:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970026;
        bh=f96gWCLr5D/LAGhmXh0ZQJcg1Ss+6GC7drgFM0GWmWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6yFonH6srdgWtDVgu2tyHVQmzJzhg0WgAWgAI5o+GP8auVXeW3IRZaLwMqT3DUlU
         k3i+cY5k8ZMwoV4UZ1Uv+eeeDrUZYNCkWC6kvLLKrADNdVn3BR9yw4ZsxhLf/itaYW
         zhyLWrVoCBdDp+H59PhWRlCeZkf8DDpr4Z1p9Yno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yongping Zhang <yongping.zhang@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 64/76] bnxt_en: Improve stats context resource accounting with RDMA driver loaded.
Date:   Mon, 18 Jan 2021 12:35:04 +0100
Message-Id: <20210118113344.026749359@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 869c4d5eb1e6fbda66aa790c48bdb946d71494a0 upstream.

The function bnxt_get_ulp_stat_ctxs() does not count the stats contexts
used by the RDMA driver correctly when the RDMA driver is freeing the
MSIX vectors.  It assumes that if the RDMA driver is registered, the
additional stats contexts will be needed.  This is not true when the
RDMA driver is about to unregister and frees the MSIX vectors.

This slight error leads to over accouting of the stats contexts needed
after the RDMA driver has unloaded.  This will cause some firmware
warning and error messages in dmesg during subsequent config. changes
or ifdown/ifup.

Fix it by properly accouting for extra stats contexts only if the
RDMA driver is registered and MSIX vectors have been successfully
requested.

Fixes: c027c6b4e91f ("bnxt_en: get rid of num_stat_ctxs variable")
Reviewed-by: Yongping Zhang <yongping.zhang@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -216,8 +216,12 @@ int bnxt_get_ulp_msix_base(struct bnxt *
 
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP))
-		return BNXT_MIN_ROCE_STAT_CTXS;
+	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+		struct bnxt_en_dev *edev = bp->edev;
+
+		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
+			return BNXT_MIN_ROCE_STAT_CTXS;
+	}
 
 	return 0;
 }


