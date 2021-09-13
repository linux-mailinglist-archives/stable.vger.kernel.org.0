Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D69409282
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbhIMOLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345079AbhIMOJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C2D60F3A;
        Mon, 13 Sep 2021 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540494;
        bh=DOzj4Ygmi+FMjr4Fa28O+JHTZ8km7wUXPJlgxXwdLso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5mse4+f+65iU7Ki2oHlWBLz65CFt8rDcrCqjeW1wx4cby5EWwAxQjGCyz7LXjhas
         K4j14vQbhhqnpk7KNRrmkDO58qhVwyQbKx57HdMF/wuxDsmnx1X81sSr8wYw3f6kjP
         XojHQX7PMqYKHZuN6ONT9l3380ufBTb30rkoJajM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 216/300] rsi: fix error code in rsi_load_9116_firmware()
Date:   Mon, 13 Sep 2021 15:14:37 +0200
Message-Id: <20210913131116.660031118@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d0f8430332a16c7baa80ce2886339182c5d85f37 ]

This code returns success if the kmemdup() fails, but obviously it
should return -ENOMEM instead.

Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210805103746.GA26417@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 99b21a2c8386..f4a26f16f00f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -1038,8 +1038,10 @@ static int rsi_load_9116_firmware(struct rsi_hw *adapter)
 	}
 
 	ta_firmware = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!ta_firmware)
+	if (!ta_firmware) {
+		status = -ENOMEM;
 		goto fail_release_fw;
+	}
 	fw_p = ta_firmware;
 	instructions_sz = fw_entry->size;
 	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", instructions_sz);
-- 
2.30.2



