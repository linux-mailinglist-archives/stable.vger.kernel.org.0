Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B9531378C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhBHP1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhBHPV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:21:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A4064EF7;
        Mon,  8 Feb 2021 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797214;
        bh=xreMSYQFGwd+0WnAYSHYKeoO+6nLb7sQx5ybv7JJe/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6QGLIdutf90kRBjCl0NufFd2t8uF4Mp+StqoHYxMn8B6HrUnQiI+ldyfx+s5ByKa
         vT4wfUb+krrO7cijGPlg/5mDLdjrw0FiuekqbPC7mSGtJSQbEcv1j+vxcy+tqEcgUg
         QQMODc59UO26HTN0ZkWJlInzcfmoQys9RP1sW43o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tho Vu <tho.vu.wh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.10 008/120] usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()
Date:   Mon,  8 Feb 2021 15:59:55 +0100
Message-Id: <20210208145818.729911082@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
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


