Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1C83C9D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfHFVey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfHFVey (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453E82089E;
        Tue,  6 Aug 2019 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127293;
        bh=Oh7XQow2ZDNdqQQwh8d/ZYTxfDgUlpgZcT0J10Y3w+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctb2/FGlfPZ6q88XWkkOprwfCh/tXCg3Iz9PcUnYjPx13JRigd4/SCXNSJCo+0/B2
         a5y7mVQaz9izVaPZeLtAvoRSL2LggcB+qw0yLzlVX2VGAE15VQ1IfG4nDpoTL/YXEC
         tc5e+LAIpCr/JPInES9g9wPcnX+5M01BSaRuOStY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 46/59] RDMA/restrack: Track driver QP types in resource tracker
Date:   Tue,  6 Aug 2019 17:33:06 -0400
Message-Id: <20190806213319.19203-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit 52e0a118a20308dd6aa531e20a5ab5907d2264c8 ]

The check for QP type different than XRC has excluded driver QP
types from the resource tracker.
As a result, "rdma resource show" user command would not show opened
driver QPs which does not reflect the real state of the system.

Check QP type explicitly instead of assuming enum values/ordering.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190801104354.11417-1-galpress@amazon.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/core_priv.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index ff40a450b5d28..ff9e0d7fb4f31 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -292,7 +292,9 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 					  struct ib_udata *udata,
 					  struct ib_uobject *uobj)
 {
+	enum ib_qp_type qp_type = attr->qp_type;
 	struct ib_qp *qp;
+	bool is_xrc;
 
 	if (!dev->ops.create_qp)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -310,7 +312,8 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 	 * and more importantly they are created internaly by driver,
 	 * see mlx5 create_dev_resources() as an example.
 	 */
-	if (attr->qp_type < IB_QPT_XRC_INI) {
+	is_xrc = qp_type == IB_QPT_XRC_INI || qp_type == IB_QPT_XRC_TGT;
+	if ((qp_type < IB_QPT_MAX && !is_xrc) || qp_type == IB_QPT_DRIVER) {
 		qp->res.type = RDMA_RESTRACK_QP;
 		if (uobj)
 			rdma_restrack_uadd(&qp->res);
-- 
2.20.1

