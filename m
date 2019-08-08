Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E7869A7
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404589AbfHHTJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404639AbfHHTJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C09A21743;
        Thu,  8 Aug 2019 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291367;
        bh=511qxL64TT1xYUu3SqWjnuT6iNx/GiDqgxS3RiPd8XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxuxDu2W5L7QdX3pF9cdA6N777SfXzx6WFDWSH3PL/I0kk/DKP0RWAX4aC0p5vkZD
         2DaoaTgGp1VWTW0X3g/PMrwGvmAISAEgARLnrlIgQSfAhP8OEwWMLoivXMRCT77PNF
         KBev16H1DHcfVrOgD1pF6cXuNQVSpu1FY9anvVqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 33/45] ocelot: Cancel delayed work before wq destruction
Date:   Thu,  8 Aug 2019 21:05:19 +0200
Message-Id: <20190808190455.643738567@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit c5d139697d5d9ecf9c7cd92d7d7838a173508900 ]

Make sure the delayed work for stats update is not pending before
wq destruction.
This fixes the module unload path.
The issue is there since day 1.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1767,6 +1767,7 @@ EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
+	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
 }


