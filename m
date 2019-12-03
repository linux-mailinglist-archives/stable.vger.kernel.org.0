Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411D9111E83
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfLCWyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbfLCWyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1550520674;
        Tue,  3 Dec 2019 22:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413639;
        bh=aSTWXn1mXOhWQyL0OsDJGPKyYnCAWp191htXRIztyUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT1Gik5a9+RO5lHEswtIkJN8pem/tXRF2YJvlDukbB2RzrE4G1ha3aQAbsfd0uCL9
         mDi2Dl+GyvLR64SSPw+jGYNbSaTUCLTF4lw0pyznmqBxBVV96/7SWTmsYiO3nhaOn5
         iqi8pieMmu0O6u0xnRf/sWuc1gMb31zNUYl38lUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/321] infiniband: bnxt_re: qplib: Check the return value of send_message
Date:   Tue,  3 Dec 2019 23:34:30 +0100
Message-Id: <20191203223437.734205800@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 94edd87a1c59f3efa6fdf4e98d6d492e6cec6173 ]

In bnxt_qplib_map_tc2cos(), bnxt_qplib_rcfw_send_message() can return an
error value but it is lost. Propagate this error to the callers.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 4097f3fa25c5f..09e7d3dd30553 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -775,9 +775,8 @@ int bnxt_qplib_map_tc2cos(struct bnxt_qplib_res *res, u16 *cids)
 	req.cos0 = cpu_to_le16(cids[0]);
 	req.cos1 = cpu_to_le16(cids[1]);
 
-	bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp, NULL,
-				     0);
-	return 0;
+	return bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp,
+						NULL, 0);
 }
 
 int bnxt_qplib_get_roce_stats(struct bnxt_qplib_rcfw *rcfw,
-- 
2.20.1



