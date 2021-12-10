Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD30A470E36
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 23:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbhLJWuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 17:50:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57454 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344934AbhLJWuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 17:50:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97AC8CE2D8E;
        Fri, 10 Dec 2021 22:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AB7C341C8;
        Fri, 10 Dec 2021 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176432;
        bh=d2MtOu+m2tsl2wKYkPsdG7dDlrmKCsZx/QeAMFAPQW8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BFnypslsZzIqgnvX3BgWS+MdXDJFCHWn2csm6ZjBHW8kZnBqishXBmr+U02yE2OM7
         Wn85SUkwcUzlaoRNOqBCmrLtvKgNeJbI2LY4ppNX1fsRcjhpkcL8ml/GpvFymV2StM
         QZ4+FL1hJHAItta1/aKhs/X0LyJaRxPJA/9Uuuu4=
Date:   Fri, 10 Dec 2021 14:47:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        linux-mm@kvack.org, mj0123.lee@samsung.com,
        mm-commits@vger.kernel.org, nanich.lee@samsung.com,
        peterz@infradead.org, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        yt0928.kim@samsung.com
Subject:  [patch 21/21] mm: bdi: initialize bdi_min_ratio when bdi
 is unregistered
Message-ID: <20211210224711.NY_S5okYu%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manjong Lee <mj0123.lee@samsung.com>
Subject: mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Initialize min_ratio if it is set during bdi unregistration.
This can prevent problems that may occur a when bdi is removed without
resetting min_ratio.

For example.
1) insert external sdcard
2) set external sdcard's min_ratio 70
3) remove external sdcard without setting min_ratio 0
4) insert external sdcard
5) set external sdcard's min_ratio 70 << error occur(can't set)

Because when an sdcard is removed, the present bdi_min_ratio value will
remain.  Currently, the only way to reset bdi_min_ratio is to reboot.

[akpm@linux-foundation.org: tweak comment and coding style]
Link: https://lkml.kernel.org/r/20211021161942.5983-1-mj0123.lee@samsung.com
Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Changheun Lee <nanich.lee@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <seunghwan.hyun@samsung.com>
Cc: <sookwan7.kim@samsung.com>
Cc: <yt0928.kim@samsung.com>
Cc: <junho89.kim@samsung.com>
Cc: <jisoo2146.oh@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/backing-dev.c~mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister
+++ a/mm/backing-dev.c
@@ -945,6 +945,13 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio.
+	 */
+	if (bdi->min_ratio)
+		bdi_set_min_ratio(bdi, 0);
+
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
_
