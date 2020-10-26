Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8A299CCE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437381AbgJ0AB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411098AbgJZX4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7755A2225C;
        Mon, 26 Oct 2020 23:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756578;
        bh=Q5DGLxq+3nswD+SGP9Rs0t9yRliV69TmKXAPhbAHYYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noRU2BeL5JkGNUj2q+oKQFsNrxOL/YPCvtvb5rEKVjpwi4sGAywxQsl/ZM9hcystv
         YwUNJJR9mUp5YYBWi44RoslZ44UnJrgqy9GESzZ54fIbF+0oF9j+RaTiPNy+ISoWs8
         1aQUgFwjGPtr+gfp5Gz8KKkisc7HrrJG9k2LHE3g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 51/80] bus/fsl_mc: Do not rely on caller to provide non NULL mc_io
Date:   Mon, 26 Oct 2020 19:54:47 -0400
Message-Id: <20201026235516.1025100-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
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
 drivers/bus/fsl-mc/mc-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/mc-io.c b/drivers/bus/fsl-mc/mc-io.c
index d9629fc13a155..0a4a387b615d5 100644
--- a/drivers/bus/fsl-mc/mc-io.c
+++ b/drivers/bus/fsl-mc/mc-io.c
@@ -129,7 +129,12 @@ int __must_check fsl_create_mc_io(struct device *dev,
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

