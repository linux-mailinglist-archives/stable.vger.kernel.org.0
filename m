Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC752A545A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbgKCVKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbgKCVKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:10:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5566207BC;
        Tue,  3 Nov 2020 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437813;
        bh=omCMwbtSSpyy2n/WDHZjzc96m/ab2hICi6j+nJa/RSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9hfEg4OYdYIvyi8cwvx5YzehTZPZnxsus7H5YHFihWlHEZ4U9ZuLCVo1uIqsKWK7
         fLXKAYlQ+NjLczIyk0Xw7K0nJA0UK6p6wpDEp3wiZB0BxDW4FhpGty/6hNrtw2nKWV
         4t5Xeg8mrg5FnBqXK45nOPNj4Wx9ZMEdL+LITnok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/125] bus/fsl_mc: Do not rely on caller to provide non NULL mc_io
Date:   Tue,  3 Nov 2020 21:37:00 +0100
Message-Id: <20201103203203.228936574@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@oss.nxp.com>

[ Upstream commit 5026cf605143e764e1785bbf9158559d17f8d260 ]

Before destroying the mc_io, check first that it was
allocated.

Reviewed-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Link: https://lore.kernel.org/r/20200929085441.17448-11-diana.craciun@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fsl-mc/bus/mc-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fsl-mc/bus/mc-io.c b/drivers/staging/fsl-mc/bus/mc-io.c
index f65c23ce83f16..deec2d04c2dd9 100644
--- a/drivers/staging/fsl-mc/bus/mc-io.c
+++ b/drivers/staging/fsl-mc/bus/mc-io.c
@@ -166,7 +166,12 @@ error_destroy_mc_io:
  */
 void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
 {
-	struct fsl_mc_device *dpmcp_dev = mc_io->dpmcp_dev;
+	struct fsl_mc_device *dpmcp_dev;
+
+	if (!mc_io)
+		return;
+
+	dpmcp_dev = mc_io->dpmcp_dev;
 
 	if (dpmcp_dev)
 		fsl_mc_io_unset_dpmcp(mc_io);
-- 
2.27.0



