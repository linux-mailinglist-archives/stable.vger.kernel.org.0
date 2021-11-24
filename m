Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FAF45C0AB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244644AbhKXNKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348355AbhKXNJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C29FA61216;
        Wed, 24 Nov 2021 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757616;
        bh=42Y5+rXmA77QcjkgrSDGAwSlv9NS8sOO5evVFIAFJgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXl2k5InhxsCFBwWU+qBBaqXtlTfkKuMSbgD2h07KVMN2ZN/m/FdHcsepfPTo/xGq
         ZgNxbRPqCYGPWBIl7XzUjmjy/4loiCWjhowN8o2C9YYZEVmh9ymJ8T0UXYskh1gkb4
         wyAOvfJSlOCkGn60JeRIqpHQg2ohrjLG/u1nwUXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/323] i2c: xlr: Fix a resource leak in the error handling path of xlr_i2c_probe()
Date:   Wed, 24 Nov 2021 12:56:49 +0100
Message-Id: <20211124115726.325958403@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 34cd4b3085402..dda6cb848405b 100644
--- a/drivers/i2c/busses/i2c-xlr.c
+++ b/drivers/i2c/busses/i2c-xlr.c
@@ -433,11 +433,15 @@ static int xlr_i2c_probe(struct platform_device *pdev)
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



