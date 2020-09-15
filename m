Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D526B52A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgIOXhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3C42224A;
        Tue, 15 Sep 2020 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179959;
        bh=S2lpl7cJCH8k86S3isb6+lxcBkcnXCLPfDJsLAkhxKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8/kOP5JLpNRb0u9pNW9zMVXQaUjpvozVwzZFv4PZkQSt+aqPGNiRQJ6xPlXvEwN4
         C5xklnwfzzeEUhpjTlG0sIsJMZMIo2BgqaGVw1C4ARpzeIUgPe+O74PSKK17H+7L2c
         kMHxmoDrk3jUhRGXyFXYH4b4vpiekNUUU8iQsXHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 051/177] spi: stm32: fix pm_runtime_get_sync() error checking
Date:   Tue, 15 Sep 2020 16:12:02 +0200
Message-Id: <20200915140656.076740999@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c170a5a3b6944ad8e76547c4a1d9fe81c8f23ac8 ]

The pm_runtime_get_sync() can return either 0 or 1 on success but this
code treats 1 as a failure.

Fixes: db96bf976a4f ("spi: stm32: fixes suspend/resume management")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/20200909094304.GA420136@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index a00f6b51ccbfc..3056428b09f31 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2064,7 +2064,7 @@ static int stm32_spi_resume(struct device *dev)
 	}
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "Unable to power device:%d\n", ret);
 		return ret;
 	}
-- 
2.25.1



