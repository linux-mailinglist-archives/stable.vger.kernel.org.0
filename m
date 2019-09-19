Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CFFB85E4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405136AbfISWXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394154AbfISWXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:23:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E215021D71;
        Thu, 19 Sep 2019 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931786;
        bh=gP1KFasB8WO5aIgzqJHmO5K+ABZ0LA7tXlnu06A8+bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOO84z3xbFDdBWTtbWRzpJfKWdK2dHtMxjtVZGWXvVrC7YmWbVzlYFMWyjxL4tZGI
         Vhv0v25hY493pLIjtHpzRYijOkppTRpbu7gEL2JQu2bSe5gE4eqEikpeMOXgF3jiw6
         7984AMewRoaOS3hpU5lyvJiBc4923+DqbvSbUZa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH 4.4 32/56] serial: sprd: correct the wrong sequence of arguments
Date:   Fri, 20 Sep 2019 00:04:13 +0200
Message-Id: <20190919214757.410786172@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

commit 9c801e313195addaf11c16e155f50789d6ebfd19 upstream.

The sequence of arguments which was passed to handle_lsr_errors() didn't
match the parameters defined in that function, &lsr was passed to flag
and &flag was passed to lsr, this patch fixed that.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190905074151.5268-1-zhang.lyra@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sprd_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -240,7 +240,7 @@ static inline void sprd_rx(struct uart_p
 
 		if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE |
 			SPRD_LSR_FE | SPRD_LSR_OE))
-			if (handle_lsr_errors(port, &lsr, &flag))
+			if (handle_lsr_errors(port, &flag, &lsr))
 				continue;
 		if (uart_handle_sysrq_char(port, ch))
 			continue;


