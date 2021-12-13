Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C29472764
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhLMKAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbhLMJ60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9AFC08EB1F;
        Mon, 13 Dec 2021 01:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32121B80E26;
        Mon, 13 Dec 2021 09:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75502C341CE;
        Mon, 13 Dec 2021 09:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388907;
        bh=+I1AANqHeYin+S5WleYA3KXnEk3L7lSrogsypINRZPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WN2Z8saysGDEminAjK/TowHsCWXDkkK3I42FgUF0llP255hyEalWj3DqiTcBo55rT
         7RkzKB4xiuTouC81Xlwh6OKi1UeTOyLJXVge4+toRnlC4ZrUCpCwTbZer6mm+mxt/h
         UIbx/b2WVPdk//pLfIrOwFKHTE7EJ6Rl8PrnzoZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 018/132] can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter
Date:   Mon, 13 Dec 2021 10:29:19 +0100
Message-Id: <20211213092939.713588605@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

commit 36aea60fc892ce73f96d45dc7eb239c7c4c1fa69 upstream.

Check the direction bit in the error frame packet (EPACK) to determine
which net_device_stats {rx,tx}_errors counter to increase.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Link: https://lore.kernel.org/all/20211208152122.250852-1-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -248,6 +248,9 @@ MODULE_DESCRIPTION("CAN driver for Kvase
 #define KVASER_PCIEFD_SPACK_EWLR BIT(23)
 #define KVASER_PCIEFD_SPACK_EPLR BIT(24)
 
+/* Kvaser KCAN_EPACK second word */
+#define KVASER_PCIEFD_EPACK_DIR_TX BIT(0)
+
 struct kvaser_pciefd;
 
 struct kvaser_pciefd_can {
@@ -1285,7 +1288,10 @@ static int kvaser_pciefd_rx_error_frame(
 
 	can->err_rep_cnt++;
 	can->can.can_stats.bus_error++;
-	stats->rx_errors++;
+	if (p->header[1] & KVASER_PCIEFD_EPACK_DIR_TX)
+		stats->tx_errors++;
+	else
+		stats->rx_errors++;
 
 	can->bec.txerr = bec.txerr;
 	can->bec.rxerr = bec.rxerr;


