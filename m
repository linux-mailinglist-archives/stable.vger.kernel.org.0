Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E2B27C712
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgI2LtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbgI2Lsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F9AE21924;
        Tue, 29 Sep 2020 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380131;
        bh=LvTs8pCfr3tRldZZ/pebDHhOaJCZzgUPWnIIur48HUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qbdr0dVGNUREt1C35d3QC8ZThRmE58fa40VDe24PYhhKCqwJeLfYcv4dIbMy4M5lu
         36WSj1O7S57rwnXzduSu0a2JqQ5K98vqhRsR+S8mhueFPmRtQz6BuH0MwkyDcWS9MJ
         DoTRfPgouPLDqle+tyGXeSGdNOCSlYlnXFPXemVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.8 81/99] mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/removing stations
Date:   Tue, 29 Sep 2020 13:02:04 +0200
Message-Id: <20200929105933.720330373@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit d1c9da9e4c938e8bbf8b0ef9e5772b97db5639e9 upstream.

The implementation of embedding WTBL update inside the STA_REC update is buggy
on the MT7615 v2 firmware. This leads to connection issues after a station has
connected and disconnected again.

Switch to the v1 MCU API ops, since they have received much more testing and
should be more stable.

On MT7622 and later, the v2 API is more actively used, so we should keep using
it as well.

Fixes: 6849e29ed92e ("mt76: mt7615: add starec operating flow for firmware v2")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200812102332.11812-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2014,7 +2014,8 @@ static int mt7615_load_n9(struct mt7615_
 		 sizeof(dev->mt76.hw->wiphy->fw_version),
 		 "%.10s-%.15s", hdr->fw_ver, hdr->build_date);
 
-	if (!strncmp(hdr->fw_ver, "2.0", sizeof(hdr->fw_ver))) {
+	if (!is_mt7615(&dev->mt76) &&
+	    !strncmp(hdr->fw_ver, "2.0", sizeof(hdr->fw_ver))) {
 		dev->fw_ver = MT7615_FIRMWARE_V2;
 		dev->mcu_ops = &sta_update_ops;
 	} else {


