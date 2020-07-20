Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF7226641
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbgGTQBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732023AbgGTQBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F79320672;
        Mon, 20 Jul 2020 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260897;
        bh=yOzak47EJ9Fo5F4o+e8MA+hzD4MsUtU/5HybLtvGEXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYbE5UeFM9cJwD9kOFSqkV9ITDdOYhiEpsdPpyoMw7P6ZLLKB2Q+EFS/a6h0d+uBz
         AeZkGoTBCD+zg5hsISTO742qrznckt6oI78BUjs6462BXN3S9HRD2bMr10Ms2WmKdu
         l4QSeXCTkJPIogCWm/xPSgzukH3UThiV6JecVspY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/215] dmaengine: dmatest: stop completed threads when running without set channel
Date:   Mon, 20 Jul 2020 17:36:26 +0200
Message-Id: <20200720152825.156428904@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit fd17d1abce426b4224a916a242b57be94272771b ]

The completed threads were not cleared and consequent run would result
threads accumulating:

echo 800000 > /sys/module/dmatest/parameters/test_buf_size
echo 2000 > /sys/module/dmatest/parameters/timeout
echo 50 > /sys/module/dmatest/parameters/iterations
echo 1 > /sys/module/dmatest/parameters/max_channels
echo "" > /sys/module/dmatest/parameters/channel
[  237.507265] dmatest: Added 1 threads using dma1chan2
echo 1 > /sys/module/dmatest/parameters/run
[  244.713360] dmatest: Started 1 threads using dma1chan2
[  246.117680] dmatest: dma1chan2-copy0: summary 50 tests, 0 failures 2437.47 iops 977623 KB/s (0)

echo 1 > /sys/module/dmatest/parameters/run
[  292.381471] dmatest: No channels configured, continue with any
[  292.389307] dmatest: Added 1 threads using dma1chan3
[  292.394302] dmatest: Started 1 threads using dma1chan2
[  292.399454] dmatest: Started 1 threads using dma1chan3
[  293.800835] dmatest: dma1chan3-copy0: summary 50 tests, 0 failures 2624.53 iops 975014 KB/s (0)

echo 1 > /sys/module/dmatest/parameters/run
[  307.301429] dmatest: No channels configured, continue with any
[  307.309212] dmatest: Added 1 threads using dma1chan4
[  307.314197] dmatest: Started 1 threads using dma1chan2
[  307.319343] dmatest: Started 1 threads using dma1chan3
[  307.324492] dmatest: Started 1 threads using dma1chan4
[  308.730773] dmatest: dma1chan4-copy0: summary 50 tests, 0 failures 2390.28 iops 965436 KB/s (0)

Fixes: 6b41030fdc79 ("dmaengine: dmatest: Restore default for channel")
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200701101225.8607-1-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 0425984db118a..62d9825a49e9d 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -1168,6 +1168,8 @@ static int dmatest_run_set(const char *val, const struct kernel_param *kp)
 	} else if (dmatest_run) {
 		if (!is_threaded_test_pending(info)) {
 			pr_info("No channels configured, continue with any\n");
+			if (!is_threaded_test_run(info))
+				stop_threaded_test(info);
 			add_threaded_test(info);
 		}
 		start_threaded_tests(info);
-- 
2.25.1



