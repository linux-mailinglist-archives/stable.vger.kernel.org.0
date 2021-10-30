Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5ED44080B
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhJ3Iw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 04:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhJ3Iw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 04:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 933A960FF2;
        Sat, 30 Oct 2021 08:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635583798;
        bh=eQPnOunLDB7Guqa43Q7H5SYevdh5gmNlhu0mxnIQuAI=;
        h=Subject:To:From:Date:From;
        b=Ze6XS/2Df0/hOpBDu9V1Yn5GuwjlxEHc1rkNnk0/Qf5uy6ICAuIMnzCqlajX0yFva
         yHB0MAYYpeM6ZFUzmZgD5l6KDR/tDPGLefsIQ+kcb0tnLZLV6Ot8MT3QobjYuATGXq
         x8tD3mDOlW1V3fyqWWIzgK9rMaIZeWXwdx1jjdaE=
Subject: patch "coresight: trbe: Fix incorrect access of the sink specific data" added to char-misc-testing
To:     suzuki.poulose@arm.com, anshuman.khandual@arm.com,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 10:49:14 +0200
Message-ID: <1635583754120112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: trbe: Fix incorrect access of the sink specific data

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bb5293e334af51b19b62d8bef1852ea13e935e9b Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Tue, 21 Sep 2021 14:41:05 +0100
Subject: coresight: trbe: Fix incorrect access of the sink specific data

The TRBE driver wrongly treats the aux private data as the TRBE driver
specific buffer for a given perf handle, while it is the ETM PMU's
event specific data. Fix this by correcting the instance to use
appropriate helper.

Cc: stable <stable@vger.kernel.org>
Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210921134121.2423546-2-suzuki.poulose@arm.com
[Fixed 13 character SHA down to 12]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index a53ee98f312f..2825ccb0cf39 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -382,7 +382,7 @@ static unsigned long __trbe_normal_offset(struct perf_output_handle *handle)
 
 static unsigned long trbe_normal_offset(struct perf_output_handle *handle)
 {
-	struct trbe_buf *buf = perf_get_aux(handle);
+	struct trbe_buf *buf = etm_perf_sink_config(handle);
 	u64 limit = __trbe_normal_offset(handle);
 	u64 head = PERF_IDX2OFF(handle->head, buf);
 
-- 
2.33.1


