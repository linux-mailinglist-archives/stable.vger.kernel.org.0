Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E140D1C8E8E
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgEGO2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgEGO2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3FDE20936;
        Thu,  7 May 2020 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861685;
        bh=b1s7I7MQRORTqaB8/KOfE25r43ZKqozH8LCVeScbEHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5J0jykQaT6xmLnZIHfqVaIpyDmB9ThbHV10MDtAAPLU4GfM9VuNuOWHqZ/QRFZt8
         amh1AGwF0oGfKrEVFxQyNPHuLKokDmUYx96UyeCP8aU7kGP8MNf7SPQK2/mBNJVTVm
         ex1RfDPEt0Mms69gWGxC1edNq6hPW/U/kYhQF2So=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Seraj Alijan <seraj.alijan@sondrel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 31/50] dmaengine: dmatest: Fix process hang when reading 'wait' parameter
Date:   Thu,  7 May 2020 10:27:07 -0400
Message-Id: <20200507142726.25751-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit aa72f1d20ee973d68f26d46fce5e1cf6f9b7e1ca ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 4993e3e5c5b01..364dd34799d45 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -240,7 +240,7 @@ static bool is_threaded_test_run(struct dmatest_info *info)
 		struct dmatest_thread *thread;
 
 		list_for_each_entry(thread, &dtc->threads, node) {
-			if (!thread->done)
+			if (!thread->done && !thread->pending)
 				return true;
 		}
 	}
-- 
2.20.1

