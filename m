Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81874832FD
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiACOcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59564 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiACOab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF05610F4;
        Mon,  3 Jan 2022 14:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055ADC36AEB;
        Mon,  3 Jan 2022 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220228;
        bh=t37gPzxOgCQvjx/xijSpfsfMnIiA4NxPElkFOSTgoCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUZN0WojNG2eIOSXa8XzZbS0Yc9CFuIgSNQ+GGSXwZdfTXXuW5/iR0bRBVjYuUCIm
         qa/dKzmwFllGiphN6dK4WJ0kyaHN/BK1yulXL8XogkuSt2lvqdB4/yPDAqrpUKlyPA
         kZHAlnIhYmkJPJba1Al91mDlaF3lELWYy25G6h+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James McLaughlin <james.mclaughlin@qsc.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/48] igc: Fix TX timestamp support for non-MSI-X platforms
Date:   Mon,  3 Jan 2022 15:24:03 +0100
Message-Id: <20220103142054.361993791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James McLaughlin <james.mclaughlin@qsc.com>

[ Upstream commit f85846bbf43de38fb2c89fe7d2a085608c4eb25a ]

Time synchronization was not properly enabled on non-MSI-X platforms.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index cae090a072524..61cebb7df6bcb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4422,6 +4422,9 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
@@ -4465,6 +4468,9 @@ static irqreturn_t igc_intr(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
-- 
2.34.1



