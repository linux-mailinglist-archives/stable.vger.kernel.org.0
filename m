Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC2EEA0C6
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfJ3PxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbfJ3PxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:20 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 065BF208C0;
        Wed, 30 Oct 2019 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450799;
        bh=Jcyg7XjWUAWVTdX7CZVkV0MKQtcJLFsqCZ9uBBB3WFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2IKo0ffFhpbgm1ctSs7kwdvw2IQe7hLsFA9ItSN6uGk5Tsu/mxu5Q0TJYAK+OIQP
         WZU/+SmwVa9Q3P+fAkxQ5Q3rl3KdbL3t9td/znJy/B/T85rwDcjSL+LtQD/cqXko97
         P8Pr9dED8+y+UAaGBvHeQyk2NHkOP2bOhZjTHzEw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Michael Moese <mmoese@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 52/81] 8250-men-mcb: fix error checking when get_num_ports returns -ENODEV
Date:   Wed, 30 Oct 2019 11:48:58 -0400
Message-Id: <20191030154928.9432-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f50b6805dbb993152025ec04dea094c40cc93a0c ]

The current checking for failure on the number of ports fails when
-ENODEV is returned from the call to get_num_ports. Fix this by making
num_ports and loop counter i signed rather than unsigned ints. Also
add check for num_ports being less than zero to check for -ve error
returns.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: e2fea54e4592 ("8250-men-mcb: add support for 16z025 and 16z057")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Michael Moese <mmoese@suse.de>
Link: https://lore.kernel.org/r/20191013220016.9369-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_men_mcb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_men_mcb.c b/drivers/tty/serial/8250/8250_men_mcb.c
index 02c5aff58a740..8df89e9cd2542 100644
--- a/drivers/tty/serial/8250/8250_men_mcb.c
+++ b/drivers/tty/serial/8250/8250_men_mcb.c
@@ -72,8 +72,8 @@ static int serial_8250_men_mcb_probe(struct mcb_device *mdev,
 {
 	struct serial_8250_men_mcb_data *data;
 	struct resource *mem;
-	unsigned int num_ports;
-	unsigned int i;
+	int num_ports;
+	int i;
 	void __iomem *membase;
 
 	mem = mcb_get_resource(mdev, IORESOURCE_MEM);
@@ -88,7 +88,7 @@ static int serial_8250_men_mcb_probe(struct mcb_device *mdev,
 	dev_dbg(&mdev->dev, "found a 16z%03u with %u ports\n",
 		mdev->id, num_ports);
 
-	if (num_ports == 0 || num_ports > 4) {
+	if (num_ports <= 0 || num_ports > 4) {
 		dev_err(&mdev->dev, "unexpected number of ports: %u\n",
 			num_ports);
 		return -ENODEV;
@@ -133,7 +133,7 @@ static int serial_8250_men_mcb_probe(struct mcb_device *mdev,
 
 static void serial_8250_men_mcb_remove(struct mcb_device *mdev)
 {
-	unsigned int num_ports, i;
+	int num_ports, i;
 	struct serial_8250_men_mcb_data *data = mcb_get_drvdata(mdev);
 
 	if (!data)
-- 
2.20.1

