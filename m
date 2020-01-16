Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220F513EE20
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405846AbgAPSHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393439AbgAPRjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9E724700;
        Thu, 16 Jan 2020 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196350;
        bh=CPfwDNy1xAd9rZ4cs5BD+7Xze0X8gxbRUSw9BiBcjrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfIsov0nAk1AzTJ+SGs/oixzUrGA+nJVBET4F6owA9l1TrXSXk1kR11OdqS/e5pJ1
         JWgGXeKjQyHves5X/BS68ataqVKS7PLLO9R7WuRfzR69htheQUHzV7wD9SiqmzpoE6
         JmCUiRhu7zTQQaUaJ4xJLqb+bXvZqqG+qkfQa29Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 144/251] spi: spi-fsl-spi: call spi_finalize_current_message() at the end
Date:   Thu, 16 Jan 2020 12:34:53 -0500
Message-Id: <20200116173641.22137-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 44a042182cb1e9f7916e015c836967bf638b33c4 ]

spi_finalize_current_message() shall be called once all
actions are finished, otherwise the last actions might
step over a newly started transfer.

Fixes: c592becbe704 ("spi: fsl-(e)spi: migrate to generic master queueing")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 8b290d9d7935..5419de19859a 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -408,7 +408,6 @@ static int fsl_spi_do_one_msg(struct spi_master *master,
 	}
 
 	m->status = status;
-	spi_finalize_current_message(master);
 
 	if (status || !cs_change) {
 		ndelay(nsecs);
@@ -416,6 +415,7 @@ static int fsl_spi_do_one_msg(struct spi_master *master,
 	}
 
 	fsl_spi_setup_transfer(spi, NULL);
+	spi_finalize_current_message(master);
 	return 0;
 }
 
-- 
2.20.1

