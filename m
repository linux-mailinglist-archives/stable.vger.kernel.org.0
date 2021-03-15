Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8290F33B83F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhCOOCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232941AbhCOOAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7F864F19;
        Mon, 15 Mar 2021 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816799;
        bh=I5/Ju2sqpmZF9GUUl8cG9iEELjgWoaYlwhzX40Zzz+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqmaPCmMak7fESJlSDQNLm1FMx5WFB1Y/EJ2//3N5vVEPI4vRkTT3SoOfsijrRB5A
         IZSE4zMDRIxOPtT0T0Sl26tNuTWxCQzu78AQzXN0tTOhKjL+6XFVVtGh7WyyHQEjvf
         F3s/zDBRkFHBHEKLrHcKUJy72IzxP/He6N1Ac5Hs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.19 076/120] usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM
Date:   Mon, 15 Mar 2021 14:57:07 +0100
Message-Id: <20210315135722.462364689@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
 


