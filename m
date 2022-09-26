Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA125E9EEE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiIZKQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiIZKQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE085D60;
        Mon, 26 Sep 2022 03:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC3E360BFE;
        Mon, 26 Sep 2022 10:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE96C433C1;
        Mon, 26 Sep 2022 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187275;
        bh=xBg2Hq0C3rG0zEu7USGpFCsDrTdc0HhUCOa8/YfH7fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DI2uMK7FPUv/TpNc5b/qk3KzQIyPH2C7sdGURC12s+RzGldYwaH41hZarKUGRRSsr
         7k8KxUnasKMVxwFvY3m3VD2qUB1ffm/pY4GSPws7m/s4AsCPZiFY/Z5c+2oN7lTa5T
         vDXTN5P3Uu8TLbg3xHFUi1icp+rQKUc1nlgYszkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.9 26/30] serial: Create uart_xmit_advance()
Date:   Mon, 26 Sep 2022 12:11:57 +0200
Message-Id: <20220926100737.078991410@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
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

commit e77cab77f2cb3a1ca2ba8df4af45bb35617ac16d upstream.

A very common pattern in the drivers is to advance xmit tail
index and do bookkeeping of Tx'ed characters. Create
uart_xmit_advance() to handle it.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220901143934.8850-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -294,6 +294,23 @@ struct uart_state {
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS		256
 
+/**
+ * uart_xmit_advance - Advance xmit buffer and account Tx'ed chars
+ * @up: uart_port structure describing the port
+ * @chars: number of characters sent
+ *
+ * This function advances the tail of circular xmit buffer by the number of
+ * @chars transmitted and handles accounting of transmitted bytes (into
+ * @up's icount.tx).
+ */
+static inline void uart_xmit_advance(struct uart_port *up, unsigned int chars)
+{
+	struct circ_buf *xmit = &up->state->xmit;
+
+	xmit->tail = (xmit->tail + chars) & (UART_XMIT_SIZE - 1);
+	up->icount.tx += chars;
+}
+
 struct module;
 struct tty_driver;
 


