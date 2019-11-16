Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12561FEB34
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 08:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfKPH4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 02:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfKPH4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 02:56:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A0020723;
        Sat, 16 Nov 2019 07:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573890978;
        bh=2wuPYtSRWEpaZWXXk8Wv1MDnvuT4G2441OtiHG4Osp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qel294XHanRT6L9XAiRbI9/NrXtxHrTkCvqa9WM+vXPgc5IIWXofjl9TYKEGy65EC
         eBTGL+7IaC4Hx8wuxHIvvEXo3PmNObmw5QGHu2vO7ey0MxeCPdXYEPNlfzhMd7kvVl
         zeTTpYlIwj07jTRQRbnwP8a5Cur0UAdTOfjNKJ5Y=
Date:   Sat, 16 Nov 2019 15:56:14 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ralph Siemsen <ralph.siemsen@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jeremy Cline <jcline@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 4.9 02/31] Bluetooth: hci_ldisc: Postpone
 HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
Message-ID: <20191116075614.GB381281@kroah.com>
References: <20191115062009.813108457@linuxfoundation.org>
 <20191115062010.682028342@linuxfoundation.org>
 <20191115161029.GA32365@maple.netwinder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115161029.GA32365@maple.netwinder.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 11:10:29AM -0500, Ralph Siemsen wrote:
> Hi Greg,
> 
> On Fri, Nov 15, 2019 at 02:20:31PM +0800, Greg Kroah-Hartman wrote:
> > From: Kefeng Wang <wangkefeng.wang@huawei.com>
> > 
> > commit 56897b217a1d0a91c9920cb418d6b3fe922f590a upstream.
> > 
> > task A:                                task B:
> > hci_uart_set_proto                     flush_to_ldisc
> > - p->open(hu) -> h5_open  //alloc h5  - receive_buf
> > - set_bit HCI_UART_PROTO_READY         - tty_port_default_receive_buf
> > - hci_uart_register_dev                 - tty_ldisc_receive_buf
> >                                          - hci_uart_tty_receive
> > 				           - test_bit HCI_UART_PROTO_READY
> > 				            - h5_recv
> > - clear_bit HCI_UART_PROTO_READY             while() {
> > - p->open(hu) -> h5_close //free h5
> > 				              - h5_rx_3wire_hdr
> > 				               - h5_reset()  //use-after-free
> >                                              }
> > 
> > It could use ioctl to set hci uart proto, but there is
> > a use-after-free issue when hci_uart_register_dev() fail in
> > hci_uart_set_proto(), see stack above, fix this by setting
> > HCI_UART_PROTO_READY bit only when hci_uart_register_dev()
> > return success.
> > 
> > Reported-by: syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com
> > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Reviewed-by: Jeremy Cline <jcline@redhat.com>
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I was just about to ask why this had not been merged into 4.9. Spent a while
> searching archives for any discussion to explain its absence, but couldn't
> find anything. Also watched your kernel-recipes talk...
> 
> BTW, this also seems to be missing from 4.4 branch, although it was merged
> for 3.16 (per https://lore.kernel.org/stable/?q=Postpone+HCI).

Odd that it was merged into 3.16, perhaps it was done there because some
earlier patch added the problem?  I say this as I do not think this is
relevant for the 4.4.y kernel, do you?  Have you tried to apply this
patch there?

> I gather that the usual rule is that a fix must be in newer versions before
> it can go into older ones. Or at least, some patches were rejected on that
> basis. If this is in fact the policy, perhaps it could be added to
> stable-kernel-rules.rst ?

No, that's not why this was rejected.  I don't know why it didn't end up
in 4.9.y earlier, but for 4.4.y, it was not added there as I do not
think it actually is relevant (see above.)

thanks,

greg k-h
