Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44F3C5285
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbhGLHqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349821AbhGLHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E519613B2;
        Mon, 12 Jul 2021 07:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075679;
        bh=8Y+8ynbx2OCSKfxB71y/b0xJs0zIgHjnEj/SFWeN/FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u671Mm/aEondtJRQW8oG3iPewxVaQTPsI1auN68O0ccIm+bl2COhfIMIevjJ3ggvB
         AFzP1TTm/Kj1uMkbNfPVZp+oX02rSjoEyLJVI541y4XDtQlpwKgTnpq0goeylvYeiC
         iCfLxpyZn/96wULprfdQs5hBd+/MwTxFOTUm0CKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 291/800] media: rc: i2c: Fix an error message
Date:   Mon, 12 Jul 2021 08:05:14 +0200
Message-Id: <20210712060955.947846459@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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



