Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92599440D6F
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 08:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJaH2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 03:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhJaH2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Oct 2021 03:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE61760E9B;
        Sun, 31 Oct 2021 07:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635665149;
        bh=lXejF/D/VE1VrGMGZtilBcExgjtasXkyNPeUicpawmo=;
        h=Subject:To:From:Date:From;
        b=P+5NYH560E1hiYC3CtzE7vPaM0W36G5PZ7mdOoHG8SSkh2fMmHu+0QNOz+EMSdP4/
         2Mc8jbUH53142sW5BAkBZsr72AVY2ZcB4mb7gVMNeIc+nnUIA7XPqO2gWR+8lWzIPD
         XXdRyQrqTYRj7/uBrM/BWpN4Kjuae0hGvI6j7mWE=
Subject: patch "coresight: trbe: Fix incorrect access of the sink specific data" added to char-misc-next
To:     suzuki.poulose@arm.com, anshuman.khandual@arm.com,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Oct 2021 08:24:46 +0100
Message-ID: <1635665086580@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


