Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AC550598F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiDROUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344649AbiDROSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:18:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FAA4AE06;
        Mon, 18 Apr 2022 06:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1CD0B80ED9;
        Mon, 18 Apr 2022 13:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E179EC385A1;
        Mon, 18 Apr 2022 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287641;
        bh=qt6zVlScKlgp/UWRwAPjnLop5XpVwyg8xY7P3/aVvDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnJ+57sQLw9TTWi6ZLCIS85lyH4woaMMUSSsAu275DVhtNex7QseKDJS4tubirERM
         WhEGz4EURSL58aVLHg2l0LOCbS64XjPUHbwu/eghY5IOS/gMJWwVqdeGmPSwOp6Ont
         jO9HxVYZtSbAOkVmLdgfE6rIjrfdOgCTWgJdEOLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Sven Peter <sven@svenpeter.dev>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.9 217/218] i2c: pasemi: Wait for write xfers to finish
Date:   Mon, 18 Apr 2022 14:14:43 +0200
Message-Id: <20220418121208.591340114@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

commit bd8963e602c77adc76dbbbfc3417c3cf14fed76b upstream.

Wait for completion of write transfers before returning from the driver.
At first sight it may seem advantageous to leave write transfers queued
for the controller to carry out on its own time, but there's a couple of
issues with it:

 * Driver doesn't check for FIFO space.

 * The queued writes can complete while the driver is in its I2C read
   transfer path which means it will get confused by the raising of
   XEN (the 'transaction ended' signal). This can cause a spurious
   ENODATA error due to premature reading of the MRXFIFO register.

Adding the wait fixes some unreliability issues with the driver. There's
some efficiency cost to it (especially with pasemi_smb_waitready doing
its polling), but that will be alleviated once the driver receives
interrupt support.

Fixes: beb58aa39e6e ("i2c: PA Semi SMBus driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-pasemi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -145,6 +145,12 @@ static int pasemi_i2c_xfer_msg(struct i2
 
 		TXFIFO_WR(smbus, msg->buf[msg->len-1] |
 			  (stop ? MTXFIFO_STOP : 0));
+
+		if (stop) {
+			err = pasemi_smb_waitready(smbus);
+			if (err)
+				goto reset_out;
+		}
 	}
 
 	return 0;


