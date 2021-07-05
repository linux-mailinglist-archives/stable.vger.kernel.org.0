Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8EF3BC08A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhGEPgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhGEPfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D2961C1A;
        Mon,  5 Jul 2021 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499100;
        bh=79PfZEMp6iK7zDjAPJE5rtxXNapRfnInHGG/50Fo/bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUF6AIfEtkYCiMVdQsMzx737E4OiODemCUPc7EkwnKclgSMoYlTk7urzJLFLh6GmD
         S/kVq5EZVr1VSNJlHQGnLpfsKU0RNXkDwB2AYhNZGknFw+6yAbcPErYPkkEma/vxpl
         PUdTHmGwVJ+5JwpAhy1tmh+E+jwtdxdFIblfJafTFHZBe968Vi7f2XtWjO2Dg4xbjh
         jq9uw5mjJVsfL/a3mRnTdGJViYoFm+pEpBMvbnsRbsqTwg5fbfk1X8hmrV8+Fma8oe
         MhQCbKvt0GloDMfPawiHeE9CgtGD+gVh+PZquhsTsKdLodAqEroXJBZ2vavICsscZI
         7Kp7LNb+rw29w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/15] hv_utils: Fix passing zero to 'PTR_ERR' warning
Date:   Mon,  5 Jul 2021 11:31:24 -0400
Message-Id: <20210705153136.1522245-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 14dce25c104f..8b2ebcab1518 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -545,8 +545,8 @@ static int hv_timesync_init(struct hv_util_service *srv)
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

