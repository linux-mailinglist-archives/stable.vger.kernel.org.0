Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1396F441639
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhKAJX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232286AbhKAJWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3CEF61167;
        Mon,  1 Nov 2021 09:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758397;
        bh=kApMBtplrYEmFvcFXyx9aO6SMwJEaX86FxI5TNcr8SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRqjqUH75OtZyFn6BbhA4FPBDXChI0Y9kVotf9LKR2f/ByHIdvkXZsjh945XzDT8x
         dHOK+wuzRVELwkoVAPUjlvlLALBPpzC3sBCfF7aMEhjKHng1l/H+IsnaAJHiw1axn3
         DAMbrK6d1DC/ECX9FcNO9yO8qlVkhwIDIBMAWQt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.9 08/20] ata: sata_mv: Fix the error handling of mv_chip_id()
Date:   Mon,  1 Nov 2021 10:17:17 +0100
Message-Id: <20211101082445.967120970@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
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
@@ -3907,8 +3907,8 @@ static int mv_chip_id(struct ata_host *h
 		break;
 
 	default:
-		dev_err(host->dev, "BUG: invalid board index %u\n", board_idx);
-		return 1;
+		dev_alert(host->dev, "BUG: invalid board index %u\n", board_idx);
+		return -EINVAL;
 	}
 
 	hpriv->hp_flags = hp_flags;


