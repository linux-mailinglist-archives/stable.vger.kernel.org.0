Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C362550532A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbiDRMzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiDRMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8417655;
        Mon, 18 Apr 2022 05:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CF69B80EC4;
        Mon, 18 Apr 2022 12:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B9FC385A1;
        Mon, 18 Apr 2022 12:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285384;
        bh=X0t+T/PV6H7afRr7VxLAQykE69EkNrL4/q4ZlSkuoE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec5LpsY0Y4eCY89WvJb9JgOIj/XnKZhuxUDmSO3+LSO7UmbWR5ZQx1AnXDCz0djek
         vHzdLZrbMT+cmRhnWKqn2E1sm+/aE9qkpL91Opj8+tdyj98/Musg7cb3EyJ/R9Ro9u
         2meltaV4Q1xoqDUfSIVct7V2m3Xmg7/CLi9d52+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Sven Peter <sven@svenpeter.dev>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 173/189] i2c: pasemi: Wait for write xfers to finish
Date:   Mon, 18 Apr 2022 14:13:13 +0200
Message-Id: <20220418121207.732245569@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
@@ -137,6 +137,12 @@ static int pasemi_i2c_xfer_msg(struct i2
 
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


