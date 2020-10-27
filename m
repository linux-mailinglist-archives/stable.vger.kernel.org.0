Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096F29B9A3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802668AbgJ0Puq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800453AbgJ0PnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E1221D42;
        Tue, 27 Oct 2020 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813399;
        bh=u+P8taGnXTkfA+jbB0zYHAsYbU+dXSCyDapA67S5iXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpqCvizv0J4lni71fEqjJ5/T+vdUODVJTAZic13nkKE2Bue31IG/aY4FTOkN6c4i3
         J3wPOAKEPVZlPAVn8OtQpoEyyo3WNi6pY6KeVPyMQHOethqNIVBzlBKPCAcOt05r48
         TV1kDvyw83+SkWQ4C85MwqT7Ywb3zF76RcsnTTa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 537/757] remoteproc/mediatek: fix null pointer dereference on null scp pointer
Date:   Tue, 27 Oct 2020 14:53:07 +0100
Message-Id: <20201027135515.682162627@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 434ac4d51407ce3764a6ae96a89d90b8ae2826fb ]

Currently when pointer scp is null a dev_err is being called that
references the pointer which is the very thing we are trying to
avoid doing. Remove the extraneous error message to avoid this
issue.

Addresses-Coverity: ("Dereference after null check")
Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200918152428.27258-1-colin.king@canonical.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp_ipi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp_ipi.c b/drivers/remoteproc/mtk_scp_ipi.c
index 3d3d87210ef2c..58d1d7e571d66 100644
--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -30,10 +30,8 @@ int scp_ipi_register(struct mtk_scp *scp,
 		     scp_ipi_handler_t handler,
 		     void *priv)
 {
-	if (!scp) {
-		dev_err(scp->dev, "scp device is not ready\n");
+	if (!scp)
 		return -EPROBE_DEFER;
-	}
 
 	if (WARN_ON(id >= SCP_IPI_MAX) || WARN_ON(handler == NULL))
 		return -EINVAL;
-- 
2.25.1



