Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB5121689
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbfLPSNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730725AbfLPSNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC608207FF;
        Mon, 16 Dec 2019 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519991;
        bh=kWddPSHAoKeWMyw+eJdzZg965iYKPauvg8fv26S+uUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAjqBoz/dxEcS3B0qcbKX9byWpvTvj5wOr25S5oOxAsm85V8Sv2Pt2xRpV6dOynFv
         Qkh+nLJ6lbXh0e7RL6zhPf3xWRMCjJb9RpKJQKhqmsLsKgUmk14G+RZvTJOMO4v8Fe
         iYDsKk2UzwxJNshOZg8bi3uJJr1x3k5xSVcc7QKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>, Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 151/180] scsi: qla2xxx: Fix message indicating vectors used by driver
Date:   Mon, 16 Dec 2019 18:49:51 +0100
Message-Id: <20191216174844.193148694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit da48b82425b8bf999fb9f7c220e967c4d661b5f8 ]

This patch updates log message which indicates number of vectors used by
the driver instead of displaying failure to get maximum requested
vectors. Driver will always request maximum vectors during
initialization. In the event driver is not able to get maximum requested
vectors, it will adjust the allocated vectors. This is normal and does not
imply failure in driver.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Link: https://lore.kernel.org/r/20190830222402.23688-2-hmadhani@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 78aec50abe0f8..f7458d74ae3d2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3471,10 +3471,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		    ha->msix_count, ret);
 		goto msix_out;
 	} else if (ret < ha->msix_count) {
-		ql_log(ql_log_warn, vha, 0x00c6,
-		    "MSI-X: Failed to enable support "
-		     "with %d vectors, using %d vectors.\n",
-		    ha->msix_count, ret);
+		ql_log(ql_log_info, vha, 0x00c6,
+		    "MSI-X: Using %d vectors\n", ret);
 		ha->msix_count = ret;
 		/* Recalculate queue values */
 		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {
-- 
2.20.1



