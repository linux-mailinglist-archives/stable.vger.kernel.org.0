Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4D2E1E03
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgLWPeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgLWPeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B920423370;
        Wed, 23 Dec 2020 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737582;
        bh=RiEJGmvqO4OuLaNqfBxsJGXrbPh5AhWfNVWAHGOaYQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm1mJICyoB9EwA3LWABFODpouj9JaNLUZtLkjV/yLWke/gd5X++F+wIitRyhzRvnI
         pCN4qMmegFeqccrBTDX8DYQXHEOrhHrmhthZNVDOiSPMR/Bk/fRlyaCSyOglohEYw4
         2BbDke8OjjU7/prcRrK4VCIQntg9OWoA5K2r/QIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Al Grant <al.grant@arm.com>, Mike Leach <mike.leach@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 17/40] coresight: tmc-etr: Fix barrier packet insertion for perf buffer
Date:   Wed, 23 Dec 2020 16:33:18 +0100
Message-Id: <20201223150516.385258340@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 83be0b84fe846edf0c722fefe225482d5f0d7395 upstream.

When the ETR is used in perf mode with a larger buffer (configured
via sysfs or the default size of 1M) than the perf aux buffer size,
we end up inserting the barrier packet at the wrong offset, while
moving the offset forward. i.e, instead of the "new moved offset",
we insert it at the current hardware buffer offset. These packets
will not be visible as they are never copied and could lead to
corruption in the trace decoding side, as the decoder is not aware
that it needs to reset the decoding.

Fixes: ec13c78d7b45 ("coresight: tmc-etr: Add barrier packets when moving offset forward")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable@vger.kernel.org
Reported-by: Al Grant <al.grant@arm.com>
Tested-by: Mike Leach <mike.leach@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201208182651.1597945-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-tmc-etr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1552,7 +1552,7 @@ tmc_update_etr_buffer(struct coresight_d
 
 	/* Insert barrier packets at the beginning, if there was an overflow */
 	if (lost)
-		tmc_etr_buf_insert_barrier_packet(etr_buf, etr_buf->offset);
+		tmc_etr_buf_insert_barrier_packet(etr_buf, offset);
 	tmc_etr_sync_perf_buffer(etr_perf, offset, size);
 
 	/*


