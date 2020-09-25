Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2865C2788CF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgIYMtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbgIYMtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F6721D7A;
        Fri, 25 Sep 2020 12:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038184;
        bh=XPQYFLI989cl/5BOgc/iLplAnrfdYmepo1rgeb8KVb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIo4jl4DApBhpt2L/rjE9aFfuM3OTTXBOKk2s3Ebsy5pEKvqoM54SUibvKc4js7FJ
         uiTqFtPrDKn7d/4vvWmFlluDyGKCyjF0ZiEiH/cNKdDp6NW3WRVq8KdNRnply0O8dc
         lxxfQZdKnmqXSNDXZf2lX8nSqoflVZFP9IM15uyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 32/56] bnxt_en: Use memcpy to copy VPD field info.
Date:   Fri, 25 Sep 2020 14:48:22 +0200
Message-Id: <20200925124732.682284301@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 492adcf481292521ee8df1a482dc12acdb28aa15 ]

Using strlcpy() to copy from VPD is not correct because VPD strings
are not necessarily NULL terminated.  Use memcpy() to copy the VPD
length up to the destination buffer size - 1.  The destination is
zeroed memory so it will always be NULL terminated.

Fixes: a0d0fd70fed5 ("bnxt_en: Read partno and serialno of the board from VPD")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11807,7 +11807,7 @@ static int bnxt_init_mac_addr(struct bnx
 static void bnxt_vpd_read_info(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
-	int i, len, pos, ro_size;
+	int i, len, pos, ro_size, size;
 	ssize_t vpd_size;
 	u8 *vpd_data;
 
@@ -11842,7 +11842,8 @@ static void bnxt_vpd_read_info(struct bn
 	if (len + pos > vpd_size)
 		goto read_sn;
 
-	strlcpy(bp->board_partno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	memcpy(bp->board_partno, &vpd_data[pos], size);
 
 read_sn:
 	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
@@ -11855,7 +11856,8 @@ read_sn:
 	if (len + pos > vpd_size)
 		goto exit;
 
-	strlcpy(bp->board_serialno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	memcpy(bp->board_serialno, &vpd_data[pos], size);
 exit:
 	kfree(vpd_data);
 }


