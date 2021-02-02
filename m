Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9530CC50
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhBBTvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233142AbhBBNwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0D764FB8;
        Tue,  2 Feb 2021 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273402;
        bh=/gKE9i7us46RTrDmQyLDLmsqv04nXLnLT5KpJ4JXgso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XRPRkf7TpBKTxkYM2L+TK1Z2qvkJByHS3zTFMp9KJkDgRiBMDOMETktV/TY90Mw7
         ABZwM7iWsdvM+V/EwAiPoAli/86Teb1WqJgjpnkCtBLy4BTkah3lUiy6HmuwVB/bHN
         rY/eNx/NzAHsvmMUnIUIxuaW5tJvOeqnU+iuYgUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tom Rix <trix@redhat.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/142] spi: altera: Fix memory leak on error path
Date:   Tue,  2 Feb 2021 14:37:36 +0100
Message-Id: <20210202133001.548881247@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 55a8b42e8645a6dab88674a30cb6ed328e660680 ]

Release master that have been previously allocated if the number of
chipselect is invalid.

Fixes: 8e04187c1bc7 ("spi: altera: add SPI core parameters support via platform data.")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20210120082635.49304-1-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-altera.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index cbc4c28c1541c..62ea0c9e321b4 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -254,7 +254,8 @@ static int altera_spi_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"Invalid number of chipselect: %hu\n",
 				pdata->num_chipselect);
-			return -EINVAL;
+			err = -EINVAL;
+			goto exit;
 		}
 
 		master->num_chipselect = pdata->num_chipselect;
-- 
2.27.0



