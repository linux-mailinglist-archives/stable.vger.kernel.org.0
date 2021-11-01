Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A424416BF
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhKAJ2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232454AbhKAJ06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BB5611BF;
        Mon,  1 Nov 2021 09:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758553;
        bh=YjSIW8xYew536ToGDQ3XeXEtgw9a/xeQzl1KwDE6mE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge4szWAbsZ7Y/kWXu1KOBGybicdG4/HefhrBv4lkwPQ/QUgayNJHiQCMWXfSM7uPR
         DKrnlt70PD7MPkkv4UIFLY7uMQfxeu0uocg/BX++RXhD6ymYpa8VGiIeXFrxMeOeCB
         yQ8Y3PpFjjaPWJ9xnJM2mNFaw0nEOwlnBMZm9MXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.4 11/51] ata: sata_mv: Fix the error handling of mv_chip_id()
Date:   Mon,  1 Nov 2021 10:17:15 +0100
Message-Id: <20211101082503.231402527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit a0023bb9dd9bc439d44604eeec62426a990054cd upstream.

mv_init_host() propagates the value returned by mv_chip_id() which in turn
gets propagated by mv_pci_init_one() and hits local_pci_probe().

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Since this is a bug rather than a recoverable runtime error we should
use dev_alert() instead of dev_err().

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_mv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -3892,8 +3892,8 @@ static int mv_chip_id(struct ata_host *h
 		break;
 
 	default:
-		dev_err(host->dev, "BUG: invalid board index %u\n", board_idx);
-		return 1;
+		dev_alert(host->dev, "BUG: invalid board index %u\n", board_idx);
+		return -EINVAL;
 	}
 
 	hpriv->hp_flags = hp_flags;


