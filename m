Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D821A0BDE
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgDGK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgDGKXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F9C20644;
        Tue,  7 Apr 2020 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586254999;
        bh=KN/RtJgBrXn5vFfRyb79eWSReJRlqg0mW2vgwy54kG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vjWMt2MZMm4jwhQktqdmIul+0dd4+BePvv7umsT9xls1hX8k0AYhZ0twHF9wl62+
         qYEZhqHE+7M7gcv9kTrvczBxEbzkOn1G0985B3pZj5v02CU/2XJzq6hNZ3y5g4hNb4
         liE7gzqOcFmd1AOf6wB+kOkVCpmt09QtCwn+5hNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bibby Hsieh <bibby.hsieh@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.4 26/36] soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper
Date:   Tue,  7 Apr 2020 12:21:59 +0200
Message-Id: <20200407101457.599722726@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bibby Hsieh <bibby.hsieh@mediatek.com>

commit ce35e21d82bcac8b3fd5128888f9e233f8444293 upstream.

Mediatek CMDQ driver have a mechanism to do TXDONE_BY_ACK,
so we should set knows_txdone.

Fixes:576f1b4bc802 ("soc: mediatek: Add Mediatek CMDQ helper")

Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Bibby Hsieh <bibby.hsieh@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/mediatek/mtk-cmdq-helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -38,6 +38,7 @@ struct cmdq_client *cmdq_mbox_create(str
 	client->pkt_cnt = 0;
 	client->client.dev = dev;
 	client->client.tx_block = false;
+	client->client.knows_txdone = true;
 	client->chan = mbox_request_channel(&client->client, index);
 
 	if (IS_ERR(client->chan)) {


