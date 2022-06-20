Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C492C551268
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiFTIRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiFTIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE0211839
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED25B80EF9
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2D9C341C4;
        Mon, 20 Jun 2022 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655713060;
        bh=eDrv8P/ncoqX+JalUKP3OC9D9aB6z1QXPCp6+uPQ+3s=;
        h=Subject:To:Cc:From:Date:From;
        b=pUyv3s+wmL68ZotpbXUUTyuYxRu1D38YC4rlck6WPTT1uQU2ohYkSeU6W3bkn/09g
         a0VUThX/PsNiPK3WbhvygL9IHUwiXQXTLbYNANpRa9+c2VH2rhEa0S/guXjSHGcJPk
         7E0oH1WIL4OvU8PoUMhtXrdvPg0+TUkpSt9JL73M=
Subject: FAILED: patch "[PATCH] serial: 8250: Store to lsr_save_flags after lsr read" failed to apply to 4.9-stable tree
To:     ilpo.jarvinen@linux.intel.com, gregkh@linuxfoundation.org,
        stable@kernel.org, u.kleine-koenig@pengutronix.de,
        u.kleine-koenig@penugtronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 10:17:19 +0200
Message-ID: <1655713039290@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be03b0651ffd8bab69dfd574c6818b446c0753ce Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 20 May 2022 13:35:41 +0300
Subject: [PATCH] serial: 8250: Store to lsr_save_flags after lsr read
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 78b6dedc43e6..8f32fe9e149e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1517,6 +1517,8 @@ static inline void __stop_tx(struct uart_8250_port *p)
 		unsigned char lsr = serial_in(p, UART_LSR);
 		u64 stop_delay = 0;
 
+		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		if (!(lsr & UART_LSR_THRE))
 			return;
 		/*

