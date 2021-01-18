Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B627F2F9EAE
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390848AbhARLtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390821AbhARLqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E66D922D3E;
        Mon, 18 Jan 2021 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970373;
        bh=csRo0i/abD8CxbJqj8flWRgNY1Gum9YGGdsUJ75INGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyL/15NeoP258WSdtu1HtOnOHDhnpb8fW67HWpSLSWrSKBlspGtyIIQ0Q0vUwFgSY
         f2tLXGv6d+gG3zLhGZxmaQG0XuqI+4aSRKc4s9nCLbGhoaTqddC/eqtYvTB5/QP0dN
         K1Nc+oU6NJXp9QI+vHUIQ3h3VbQ12iCOF2VB1Y9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yongping Zhang <yongping.zhang@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 135/152] bnxt_en: Improve stats context resource accounting with RDMA driver loaded.
Date:   Mon, 18 Jan 2021 12:35:10 +0100
Message-Id: <20210118113359.195028006@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -222,8 +222,12 @@ int bnxt_get_ulp_msix_base(struct bnxt *
 
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


