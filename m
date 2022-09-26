Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA335EA27D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiIZLJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiIZLHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8475FAFB;
        Mon, 26 Sep 2022 03:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF49560B4A;
        Mon, 26 Sep 2022 10:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00607C433C1;
        Mon, 26 Sep 2022 10:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188341;
        bh=yPR+aSuoNrFsZhZZCkn3ZC1acLKJnWnud/6ONVX08PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndoXNgMJlnOP8+DWx29JWnoowME3ermyJPn4LZfY5dkT1+nmh3ZQaXpO51bkdvP0w
         0NDfXA/uV9wHrl0oflxjCPOU8MBPJg+m0sFrawpA6IC2kSdSmrfdqNgWHyJ/2OXvoJ
         m5ZY9Bk5WOoSeWTQLC55vcZJj0N2R6qHMfKHTULY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 117/141] serial: Create uart_xmit_advance()
Date:   Mon, 26 Sep 2022 12:12:23 +0200
Message-Id: <20220926100758.688236534@linuxfoundation.org>
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
@@ -300,6 +300,23 @@ struct uart_state {
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
 


