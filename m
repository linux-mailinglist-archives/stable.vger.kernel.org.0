Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFE155A99
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 16:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgBGPWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 10:22:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43713 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726899AbgBGPWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 10:22:17 -0500
Received: (qmail 4104 invoked by uid 500); 7 Feb 2020 10:22:16 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 7 Feb 2020 10:22:16 -0500
Date:   Fri, 7 Feb 2020 10:22:16 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     "Enderborg, Peter" <Peter.Enderborg@sony.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
In-Reply-To: <96c523ea-799f-ad2f-f1c4-46ff6f9f6d6c@sony.com>
Message-ID: <Pine.LNX.4.44L0.2002071018580.3671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 Feb 2020, Enderborg, Peter wrote:

> On 2/6/20 4:14 PM, Alan Stern wrote:

> > I guess you have to unbind the device from the usbhid driver first in
> > order for lsusb to get them.  Can you do that?
> >
> > Alan Stern
> >
> Im not sure exatly what you need to unbind. But I assume this is what you want:
> 
>  lsusb -v -d 0fd9:0060

Yes, that's it.  Most of the reports have:

>             Item(Global): Report Size, data= [ 0x08 ] 8
>             Item(Global): Report Count, data= [ 0x10 ] 16

which means they are 16 bytes long.  But one report has:

>             Item(Global): Report Size, data= [ 0x08 ] 8
>             Item(Global): Report Count, data= [ 0xfe 0x1f ] 8190

meaning it is 8190 bytes long (plus one byte for the report ID).  
Therefore setting the maximum buffer size to 8192 should allow this 
device to work properly, with no other changes needed.

Alan Stern

