Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8003C4C1D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbhGLHBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241311AbhGLHB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 391B76124B;
        Mon, 12 Jul 2021 06:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073119;
        bh=uu4IOEsZsfgAPk2eecSoxen6XKp6DK3pLY4HKZJa1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcKL0O0uqHgDTTGUcU4nKEZoWQqWjrK37H9LDFzrPiILpGqAz6wMVZcNbXTUlv/no
         5iOn64Gioa53q0liZRl7ueh+njFEqu75Q0WH9yXt32vZ92sQo/nqbqrDAATakJ26XE
         r7kloK9dpFDw34Q+44fJPqYH6m+WRL/+1hBPvZ8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Fang <f.fangjian@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 134/700] spi: spi-loopback-test: Fix tx_buf might be rx_buf
Date:   Mon, 12 Jul 2021 08:03:37 +0200
Message-Id: <20210712060944.350739505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Fang <f.fangjian@huawei.com>

[ Upstream commit 9e37a3ab0627011fb63875e9a93094b6fc8ddf48 ]

In function 'spi_test_run_iter': Value 'tx_buf' might be 'rx_buf'.

Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/1620629903-15493-5-git-send-email-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loopback-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index df981e55c24c..89b91cdfb2a5 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -874,7 +874,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2



