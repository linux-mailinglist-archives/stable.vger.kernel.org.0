Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847751217B7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbfLPSF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbfLPSF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F412E20700;
        Mon, 16 Dec 2019 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519526;
        bh=MKyl0gKesEgMEYBiDy75wdvVTVZlDkSAwpBgTUQzn88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsufllJMiqBiQc/wvfBAKcpqFSf9HHAE/+VuOFHG6HC9Uj63AsZTL+8laffHc0UL9
         SNgMVIuYgsn7cyY3X7nXarf3C+eKDRhEDmDkfbiL+yhEmsQgtwil3bT8y03QSdkZ/E
         r6rjOLWuBBScmvoM8eg87vf10+Y3ODGVHovyc14s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>, Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/140] scsi: qla2xxx: Fix message indicating vectors used by driver
Date:   Mon, 16 Dec 2019 18:49:31 +0100
Message-Id: <20191216174815.384947838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
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
index 8fa7242dbb437..afe15b3e45fbf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3418,10 +3418,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
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



