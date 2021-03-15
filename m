Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26B733B9EB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhCOOHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhCOOCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC8664E83;
        Mon, 15 Mar 2021 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816921;
        bh=I5/Ju2sqpmZF9GUUl8cG9iEELjgWoaYlwhzX40Zzz+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtbVm58qlo5v4PGxRQZYAsJxAJUDTrX96PIcvb9zHmk+H8Mxh8MkCUPWDymllmpMy
         1ANeCHYvaah4nubPxIMMWqc7FYTU2mfdMUFrvzr20lOepwt776oWtf6CmMjTw0V8fk
         4RCp6+HJ44nNJ+fK6d4jDbYbUJMHmfEKost1lVSk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.11 203/306] usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM
Date:   Mon, 15 Mar 2021 14:54:26 +0100
Message-Id: <20210315135514.497948719@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit b1d25e6ee57c2605845595b6c61340d734253eb3 upstream.

According to the datasheet, this controller has a restriction
which "set an endpoint number so that combinations of the DIR bit and
the EPNUM bits do not overlap.". However, since the udc core driver is
possible to assign a bulk pipe as an interrupt endpoint, an endpoint
number may not match the pipe number. After that, when user rebinds
another gadget driver, this driver broke the restriction because
the driver didn't clear any configuration in usb_ep_disable().

Example:
 # modprobe g_ncm
 Then, EP3 = pipe 3, EP4 = pipe 4, EP5 = pipe 6
 # rmmod g_ncm
 # modprobe g_hid
 Then, EP3 = pipe 6, EP4 = pipe 7.
 So, pipe 3 and pipe 6 are set as EP3.

So, clear PIPECFG register in usbhs_pipe_free().

Fixes: dfb87b8bfe09 ("usb: renesas_usbhs: gadget: fix re-enabling pipe without re-connecting")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1615168538-26101-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/pipe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -746,6 +746,8 @@ struct usbhs_pipe *usbhs_pipe_malloc(str
 
 void usbhs_pipe_free(struct usbhs_pipe *pipe)
 {
+	usbhsp_pipe_select(pipe);
+	usbhsp_pipe_cfg_set(pipe, 0xFFFF, 0);
 	usbhsp_put_pipe(pipe);
 }
 


