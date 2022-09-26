Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C5A5EA26D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiIZLHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbiIZLG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:06:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11F950069;
        Mon, 26 Sep 2022 03:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B471B8094D;
        Mon, 26 Sep 2022 10:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61620C433C1;
        Mon, 26 Sep 2022 10:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188347;
        bh=xLv6Yp4tyzE+V2Ro4LgR0kyqrrBkxn5bGkLAx5w9QAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlWNq8ttzuDRtFbrOSQIGJI680WmUuHMPTm3IxkXjg7+Tmfibm0ANYtxwQoZLt1Fa
         2Mxhs+zwlcSi2r00jkQzj+UC1PDF82PTuJpIxrpy5+mNKdUkxMw/m9Z2RBWhQv2wLC
         QYX6ZYrAxb6y9gaAqlGOt4yy9Y4mnGuw8MwyAO9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 119/141] serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting
Date:   Mon, 26 Sep 2022 12:12:25 +0200
Message-Id: <20220926100758.772218866@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 1d10cd4da593bc0196a239dcc54dac24b6b0a74e upstream.

Tx'ing does not correctly account Tx'ed characters into icount.tx.
Using uart_xmit_advance() fixes the problem.

Fixes: 2d908b38d409 ("serial: Add Tegra Combined UART driver")
Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220901143934.8850-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/tegra-tcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/tegra-tcu.c
+++ b/drivers/tty/serial/tegra-tcu.c
@@ -101,7 +101,7 @@ static void tegra_tcu_uart_start_tx(stru
 			break;
 
 		tegra_tcu_write(tcu, &xmit->buf[xmit->tail], count);
-		xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+		uart_xmit_advance(port, count);
 	}
 
 	uart_write_wakeup(port);


