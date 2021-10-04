Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D28420F88
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhJDNfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234756AbhJDNdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A4D46322C;
        Mon,  4 Oct 2021 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353326;
        bh=eEGquIZV9LhV62znlXQeqkbUGi2dSA9idNNBdPQyaGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l35JKP5yX6hUdaXj2SwioRHslMi4JFwFul+ChUdcAXn3dkwf+cmeGUc9+9Rk/qnKq
         zcQRJJY9NXyUIa1Lx/+dejaLmJSD2fuGmUEyvHrMbd9V1kAxg7y3wF5aqr+A+Xza6Q
         XqUVbQcCyl67UlQOE1f1hjl7De4gXhsK9Mp5Bw5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 084/172] RDMA/irdma: Report correct WC error when transport retry counter is exceeded
Date:   Mon,  4 Oct 2021 14:52:14 +0200
Message-Id: <20211004125047.700969754@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit d3bdcd59633907ee306057b6bb70f06dce47dddc ]

When the retry counter exceeds, as the remote QP didn't send any Ack or
Nack an asynchronous event (AE) for too many retries is generated. Add
code to handle the AE and set the correct IB WC error code
IB_WC_RETRY_EXC_ERR.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20210916191222.824-4-shiraz.saleem@intel.com
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c    | 3 +++
 drivers/infiniband/hw/irdma/user.h  | 1 +
 drivers/infiniband/hw/irdma/verbs.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 33c06a3a4f63..cb9a8e24e3b7 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -176,6 +176,9 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 		qp->flush_code = FLUSH_GENERAL_ERR;
 		break;
+	case IRDMA_AE_LLP_TOO_MANY_RETRIES:
+		qp->flush_code = FLUSH_RETRY_EXC_ERR;
+		break;
 	default:
 		qp->flush_code = FLUSH_FATAL_ERR;
 		break;
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index ff705f323233..267102d1049d 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -102,6 +102,7 @@ enum irdma_flush_opcode {
 	FLUSH_REM_OP_ERR,
 	FLUSH_LOC_LEN_ERR,
 	FLUSH_FATAL_ERR,
+	FLUSH_RETRY_EXC_ERR,
 };
 
 enum irdma_cmpl_status {
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 6c3d28f744cb..3960c872ff76 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3358,6 +3358,8 @@ static enum ib_wc_status irdma_flush_err_to_ib_wc_status(enum irdma_flush_opcode
 		return IB_WC_LOC_LEN_ERR;
 	case FLUSH_GENERAL_ERR:
 		return IB_WC_WR_FLUSH_ERR;
+	case FLUSH_RETRY_EXC_ERR:
+		return IB_WC_RETRY_EXC_ERR;
 	case FLUSH_FATAL_ERR:
 	default:
 		return IB_WC_FATAL_ERR;
-- 
2.33.0



