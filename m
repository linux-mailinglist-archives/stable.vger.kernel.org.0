Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09C43AEE93
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFUQaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhFUQ3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E138861353;
        Mon, 21 Jun 2021 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292640;
        bh=UkDxa+fl9rFOLo1Io0faeV/fqWbjlXYKuHxxv5ocWTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixSzxK8mzy0Oo6Xuf5q+FbMbPNWHWSF19STfZ5ZMiNO6ZUsbC+IoG9RxFwR8RGkBK
         b47Hcj9gxRGKSC8tZXbaR+mqAwaY8wIXrizjIGH54St3dsNrDAQa83wtbiSAUe3PEc
         wvMrUZ9+oKTApxCzKEh0+D1+JzvvYV095IkO0+vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/146] regulator: cros-ec: Fix error code in dev_err message
Date:   Mon, 21 Jun 2021 18:15:04 +0200
Message-Id: <20210621154915.604917424@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 3d681804efcb6e5d8089a433402e19179347d7ae ]

Show proper error code instead of 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210512075824.620580-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/cros-ec-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/cros-ec-regulator.c b/drivers/regulator/cros-ec-regulator.c
index eb3fc1db4edc..c4754f3cf233 100644
--- a/drivers/regulator/cros-ec-regulator.c
+++ b/drivers/regulator/cros-ec-regulator.c
@@ -225,8 +225,9 @@ static int cros_ec_regulator_probe(struct platform_device *pdev)
 
 	drvdata->dev = devm_regulator_register(dev, &drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		return PTR_ERR(drvdata->dev);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
-- 
2.30.2



