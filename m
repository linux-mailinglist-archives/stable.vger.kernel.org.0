Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B379468AE8
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhLENEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLENEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672E9C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 05:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31DE2B80E3C
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E5C341C5;
        Sun,  5 Dec 2021 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638709275;
        bh=IBqyVbVl+xcM7laWHxIKTKOxqko2rePADRb3rnoDITs=;
        h=Subject:To:Cc:From:Date:From;
        b=BJNtuMFfB5h4nNshEmd0r5JMIdn2wzEQ+4T3BjZZzg/tNbor1J03AHOOKo82M5X6o
         rX32PbwbxqUdbKbMeKQrkPLYTCFFD2QN01hMH5iJa82pAWo27AVyELmMKNNw9XT5Iz
         0F8y8gQcUiGCY4i4AlGOsdh4JVPdYto1rO45rc04=
Subject: FAILED: patch "[PATCH] i2c: stm32f7: recover the bus on access timeout" failed to apply to 4.14-stable tree
To:     alain.volmat@foss.st.com, pierre-yves.mordret@foss.st.com,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:01:12 +0100
Message-ID: <16387092725043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b933d1faf8fa30d16171bcff404e39c41b2a7c84 Mon Sep 17 00:00:00 2001
From: Alain Volmat <alain.volmat@foss.st.com>
Date: Mon, 20 Sep 2021 17:21:30 +0200
Subject: [PATCH] i2c: stm32f7: recover the bus on access timeout

When getting an access timeout, ensure that the bus is in a proper
state prior to returning the error.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index ed977b6f7ab6..ad3459a3bc5e 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1712,6 +1712,7 @@ static int stm32f7_i2c_xfer(struct i2c_adapter *i2c_adap,
 			i2c_dev->msg->addr);
 		if (i2c_dev->use_dma)
 			dmaengine_terminate_all(dma->chan_using);
+		stm32f7_i2c_wait_free_bus(i2c_dev);
 		ret = -ETIMEDOUT;
 	}
 
@@ -1769,6 +1770,7 @@ static int stm32f7_i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 		dev_dbg(dev, "Access to slave 0x%x timed out\n", f7_msg->addr);
 		if (i2c_dev->use_dma)
 			dmaengine_terminate_all(dma->chan_using);
+		stm32f7_i2c_wait_free_bus(i2c_dev);
 		ret = -ETIMEDOUT;
 		goto pm_free;
 	}

