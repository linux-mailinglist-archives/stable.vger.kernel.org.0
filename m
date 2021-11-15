Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CA7451486
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348389AbhKOUJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:09:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344694AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 418F9636B4;
        Mon, 15 Nov 2021 19:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002954;
        bh=YtaMPtqdXB9HnZuqhvw6aEJQon/86GJold/KYhtH5Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qg4xn4Ob1W78nzuJVL8qk3BYhJItha0t3L2mXRw3JGFgkDb3AunAOCkBC7eUVGZGl
         3ibpO8fi+2QHXH8jzBLgRteXFuM0ilEmyvxXMZtI9N8a2Es7vtwR8NbdZSuTIgPtcD
         MqY6Mo3zo4tp5KtlX0QvL/L1xXUido9GAFgACqzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 757/917] i2c: xlr: Fix a resource leak in the error handling path of xlr_i2c_probe()
Date:   Mon, 15 Nov 2021 18:04:12 +0100
Message-Id: <20211115165454.576550024@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7f98960c046ee1136e7096aee168eda03aef8a5d ]

A successful 'clk_prepare()' call should be balanced by a corresponding
'clk_unprepare()' call in the error handling path of the probe, as already
done in the remove function.

More specifically, 'clk_prepare_enable()' is used, but 'clk_disable()' is
also already called. So just the unprepare step has still to be done.

Update the error handling path accordingly.

Fixes: 75d31c2372e4 ("i2c: xlr: add support for Sigma Designs controller variant")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xlr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xlr.c b/drivers/i2c/busses/i2c-xlr.c
index 126d1393e548b..9ce20652d4942 100644
--- a/drivers/i2c/busses/i2c-xlr.c
+++ b/drivers/i2c/busses/i2c-xlr.c
@@ -431,11 +431,15 @@ static int xlr_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&priv->adap, priv);
 	ret = i2c_add_numbered_adapter(&priv->adap);
 	if (ret < 0)
-		return ret;
+		goto err_unprepare_clk;
 
 	platform_set_drvdata(pdev, priv);
 	dev_info(&priv->adap.dev, "Added I2C Bus.\n");
 	return 0;
+
+err_unprepare_clk:
+	clk_unprepare(clk);
+	return ret;
 }
 
 static int xlr_i2c_remove(struct platform_device *pdev)
-- 
2.33.0



