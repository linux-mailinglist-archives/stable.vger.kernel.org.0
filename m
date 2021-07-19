Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D213CDCCE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244669AbhGSOxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239017AbhGSOuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB6A60FEA;
        Mon, 19 Jul 2021 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708663;
        bh=MvOkoWy2Sbthu5qIj/8nrRpF4nmx6fLTa22fyvfyVGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Byl4N7U1pg7zo4kvYDSS6/+5/4MmCMApWxrNfJWAqhSaU6Is/odhXxKY1m7wABcvp
         kdrw23mIik9Ywx4QDqK3i2sjPWQJ46ThZ4A7YK+Souc+qMphWt+uifPPBjc13vp2zb
         NsVAom23byDJ5eZT/1ijN0QztP9Dum5K/pFPYv3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/421] hv_utils: Fix passing zero to PTR_ERR warning
Date:   Mon, 19 Jul 2021 16:48:11 +0200
Message-Id: <20210719144948.912305035@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c6a8625fa4c6b0a97860d053271660ccedc3d1b3 ]

Sparse warn this:

drivers/hv/hv_util.c:753 hv_timesync_init() warn:
 passing zero to 'PTR_ERR'

Use PTR_ERR_OR_ZERO instead of PTR_ERR to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20210514070116.16800-1-yuehaibing@huawei.com
[ wei: change %ld to %d ]
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 423205077bf6..2003314dcfbe 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -548,8 +548,8 @@ static int hv_timesync_init(struct hv_util_service *srv)
 	 */
 	hv_ptp_clock = ptp_clock_register(&ptp_hyperv_info, NULL);
 	if (IS_ERR_OR_NULL(hv_ptp_clock)) {
-		pr_err("cannot register PTP clock: %ld\n",
-		       PTR_ERR(hv_ptp_clock));
+		pr_err("cannot register PTP clock: %d\n",
+		       PTR_ERR_OR_ZERO(hv_ptp_clock));
 		hv_ptp_clock = NULL;
 	}
 
-- 
2.30.2



