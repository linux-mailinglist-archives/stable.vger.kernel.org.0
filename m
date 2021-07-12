Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360E3C4537
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhGLGYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhGLGX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13CDD610A7;
        Mon, 12 Jul 2021 06:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070815;
        bh=8Y+8ynbx2OCSKfxB71y/b0xJs0zIgHjnEj/SFWeN/FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/mmgPZ/SOsToET3E+0rHGHBboIXWizk572llvfkszPPJfumlaAmuO56j8jpHF004
         D5XWo1zTf6rfAQIK31zAhqFgD0q8REb2TzGtJwTW7BVB8ImrnhNU9T8VvNXigqAAe6
         7bx5rRkbWjX5fULjnnUNY5I2awexyGqgWePXr4KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/348] media: rc: i2c: Fix an error message
Date:   Mon, 12 Jul 2021 08:08:55 +0200
Message-Id: <20210712060721.140384869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index e8119ad0bc71..92376592455e 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -678,8 +678,8 @@ static int zilog_tx(struct rc_dev *rcdev, unsigned int *txbuf,
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



