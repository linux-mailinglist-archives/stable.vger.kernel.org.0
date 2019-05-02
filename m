Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632F411F55
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfEBPXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfEBPXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:23:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91A921743;
        Thu,  2 May 2019 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810612;
        bh=6bC4sujzDPneC8WgMYJgejpI4ScXjciKFuUAV5WoXwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5WVi1zlsBbneDUI6+FF7PGBlfN4c40i+iv3i/H5enNwmWGVbY6Rx8N7yWP8+YWS8
         a08VKZIqIURnDiIe6ICeMAFO4HpLWGktH2Qf7Wt5NEzFzUf8t8dI4eHaTESSV0KaqH
         scY5AyFci5hDpeIqdznXGivmiKyNbkQVc+d+IBxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 13/49] s390/qeth: fix race when initializing the IP address table
Date:   Thu,  2 May 2019 17:20:50 +0200
Message-Id: <20190502143325.771108416@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7221b727f0079a32aca91f657141e1de564d4b97 ]

The ucast IP table is utilized by some of the L3-specific sysfs attributes
that qeth_l3_create_device_attributes() provides. So initialize the table
_before_ registering the attributes.

Fixes: ebccc7397e4a ("s390/qeth: add missing hash table initializations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/s390/net/qeth_l3_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index a19f2dc69e8a..d9830c86d0c1 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -3022,12 +3022,14 @@ static int qeth_l3_probe_device(struct ccwgroup_device *gdev)
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 	int rc;
 
+	hash_init(card->ip_htable);
+
 	if (gdev->dev.type == &qeth_generic_devtype) {
 		rc = qeth_l3_create_device_attributes(&gdev->dev);
 		if (rc)
 			return rc;
 	}
-	hash_init(card->ip_htable);
+
 	hash_init(card->ip_mc_htable);
 	card->options.layer2 = 0;
 	card->info.hwtrap = 0;
-- 
2.19.1



