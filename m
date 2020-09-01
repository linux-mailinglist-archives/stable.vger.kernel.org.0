Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4E125968D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgIAQER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbgIAPmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:42:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 391762064B;
        Tue,  1 Sep 2020 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974932;
        bh=yHyrhqyRzo37n6XS5S+rgv5s3Y3LcuonABG1xHhiZc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixpzo2XL8ji44SZl6wlvYXne2s/VxYxf5VgW5xCEMS8eYKKoZMsW/0EWinhyJqM9A
         chFOkdY8+LzEz/tgD9KR+hWPkEl+Y4Atb0u8kNJjdtjGQNtH+dY80ELgqVaqBqQhrF
         ky1KkO3mAwDFwE8Y+a4U9oaQDvTFvQcyASO/s0o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 118/255] spi: stm32h7: fix race condition at end of transfer
Date:   Tue,  1 Sep 2020 17:09:34 +0200
Message-Id: <20200901151006.382895121@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit 135dd873d3c76d812ae64c668adef3f2c59ed27f ]

The caller of stm32_spi_transfer_one(), spi_transfer_one_message(),
is waiting for us to call spi_finalize_current_transfer() and will
eventually schedule a new transfer, if available.
We should guarantee that the spi controller is really available
before calling spi_finalize_current_transfer().

Move the call to spi_finalize_current_transfer() _after_ the call
to stm32_spi_disable().

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/1597043558-29668-2-git-send-email-alain.volmat@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 13f3d959759fb..fce679635829c 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -972,8 +972,8 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 	spin_unlock_irqrestore(&spi->lock, flags);
 
 	if (end) {
-		spi_finalize_current_transfer(master);
 		stm32h7_spi_disable(spi);
+		spi_finalize_current_transfer(master);
 	}
 
 	return IRQ_HANDLED;
-- 
2.25.1



