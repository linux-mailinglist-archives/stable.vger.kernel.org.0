Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE902409585
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346334AbhIMOmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347222AbhIMOkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96CF261D7C;
        Mon, 13 Sep 2021 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541359;
        bh=Ebt2wk8FtArTQwmmLB+5B6eQf6OubKgn2BFjnf5wG4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmjgdyR2okUDh2kO1vV9+1HzcFLIo0dp6m3TuL0dmmyL9lj2KDecjal702ed+z8yA
         7jjxC2QcM3G/8uYwyHlOXhCGDCY0UIe0gmT/QZrINIUn/xIWyNyvYXUvAR8z2OLlvm
         nHWQB/7E3D0tJci+ullUoLy8/D2+A4iTXr5lZdcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 239/334] rsi: fix an error code in rsi_probe()
Date:   Mon, 13 Sep 2021 15:14:53 +0200
Message-Id: <20210913131121.488005119@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 3fbe2a3c1455..416976f09888 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -816,6 +816,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
 			__func__, id->idProduct);
+		status = -ENODEV;
 		goto err1;
 	}
 
-- 
2.30.2



