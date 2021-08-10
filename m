Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355573E8142
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhHJR5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237848AbhHJRzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1595B610F7;
        Tue, 10 Aug 2021 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617480;
        bh=q0c/HAEw4TuA8hj9e5JKp07Q0ukq9lXTP7eTX7pVdfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejlGBhiimtFF8EQYfEoqapV0MCIkvNRdwucwhSp8OR2Y7xkQbSq8ycYqvGm+hoFB1
         U0bQUmkhoNO/YD9/9H9yIW+bL7oOgg+JIlU0Abl2gm+SGqMr3kIuuwnW0w0cRFAgqB
         5DU2WUoKYMsciV+gwbgqpr5CcsJWDBKJ3+0K97DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 078/175] USB: serial: pl2303: fix GT type detection
Date:   Tue, 10 Aug 2021 19:29:46 +0200
Message-Id: <20210810173003.507377531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3212a99349cee5fb611d3ffcf0e65bc3cd6dcf2f upstream.

At least some PL2303GT have a bcdDevice of 0x305 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Reported-by: Vasily Khoruzhick <anarsoul@gmail.com>
Tested-by: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: stable@vger.kernel.org	# 5.13
Link: https://lore.kernel.org/r/20210804093100.24811-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -432,6 +432,7 @@ static int pl2303_detect_type(struct usb
 	case 0x200:
 		switch (bcdDevice) {
 		case 0x100:
+		case 0x305:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.


