Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F01A52184A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242006AbiEJNeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243844AbiEJNcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD502D2E3F;
        Tue, 10 May 2022 06:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61A30CE1EED;
        Tue, 10 May 2022 13:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E3C385C2;
        Tue, 10 May 2022 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188953;
        bh=2mI/zjP+CAsjMl5kh45R2T1s5t3QVcMCqLJriNcVJ8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSVJWKtMJlidNMN+Z5oMC+h0uPzt5bRBAA5mT+vPIq/kxuET6TxHj9texg6yhPJJA
         4QijNiSp5Vh2U+Ih0ND+aMptvrRwsecGpezfuBiMv76TNS0GR+vGAv1sr+xtNawRBV
         G3Ah+qDmHUxy6juR/zBFG1LOo7gZynaIZvyQN2a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 16/52] s390/dasd: Fix read for ESE with blksize < 4k
Date:   Tue, 10 May 2022 15:07:45 +0200
Message-Id: <20220510130730.332743043@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
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
@@ -3228,12 +3228,11 @@ static int dasd_eckd_ese_read(struct das
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


