Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CEA26B698
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgIPAHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgIOO2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC709206B7;
        Tue, 15 Sep 2020 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179631;
        bh=lm/5WL8/DNM6NeRmWrpsUBREXpIwq7NtAjC3t2A6Ua8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfkQNLKy8bdw4pZR6dqqCo+Ege3PFVrBy6MK/wM6nwQdAuTifwjT2z9Y/7GXTlUqN
         bKhwuNhiJxSHJEyMEtj6JNBxG6FZxGk0pCPv+ReC1JqBKIUH3j3ou7DgJ/gJ/heBA8
         qAvM5SFqAdrk2esytVkRjlPViBE7MmEEHT6o8rIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/132] spi: stm32: fix pm_runtime_get_sync() error checking
Date:   Tue, 15 Sep 2020 16:12:11 +0200
Message-Id: <20200915140645.571719963@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
index 09b418ff99b16..9d8ceb63f7db1 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2054,7 +2054,7 @@ static int stm32_spi_resume(struct device *dev)
 	}
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "Unable to power device:%d\n", ret);
 		return ret;
 	}
-- 
2.25.1



