Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E0D361AB3
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 09:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhDPHfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 03:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239201AbhDPHfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 03:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F0D61153;
        Fri, 16 Apr 2021 07:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618558522;
        bh=rSdSr+aVnakUJQx4JpXSkQJM6IPzcGbhjLmD4ySaEVw=;
        h=Subject:To:From:Date:From;
        b=pdRdPF5cifAGErxCbXGJ5rQhK/ds97eZBgTFlM008oks5Rtj/4yA/sgmWWien6kNg
         fwsbdQ1/ZfIWTxfvMSAdhs3ACVq1lNsDgqcSn2i2vFO/DQ9uv0nA6j3/8oUSCTW/Th
         hd5wDfFIQnXMkQ2qU59MbBZq3xljFJqlh8RgzjmI=
Subject: patch "coresight: etm-perf: Fix define build issue when built as module" added to char-misc-testing
To:     mike.leach@linaro.org, gregkh@linuxfoundation.org,
        leo.yan@linaro.org, mathieu.poirier@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 09:35:19 +0200
Message-ID: <1618558519134251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: etm-perf: Fix define build issue when built as module

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9204ff94868496f2d9b8b173af52ec455160c364 Mon Sep 17 00:00:00 2001
From: Mike Leach <mike.leach@linaro.org>
Date: Thu, 15 Apr 2021 14:24:04 -0600
Subject: coresight: etm-perf: Fix define build issue when built as module

CONFIG_CORESIGHT_SOURCE_ETM4X is undefined when built as module,
CONFIG_CORESIGHT_SOURCE_ETM4X_MODULE is defined instead.

Therefore code in format_attr_contextid_show() not correctly complied
when coresight built as module.

Use IS_ENABLED(CONFIG_CORESIGHT_SOURCE_ETM4X) to correct this.

Link: https://lore.kernel.org/r/20210414194808.22872-1-mike.leach@linaro.org
Fixes: 88f11864cf1d ("coresight: etm-perf: Support PID tracing for kernel at EL2")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210415202404.945368-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index bdbb77334329..c1bec2ad3911 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -52,7 +52,7 @@ static ssize_t format_attr_contextid_show(struct device *dev,
 {
 	int pid_fmt = ETM_OPT_CTXTID;
 
-#if defined(CONFIG_CORESIGHT_SOURCE_ETM4X)
+#if IS_ENABLED(CONFIG_CORESIGHT_SOURCE_ETM4X)
 	pid_fmt = is_kernel_in_hyp_mode() ? ETM_OPT_CTXTID2 : ETM_OPT_CTXTID;
 #endif
 	return sprintf(page, "config:%d\n", pid_fmt);
-- 
2.31.1


