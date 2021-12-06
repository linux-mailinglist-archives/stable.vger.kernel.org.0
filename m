Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC88469DE3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356403AbhLFPd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47442 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387049AbhLFPaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D63C612EB;
        Mon,  6 Dec 2021 15:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2933C34900;
        Mon,  6 Dec 2021 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804425;
        bh=D5DeeOBW35ZP2lTUhkmmE156g38q29eIftaRf60xowM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSd2or9TuYwlKvwfsXIk7Az0SLj4W/RXXyRd9XCNNQs3PeeL+1YINO8zvHAGMJvPe
         SzrVsLO+xLYjaJLjUvDhRQLaf43ArLKHCBbGybOhEdssiisMR3JcoaM+GqIyuhNdok
         kpIFCMziF6okcUs0GuSEBWmwe2XgjVqzutectxAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 100/207] i2c: stm32f7: recover the bus on access timeout
Date:   Mon,  6 Dec 2021 15:55:54 +0100
Message-Id: <20211206145613.705375185@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

commit b933d1faf8fa30d16171bcff404e39c41b2a7c84 upstream.

When getting an access timeout, ensure that the bus is in a proper
state prior to returning the error.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1712,6 +1712,7 @@ static int stm32f7_i2c_xfer(struct i2c_a
 			i2c_dev->msg->addr);
 		if (i2c_dev->use_dma)
 			dmaengine_terminate_all(dma->chan_using);
+		stm32f7_i2c_wait_free_bus(i2c_dev);
 		ret = -ETIMEDOUT;
 	}
 
@@ -1769,6 +1770,7 @@ static int stm32f7_i2c_smbus_xfer(struct
 		dev_dbg(dev, "Access to slave 0x%x timed out\n", f7_msg->addr);
 		if (i2c_dev->use_dma)
 			dmaengine_terminate_all(dma->chan_using);
+		stm32f7_i2c_wait_free_bus(i2c_dev);
 		ret = -ETIMEDOUT;
 		goto pm_free;
 	}


