Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628CD521924
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbiEJNmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbiEJNkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:40:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B901298385;
        Tue, 10 May 2022 06:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7F6B81DA8;
        Tue, 10 May 2022 13:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49726C385A6;
        Tue, 10 May 2022 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189377;
        bh=bdlir941cJPdvV0WLmjHhFND7q7Dk2ei9JvxwOveNsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sanN1lH8V0rI0MNjsUT016I5utjX1JkLTX7Ln+oArbaIyYHdN5LpMkkutT7eiZuKy
         sTkRBnxsDGQ8W8t8NebaAGQpICcLCSM59EZ13qWRZ2ENM2aaiLA6O86FCK28SU7MrQ
         03irU4shzZ06nSfCHGPyQRB4KTFwYbMfOoBVWiSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 030/135] s390/dasd: Fix read for ESE with blksize < 4k
Date:   Tue, 10 May 2022 15:06:52 +0200
Message-Id: <20220510130741.265942817@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

commit cd68c48ea15c85f1577a442dc4c285e112ff1b37 upstream.

When reading unformatted tracks on ESE devices, the corresponding memory
areas are simply set to zero for each segment. This is done incorrectly
for blocksizes < 4096.

There are two problems. First, the increment of dst is done using the
counter of the loop (off), which is increased by blksize every
iteration. This leads to a much bigger increment for dst as actually
intended. Second, the increment of dst is done before the memory area
is set to 0, skipping a significant amount of bytes of memory.

This leads to illegal overwriting of memory and ultimately to a kernel
panic.

This is not a problem with 4k blocksize because
blk_queue_max_segment_size is set to PAGE_SIZE, always resulting in a
single iteration for the inner segment loop (bv.bv_len == blksize). The
incorrectly used 'off' value to increment dst is 0 and the correct
memory area is used.

In order to fix this for blksize < 4k, increment dst correctly using the
blksize and only do it at the end of the loop.

Fixes: 5e2b17e712cf ("s390/dasd: Add dynamic formatting support for ESE volumes")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20220505141733.1989450-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3297,12 +3297,11 @@ static int dasd_eckd_ese_read(struct das
 				cqr->proc_bytes = blk_count * blksize;
 				return 0;
 			}
-			if (dst && !skip_block) {
-				dst += off;
+			if (dst && !skip_block)
 				memset(dst, 0, blksize);
-			} else {
+			else
 				skip_block--;
-			}
+			dst += blksize;
 			blk_count++;
 		}
 	}


