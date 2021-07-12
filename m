Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD983C48A4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhGLGk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237150AbhGLGiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A459061008;
        Mon, 12 Jul 2021 06:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071673;
        bh=7g9jhVIr9Cc13wM4e9OXLZCfqQy3d5sLELCLtpInqeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpE7RIUIz9vpj/VUxNkQ0bF/Tctf0gLarq8Xutt1fN6ww24istfAyxJ5eJuElpyi+
         Y1Tw2D44jJeRYrNhU2eRRNHlb2PffZ8ieP4n+HNaQyzyh5FDfFqoMV1pg/yH+cXqAw
         1+6qlv8a4+qbYdJpnM0Zqnu4arUbB35zCWwXbLfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/593] hv_utils: Fix passing zero to PTR_ERR warning
Date:   Mon, 12 Jul 2021 08:05:31 +0200
Message-Id: <20210712060901.846037162@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 05566ecdbe4b..1b914e418e41 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -696,8 +696,8 @@ static int hv_timesync_init(struct hv_util_service *srv)
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



