Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2980E299E91
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440525AbgJ0APy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439172AbgJ0ALH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455E920754;
        Tue, 27 Oct 2020 00:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757467;
        bh=fmXlvOS/ZhRVqFcxNW5uxaNcztefrwmdmlTY1LYyxLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDChSLVG59MItmIS8f9cavSlBAiWih1Bwy+UgiUEg3Suq0+8iXeyDta+DgP7hVlhM
         ROYTuyUaPRXTiaFGQaMtKjzlT0RPr0E8A50B1om+A46px49aJECkS7IThC22CHRijC
         lfE6S/tYT2gEt4nPhkfq1gmTrGzJ2CN17t+ieHiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 19/30] bus/fsl_mc: Do not rely on caller to provide non NULL mc_io
Date:   Mon, 26 Oct 2020 20:10:33 -0400
Message-Id: <20201027001044.1027349-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001044.1027349-1-sashal@kernel.org>
References: <20201027001044.1027349-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 798c965fe2033..3fa6774946fae 100644
--- a/drivers/staging/fsl-mc/bus/mc-io.c
+++ b/drivers/staging/fsl-mc/bus/mc-io.c
@@ -167,7 +167,12 @@ int __must_check fsl_create_mc_io(struct device *dev,
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
2.25.1

