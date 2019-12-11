Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E14511B095
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbfLKPYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732528AbfLKPYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EFAB2077B;
        Wed, 11 Dec 2019 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077854;
        bh=b56PFEeGkiCfb2X9l/TBqID3iIqi2RojuknxJjSz31I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h39LAysbmJNtgxaGFxBCIddPc/NqJ9SRfr55umG2cxfQmYpGTQxW2ZGEOJDC0r4oN
         b9Z8IFCshxUVZIHLJGLN0szgFwcZ7cdVCslJrCwcHmpHlw1vlSvzx1ZdCfGXEU3USj
         a1pQDFR4tDptD0ugN9UJ04A3sBW9IBW4THSWvFc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/243] usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler
Date:   Wed, 11 Dec 2019 16:05:51 +0100
Message-Id: <20191211150351.930947776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit f770e3bc236ee954a3b4052bdf55739e26ee25db ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/usb/mtu3/mtu3_qmu.c: In function 'qmu_tx_zlp_error_handler':
drivers/usb/mtu3/mtu3_qmu.c:385:22: warning:
 variable 'req' set but not used [-Wunused-but-set-variable]

It seems dbginfo original intention is print 'req' other than 'mreq'

Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_qmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_qmu.c b/drivers/usb/mtu3/mtu3_qmu.c
index ff62ba2321779..326b40747128c 100644
--- a/drivers/usb/mtu3/mtu3_qmu.c
+++ b/drivers/usb/mtu3/mtu3_qmu.c
@@ -427,7 +427,7 @@ static void qmu_tx_zlp_error_handler(struct mtu3 *mtu, u8 epnum)
 		return;
 	}
 
-	dev_dbg(mtu->dev, "%s send ZLP for req=%p\n", __func__, mreq);
+	dev_dbg(mtu->dev, "%s send ZLP for req=%p\n", __func__, req);
 
 	mtu3_clrbits(mbase, MU3D_EP_TXCR0(mep->epnum), TX_DMAREQEN);
 
-- 
2.20.1



