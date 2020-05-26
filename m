Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0751E2CC7
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391180AbgEZTR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404049AbgEZTOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C610F20776;
        Tue, 26 May 2020 19:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520473;
        bh=GhCaJpooWSavZpBdhK6aphQyLv9d4skXugYJfXJu21A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZugkH7W1Pi+D0FYBhsTi/W1r3qLem3WapDoPclmUV1H/bZm6RVVz/dHzIdkyjx6H3
         qPUBw5CPL3d2R+60VrxdJ/oh3mZMEs1tqhKXVnPqMdPOq9vedtB/yX3LrrcANjKkYl
         WKzZhKVgWcY+nPZJ39cu+zvSXOEbKJkwYLwpSrCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oscar Carter <oscar.carter@gmx.com>
Subject: [PATCH 5.6 093/126] staging: greybus: Fix uninitialized scalar variable
Date:   Tue, 26 May 2020 20:53:50 +0200
Message-Id: <20200526183945.702273669@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Carter <oscar.carter@gmx.com>

commit 34625c1931f8204c234c532b446b9f53c69f4b68 upstream.

In the "gb_tty_set_termios" function the "newline" variable is declared
but not initialized. So the "flow_control" member is not initialized and
the OR / AND operations with itself results in an undefined value in
this member.

The purpose of the code is to set the flow control type, so remove the
OR / AND self operator and set the value directly.

Addresses-Coverity-ID: 1374016 ("Uninitialized scalar variable")
Fixes: e55c25206d5c9 ("greybus: uart: Handle CRTSCTS flag in termios")
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200510101426.23631-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/greybus/uart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -537,9 +537,9 @@ static void gb_tty_set_termios(struct tt
 	}
 
 	if (C_CRTSCTS(tty) && C_BAUD(tty) != B0)
-		newline.flow_control |= GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = GB_SERIAL_AUTO_RTSCTS_EN;
 	else
-		newline.flow_control &= ~GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = 0;
 
 	if (memcmp(&gb_tty->line_coding, &newline, sizeof(newline))) {
 		memcpy(&gb_tty->line_coding, &newline, sizeof(newline));


