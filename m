Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1513E7E5B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhHJRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231465AbhHJRce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D727360F13;
        Tue, 10 Aug 2021 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616732;
        bh=6aDcVA48kqfRMlXtJ3vMSq4cdUNQ0LF5woQJAJxunB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tp9htIiL7zIiQCYJUFTZ8NhJojbF4JHLvdqlrzfb4P90bBFdPFqaB6LXPW2RQGIQK
         cNLnMDt9GMhZUcJTaq1IscIZ0DBa7htuIdu5fTqOi+PTEDonAnIYWq3HAaw5VkSYrF
         7daL7fPaDHwWUbAFCOx3MQ+pp5eC4/2MiwWe4NhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 23/54] USB: serial: ch341: fix character loss at high transfer rates
Date:   Tue, 10 Aug 2021 19:30:17 +0200
Message-Id: <20210810172944.935001202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit 3c18e9baee0ef97510dcda78c82285f52626764b upstream.

The chip supports high transfer rates, but with the small default buffers
(64 bytes read), some entire blocks are regularly lost. This typically
happens at 1.5 Mbps (which is the default speed on Rockchip devices) when
used as a console to access U-Boot where the output of the "help" command
misses many lines and where "printenv" mangles the environment.

The FTDI driver doesn't suffer at all from this. One difference is that
it uses 512 bytes rx buffers and 256 bytes tx buffers. Adopting these
values completely resolved the issue, even the output of "dmesg" is
reliable. I preferred to leave the Tx value unchanged as it is not
involved in this issue, while a change could increase the risk of
triggering the same issue with other devices having too small buffers.

I verified that it backports well (and works) at least to 5.4. It's of
low importance enough to be dropped where it doesn't trivially apply
anymore.

Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20210724152739.18726-1-w@1wt.eu
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -625,6 +625,7 @@ static struct usb_serial_driver ch341_de
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
+	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,


