Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2050431369B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhBHPNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhBHPKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC01A64E87;
        Mon,  8 Feb 2021 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796854;
        bh=xreMSYQFGwd+0WnAYSHYKeoO+6nLb7sQx5ybv7JJe/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRKApsoJHPKJn4pSbUI/8SSccNRq7IQuvE1xdIbvsAwaZqbBSlj/ESbvLWvZMkPuv
         14u9V3hGu+vGbAGHNLsPeTK73AXUB4kqc8xU6y8DyALmRzCvVKs7CJsqevbR6HtT98
         Xw/xoVaEJ4zZB8Xt19zYY/qx43KASxevCPnKGD38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tho Vu <tho.vu.wh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.19 13/38] usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()
Date:   Mon,  8 Feb 2021 16:01:00 +0100
Message-Id: <20210208145806.663348705@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 9917f0e3cdba7b9f1a23f70e3f70b1a106be54a8 upstream.

Should clear the pipe running flag in usbhs_pkt_pop(). Otherwise,
we cannot use this pipe after dequeue was called while the pipe was
running.

Fixes: 8355b2b3082d ("usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle")
Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1612183640-8898-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/fifo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -126,6 +126,7 @@ struct usbhs_pkt *usbhs_pkt_pop(struct u
 		}
 
 		usbhs_pipe_clear_without_sequence(pipe, 0, 0);
+		usbhs_pipe_running(pipe, 0);
 
 		__usbhsf_pkt_del(pkt);
 	}


