Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE6D13E0D4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgAPQqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbgAPQp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B984C20663;
        Thu, 16 Jan 2020 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193159;
        bh=n/jvbSX+FOK8nICkSkn2yXG7e58RQCtU2NcV+14PgJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzSIvl+pZ1brJHOhUxnfV9+qYExAu1yz7vWLoMP2pTs8YPKuFXQMgJn7mLpc/u0Ag
         +5yJacBuR7xMWEpsji11UjPBD3v9Nq5rtccTwERal89XUUy8QCA9chXazbQAQkS7pH
         wI9dMbab/LJRjlVxMrGPpZfCqEEFcQZFVmKOawRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 036/205] media: v4l: cadence: Fix how unsued lanes are handled in 'csi2rx_start()'
Date:   Thu, 16 Jan 2020 11:40:11 -0500
Message-Id: <20200116164300.6705-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2eca8e4c1df4864b937752c3aa2f7925114f4806 ]

The 2nd parameter of 'find_first_zero_bit()' is a number of bits, not of
bytes. So use 'csi2rx->max_lanes' instead of 'sizeof(lanes_used)'.

Fixes: 1fc3b37f34f6 ("media: v4l: cadence: Add Cadence MIPI-CSI2 RX driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/cadence/cdns-csi2rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 31ace114eda1..be9ec59774d6 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -129,7 +129,7 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 	 */
 	for (i = csi2rx->num_lanes; i < csi2rx->max_lanes; i++) {
 		unsigned int idx = find_first_zero_bit(&lanes_used,
-						       sizeof(lanes_used));
+						       csi2rx->max_lanes);
 		set_bit(idx, &lanes_used);
 		reg |= CSI2RX_STATIC_CFG_DLANE_MAP(i, i + 1);
 	}
-- 
2.20.1

