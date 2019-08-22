Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3799C25
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392254AbfHVRbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404510AbfHVRZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:52 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71913206DD;
        Thu, 22 Aug 2019 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494751;
        bh=nbUMkkVdV4Rm6SzM4baXLIak3yyPqp6T9xLY/MHLjng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3qhRH7qScji77DLBgGL0EjLuvOu1HIMpQyjYald/78lhyZ3xRgHtdoBTJrgws6H+
         RPVPd4XL8Xda/pHirT+0cT883rmLzUh2FL80th+2zZFaXZ35ZEWXXVAnbLbtfRYg2D
         Btdy9L7Ia1KDR5ikluPsw5UhgErL/LpNft+PuMYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/85] drm/exynos: fix missing decrement of retry counter
Date:   Thu, 22 Aug 2019 10:19:23 -0700
Message-Id: <20190822171733.446901019@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1bbbab097a05276e312dd2462791d32b21ceb1ee ]

Currently the retry counter is not being decremented, leading to a
potential infinite spin if the scalar_reads don't change state.

Addresses-Coverity: ("Infinite loop")
Fixes: 280e54c9f614 ("drm/exynos: scaler: Reset hardware before starting the operation")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_scaler.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_scaler.c b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
index 0ddb6eec7b113..df228436a03d9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_scaler.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
@@ -108,12 +108,12 @@ static inline int scaler_reset(struct scaler_context *scaler)
 	scaler_write(SCALER_CFG_SOFT_RESET, SCALER_CFG);
 	do {
 		cpu_relax();
-	} while (retry > 1 &&
+	} while (--retry > 1 &&
 		 scaler_read(SCALER_CFG) & SCALER_CFG_SOFT_RESET);
 	do {
 		cpu_relax();
 		scaler_write(1, SCALER_INT_EN);
-	} while (retry > 0 && scaler_read(SCALER_INT_EN) != 1);
+	} while (--retry > 0 && scaler_read(SCALER_INT_EN) != 1);
 
 	return retry ? 0 : -EIO;
 }
-- 
2.20.1



