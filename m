Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C3F3CDCE9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbhGSOyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238282AbhGSOvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C88E2611ED;
        Mon, 19 Jul 2021 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708721;
        bh=yYso1GWpuILLPKjycXFUA+uQUbPKvJ4caxRApuzH5YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM6doHaJQCyxo1+XYqMXfzzXwyNVLTXWJbyEGGzUKHr5vMC7qfajC359cXyg0cmmM
         jLF+ouUXSiQoctHzMgaQP5LhpBVPbypaMUWeeUkIIRp1oQUJANzh1zJG5o5wTal9wd
         2R4D1ZNshii0c8hlUaJXzW3yj07oKWr0fmZ8lfMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/421] media: rc: i2c: Fix an error message
Date:   Mon, 19 Jul 2021 16:48:34 +0200
Message-Id: <20210719144950.170843522@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9c87ae1a0dbeb5794957421157fd266d38a869b4 ]

'ret' is known to be 1 here. In fact 'i' is expected instead.
Store the return value of 'i2c_master_recv()' in 'ret' so that the error
message print the correct error code.

Fixes: acaa34bf06e9 ("media: rc: implement zilog transmitter")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index a14a74e6b986..19ff9cb08e88 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -688,8 +688,8 @@ static int zilog_tx(struct rc_dev *rcdev, unsigned int *txbuf,
 		goto out_unlock;
 	}
 
-	i = i2c_master_recv(ir->tx_c, buf, 1);
-	if (i != 1) {
+	ret = i2c_master_recv(ir->tx_c, buf, 1);
+	if (ret != 1) {
 		dev_err(&ir->rc->dev, "i2c_master_recv failed with %d\n", ret);
 		ret = -EIO;
 		goto out_unlock;
-- 
2.30.2



