Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE153CDD9C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245706AbhGSO67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245284AbhGSO6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036B6613ED;
        Mon, 19 Jul 2021 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708945;
        bh=aDRRLUafS4zsdJ3CZzhWpm2UJXxV13rq9QgOzUVfk/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXjTWgo4Zbrc/1u4nm1KqDPin9CSecQDH7okreV/kRKeg7264dD+odlTT/9roO08T
         M6v6wbtajSf05YWO0x7A7OGXebEtA0E1sLewKvNUlvCFaHD9TOspeCSbAUAC3a8eVc
         Xg21Lwhe8WSuJsXZOC1Rj1I2rXK88977hLlEpY18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joachim Fenkes <FENKES@de.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/421] fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE
Date:   Mon, 19 Jul 2021 16:50:04 +0200
Message-Id: <20210719144953.095910987@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joachim Fenkes <FENKES@de.ibm.com>

[ Upstream commit 95152433e46fdb36652ebdbea442356a16ae1fa6 ]

When the SBE requests a reset via the down FIFO, that is also the
FIFO we should go and reset ;)

Fixes: 9f4a8a2d7f9d ("fsi/sbefifo: Add driver for the SBE FIFO")
Signed-off-by: Joachim Fenkes <FENKES@de.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200724071518.430515-2-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-sbefifo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index 9fa3959e0855..b43c2d424d00 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -400,7 +400,7 @@ static int sbefifo_cleanup_hw(struct sbefifo *sbefifo)
 	/* The FIFO already contains a reset request from the SBE ? */
 	if (down_status & SBEFIFO_STS_RESET_REQ) {
 		dev_info(dev, "Cleanup: FIFO reset request set, resetting\n");
-		rc = sbefifo_regw(sbefifo, SBEFIFO_UP, SBEFIFO_PERFORM_RESET);
+		rc = sbefifo_regw(sbefifo, SBEFIFO_DOWN, SBEFIFO_PERFORM_RESET);
 		if (rc) {
 			sbefifo->broken = true;
 			dev_err(dev, "Cleanup: Reset reg write failed, rc=%d\n", rc);
-- 
2.30.2



