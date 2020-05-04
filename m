Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1211C4478
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbgEDSHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732176AbgEDSHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278F320721;
        Mon,  4 May 2020 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615661;
        bh=bJ2l/CHYhXqqCQmXxTph5G9oI6DoxV3kjVdO3Qi3s38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9Cq5BuTeyKKghy+aCMQBB3+JBNn2GYhUZsOsolf29jWS0pdWH0io7nRtUiskmeRD
         6UxEcmPo0c2ug3+6a4yDvh3tMXqeVks2S1tlMSTpUPL8dasD9jV9yE/7IlB8xI8gjI
         doByrODGPO6/hil2Ma/aHtRyPEo0EJ+iOWzhXOhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seraj Alijan <seraj.alijan@sondrel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.6 71/73] dmaengine: dmatest: Fix process hang when reading wait parameter
Date:   Mon,  4 May 2020 19:58:14 +0200
Message-Id: <20200504165510.510085799@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit aa72f1d20ee973d68f26d46fce5e1cf6f9b7e1ca upstream.

If we do

  % echo 1 > /sys/module/dmatest/parameters/run
  [  115.851124] dmatest: Could not start test, no channels configured

  % echo dma8chan7 > /sys/module/dmatest/parameters/channel
  [  127.563872] dmatest: Added 1 threads using dma8chan7

  % cat /sys/module/dmatest/parameters/wait
  ... !!! HANG !!! ...

The culprit is the commit 6138f967bccc

  ("dmaengine: dmatest: Use fixed point div to calculate iops")

which makes threads not to run, but pending and being kicked off by writing
to the 'run' node. However, it forgot to consider 'wait' routine to avoid
above mentioned case.

In order to fix this, check for really running threads, i.e. with pending
and done flags unset.

It's pity the culprit commit hadn't updated documentation and tested all
possible scenarios.

Fixes: 6138f967bccc ("dmaengine: dmatest: Use fixed point div to calculate iops")
Cc: Seraj Alijan <seraj.alijan@sondrel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200428113518.70620-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmatest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -240,7 +240,7 @@ static bool is_threaded_test_run(struct
 		struct dmatest_thread *thread;
 
 		list_for_each_entry(thread, &dtc->threads, node) {
-			if (!thread->done)
+			if (!thread->done && !thread->pending)
 				return true;
 		}
 	}


