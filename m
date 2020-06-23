Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FDE205D57
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388944AbgFWUMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387612AbgFWUMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C214420707;
        Tue, 23 Jun 2020 20:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943128;
        bh=cIGi7f44F9fI57GkzRC8e+rGive0O2H72b3r/AtLP00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPTL8iLPWw0f7ruF5HrW9Mb8+YcRFpVo5zsBqdIFxWxfMqEgVOBcGjoLY1eUfom51
         vthjilmP5Ua7ryAxfpsRP1K8+0lBkPU9BR225o5S8GAo2fxj98VlcqStixiDll5hWD
         91oantteTwiFJeMWcwpKb49dAMIpkI42VSSf271I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 240/477] firmware: imx: scu: Fix possible memory leak in imx_scu_probe()
Date:   Tue, 23 Jun 2020 21:53:57 +0200
Message-Id: <20200623195418.921054673@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 89f12d6509bff004852c51cb713a439a86816b24 ]

'chan_name' is malloced in imx_scu_probe() and should be freed
before leaving from the error handling cases, otherwise it will
cause memory leak.

Fixes: edbee095fafb ("firmware: imx: add SCU firmware driver support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index b3da2e193ad2d..176ddd151375a 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -314,6 +314,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Failed to request mbox chan %s ret %d\n",
 					chan_name, ret);
+			kfree(chan_name);
 			return ret;
 		}
 
-- 
2.25.1



