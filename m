Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A744723D8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhLMJcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:32:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57418 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbhLMJcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:32:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF345CE0E29;
        Mon, 13 Dec 2021 09:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64840C00446;
        Mon, 13 Dec 2021 09:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387935;
        bh=PEW5JwRnVWEkYcLV4SbNhbgEEuIYDpogGayn3ZHK2N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvOz8efiype1yO8XqLRpOQS1OHmc+Ewc+H7o1VF+hVdk+7hN1r3oldjtw9zp/uhN5
         mDF1gv17X0p1Yi72TMViLXTSoJ+D+TBDcEUOiOXfMrcnDguQyFwyZcFTgHoaWXuYpC
         ng6qBU5+I+WG5mLfcg1r+o7po1co9IxSXVmzU9xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manjong Lee <mj0123.lee@samsung.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Changheun Lee <nanich.lee@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        yt0928.kim@samsung.com, junho89.kim@samsung.com,
        jisoo2146.oh@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 10/37] mm: bdi: initialize bdi_min_ratio when bdi is unregistered
Date:   Mon, 13 Dec 2021 10:29:48 +0100
Message-Id: <20211213092925.708148558@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manjong Lee <mj0123.lee@samsung.com>

commit 3c376dfafbf7a8ea0dea212d095ddd83e93280bb upstream.

Initialize min_ratio if it is set during bdi unregistration.  This can
prevent problems that may occur a when bdi is removed without resetting
min_ratio.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -865,6 +865,13 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_destroy(bdi);
 
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


