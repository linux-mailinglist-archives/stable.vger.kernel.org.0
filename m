Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E849D24A6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387771AbfJJItE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389731AbfJJItE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9BA208C3;
        Thu, 10 Oct 2019 08:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697343;
        bh=frxZ1c0Yl11YuZfJJQl+IVKGf+OQqwOKfjhdN+46TS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdjJdHtFgHV5EBT65PQn4ZfXAYBJfMr70ggv2r5rLEcZTbFUjL+MnBQdzJFkN7riQ
         bDkEYpLys5JCI8/o72nDKz3AojTouBIgQRFyjK9HgUE4KrM97BsUT+q6kpYXHncRBR
         P5rt5geeo+iya06CCDRzp6tIZg1we2bv6RlZi2Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 107/114] coresight: etm4x: Use explicit barriers on enable/disable
Date:   Thu, 10 Oct 2019 10:36:54 +0200
Message-Id: <20191010083613.897582109@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

commit 1004ce4c255fc3eb3ad9145ddd53547d1b7ce327 upstream.

Synchronization is recommended before disabling the trace registers
to prevent any start or stop points being speculative at the point
of disabling the unit (section 7.3.77 of ARM IHI 0064D).

Synchronization is also recommended after programming the trace
registers to ensure all updates are committed prior to normal code
resuming (section 4.3.7 of ARM IHI 0064D).

Let's ensure these syncronization points are present in the code
and clearly commented.

Note that we could rely on the barriers in CS_LOCK and
coresight_disclaim_device_unlocked or the context switch to user
space - however coresight may be of use in the kernel.

On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
only used on armv8 let's directly use dsb(sy) instead of mb(). This
removes some ambiguity and makes it easier to correlate the code with
the TRM.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Fixed capital letter for "use" in title]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190829202842.580-11-mathieu.poirier@linaro.org
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -174,6 +174,12 @@ static void etm4_enable_hw(void *info)
 	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 0))
 		dev_err(drvdata->dev,
 			"timeout while waiting for Idle Trace Status\n");
+	/*
+	 * As recommended by section 4.3.7 ("Synchronization when using the
+	 * memory-mapped interface") of ARM IHI 0064D
+	 */
+	dsb(sy);
+	isb();
 
 	CS_LOCK(drvdata->base);
 
@@ -324,8 +330,12 @@ static void etm4_disable_hw(void *info)
 	/* EN, bit[0] Trace unit enable bit */
 	control &= ~0x1;
 
-	/* make sure everything completes before disabling */
-	mb();
+	/*
+	 * Make sure everything completes before disabling, as recommended
+	 * by section 7.3.77 ("TRCVICTLR, ViewInst Main Control Register,
+	 * SSTATUS") of ARM IHI 0064D
+	 */
+	dsb(sy);
 	isb();
 	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
 


