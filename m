Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B525347FD44
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhL0NLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:11:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42624 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhL0NK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:10:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EAD4B80E98
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A764C36AE7;
        Mon, 27 Dec 2021 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640610657;
        bh=Cyn9AN2UpvES1gwjYGXcWJ+8RzG6px/9IXMnMV0Uwjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvMyoj+tI0vc+MXK8zxIfyNpKJtfBUlHkpSuKNmbNXWs55BiOotp0O7oTDn3POPmY
         KQ8WawmPGVQw8ZAR7S8JstipY+KNjcLmO3/uTDLFwhpeaddxIl4t/GQkuvuSTpuMSN
         GcaWYNx8ulkpqbPAHab4z9ixB/oMU2BrNdEV3maA=
Date:   Mon, 27 Dec 2021 14:10:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: Re: [RFC/PATCH for 4.4.y] usb: gadget: configfs: Fix use-after-free
 issue with udc_name
Message-ID: <Ycm7Xh2oBEGqSZPi@kroah.com>
References: <20211223052626.1631331-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <Ycm151MQzlAC0tC3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ycm151MQzlAC0tC3@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 01:47:35PM +0100, Greg KH wrote:
> On Thu, Dec 23, 2021 at 02:26:26PM +0900, Nobuhiro Iwamatsu wrote:
> > From: Eddie Hung <eddie.hung@mediatek.com>
> > 
> > commit 64e6bbfff52db4bf6785fab9cffab850b2de6870 upstream.
> > 
> > There is a use-after-free issue, if access udc_name
> > in function gadget_dev_desc_UDC_store after another context
> > free udc_name in function unregister_gadget.
> > 
> > Context 1:
> > gadget_dev_desc_UDC_store()->unregister_gadget()->
> > free udc_name->set udc_name to NULL
> > 
> > Context 2:
> > gadget_dev_desc_UDC_show()-> access udc_name
> > 
> > Call trace:
> > dump_backtrace+0x0/0x340
> > show_stack+0x14/0x1c
> > dump_stack+0xe4/0x134
> > print_address_description+0x78/0x478
> > __kasan_report+0x270/0x2ec
> > kasan_report+0x10/0x18
> > __asan_report_load1_noabort+0x18/0x20
> > string+0xf4/0x138
> > vsnprintf+0x428/0x14d0
> > sprintf+0xe4/0x12c
> > gadget_dev_desc_UDC_show+0x54/0x64
> > configfs_read_file+0x210/0x3a0
> > __vfs_read+0xf0/0x49c
> > vfs_read+0x130/0x2b4
> > SyS_read+0x114/0x208
> > el0_svc_naked+0x34/0x38
> > 
> > Add mutex_lock to protect this kind of scenario.
> > 
> > Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > Reviewed-by: Peter Chen <peter.chen@nxp.com>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/r/1609239215-21819-1-git-send-email-macpaul.lin@mediatek.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [Reference: CVE-2021-39648]
> > [iwamatsu: struct usb_gadget_driver does not have udc_name variable.
> >            Change struct gadget_info's udc_name.]
> > Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  drivers/usb/gadget/configfs.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Now queued up, thanks.
> 
> greg k-h

Oops, nope, this gives me a build warning, something is wrong with this
change:

  CC [M]  drivers/usb/gadget/configfs.o
drivers/usb/gadget/configfs.c: In function ‘gadget_dev_desc_UDC_show’:
drivers/usb/gadget/configfs.c:249:18: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
  249 |         udc_name = gi->udc_name;
      |                  ^

Please always test-build your patches :(

thanks,

greg k-h
