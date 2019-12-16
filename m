Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0A1218F6
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfLPSrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:47:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfLPRzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5A2206B7;
        Mon, 16 Dec 2019 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518903;
        bh=jKxl8pwLoUXEuKW0Cte+ClJeAfixsXqiRXb5el6oK3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcJ98yZCDzTYY8XQyvqMJUhiBOhk4FMx0bAQcjVv9dcnMIQRi7k2WZGYVHlTbXXL3
         V/1p3v23h85uaPtmq5wIxflzdlG1gRbr/m45ZEpMo6qQILqfqnh16wQpb4RUWR5JVl
         2TYkhFnvdadKdZwPWTdI/MHxoOUj+Jjll82xa2Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/267] usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler
Date:   Mon, 16 Dec 2019 18:47:21 +0100
Message-Id: <20191216174903.009996904@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 7d9ba8a52368f..c87947fb26940 100644
--- a/drivers/usb/mtu3/mtu3_qmu.c
+++ b/drivers/usb/mtu3/mtu3_qmu.c
@@ -372,7 +372,7 @@ static void qmu_tx_zlp_error_handler(struct mtu3 *mtu, u8 epnum)
 		return;
 	}
 
-	dev_dbg(mtu->dev, "%s send ZLP for req=%p\n", __func__, mreq);
+	dev_dbg(mtu->dev, "%s send ZLP for req=%p\n", __func__, req);
 
 	mtu3_clrbits(mbase, MU3D_EP_TXCR0(mep->epnum), TX_DMAREQEN);
 
-- 
2.20.1



