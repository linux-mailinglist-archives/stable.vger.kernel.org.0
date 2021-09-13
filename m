Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709C9408D48
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhIMNYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241031AbhIMNWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A621610CC;
        Mon, 13 Sep 2021 13:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539264;
        bh=O1hXRKYs+5cQz8oiWTykWZg2YuTkDUuRks5u5UGTH6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWy6q3/BE6acBBJ6VVeWFnN070xyZtLtV8bLrVUrornFh9J4cntEnqpb/+uSSps2X
         jX817Ste11TCe6NqNufd+oIH5snCyQOz+nITWE4ltf3FquIOqVMo2NbcHmRfpALIfo
         qJst81ltfbFRYlOvCz5x0ubvOWViv+e2GcG5Dkpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/144] rsi: fix an error code in rsi_probe()
Date:   Mon, 13 Sep 2021 15:14:45 +0200
Message-Id: <20210913131051.421570396@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9adcdf6758d7c4c9bdaf22d78eb9fcae260ed113 ]

Return -ENODEV instead of success for unsupported devices.

Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210816183947.GA2119@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index a296f4e0d324..e8aa3d4bda88 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -806,6 +806,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
 			__func__, id->idProduct);
+		status = -ENODEV;
 		goto err1;
 	}
 
-- 
2.30.2



