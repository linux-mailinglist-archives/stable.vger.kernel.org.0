Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9A55824C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiFWRNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiFWRMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B8BFD05;
        Thu, 23 Jun 2022 09:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9111DB8248E;
        Thu, 23 Jun 2022 16:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD755C3411B;
        Thu, 23 Jun 2022 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003464;
        bh=rW2A7M2wuxdFnMhX+Kj00UA5HOVX4KyhnVeeGNXZJmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQOz61ZYJXu+sRJ0tn7TxrB8C3DkxCQkadvRqWDC5lHunZ3VCfpIaQEqzeYBGNtDd
         W+tVkxZv9KX/tmpPC05pMBl5CKEjgylFxqOTFb9b3vRz/4fGPG81yMQwO/VoDZUTR+
         f5mPJs2qFJpoRtJpWGLSVuCRnzuUKEk0XGfDD2mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@penugtronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.9 246/264] serial: 8250: Store to lsr_save_flags after lsr read
Date:   Thu, 23 Jun 2022 18:43:59 +0200
Message-Id: <20220623164351.031233124@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit be03b0651ffd8bab69dfd574c6818b446c0753ce upstream.

Not all LSR register flags are preserved across reads. Therefore, LSR
readers must store the non-preserved bits into lsr_save_flags.

This fix was initially mixed into feature commit f6f586102add ("serial:
8250: Handle UART without interrupt on TEMT using em485"). However,
that feature change had a flaw and it was reverted to make room for
simpler approach providing the same feature. The embedded fix got
reverted with the feature change.

Re-add the lsr_save_flags fix and properly mark it's a fix.

Link: https://lore.kernel.org/all/1d6c31d-d194-9e6a-ddf9-5f29af829f3@linux.intel.com/T/#m1737eef986bd20cf19593e344cebd7b0244945fc
Fixes: e490c9144cfa ("tty: Add software emulated RS485 support for 8250")
Cc: stable <stable@kernel.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@penugtronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/f4d774be-1437-a550-8334-19d8722ab98c@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1473,6 +1473,8 @@ static inline void __stop_tx(struct uart
 
 	if (em485) {
 		unsigned char lsr = serial_in(p, UART_LSR);
+		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		/*
 		 * To provide required timeing and allow FIFO transfer,
 		 * __stop_tx_rs485() must be called only when both FIFO and


