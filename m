Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4997B49C7F5
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbiAZKu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240215AbiAZKu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 05:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AAEC06161C;
        Wed, 26 Jan 2022 02:50:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5358BB81CA0;
        Wed, 26 Jan 2022 10:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E6C340E5;
        Wed, 26 Jan 2022 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643194224;
        bh=cX3+eyj+6fm+/y5+YWeWLiQ5NWkVyiYkjMkXX08ExYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gTjk03rFKokIWZR1ZM2+rn5lX7QKxtSLvceIMIpcluMNn4q+to7hfk2//E9BKLI2C
         MSJJmOe8NrUN+Xir7siYqcPeDw+WmeKNUMsX6zMA4dKuh/jondY+DoiFuwC3kwqCWb
         4Vsvxqxa3tfPeuE7hOpOwcCzMLBDQgB3dB7lijDk=
Date:   Wed, 26 Jan 2022 11:50:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?6LCi5rOT5a6H?= <xiehongyu1@kylinos.cn>
Cc:     Hongyu Xie <xy521521@gmail.com>, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        125707942@qq.com, stable@vger.kernel.org
Subject: Re: [PATCH -next] xhci: fix two places when dealing with return
 value of function xhci_check_args
Message-ID: <YfEnbRW3oU0ouGqH@kroah.com>
References: <20220126094126.923798-1-xy521521@gmail.com>
 <YfEZFtf9K8pFC8Mw@kroah.com>
 <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7f6a8bb-76b6-cd2d-7551-b599a8276f5c@kylinos.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Jan 26, 2022 at 06:22:45PM +0800, 谢泓宇 wrote:
> 1."What problem?
> r8152_submit_rx needs to detach netdev if -ENODEV happened, but -ENODEV will
> never happen
> because xhci_urb_enqueue only returns -EINVAL if the return value of
> xhci_check_args <= 0. So
> r8152_submit_rx will will call napi_schedule to re-submit that urb, and this
> will cause infinite urb
> submission.

Odd line-wrapping...

Anyway, why is this unique to this one driver?  Why does it not show up
for any other driver?

> The whole point is, if xhci_check_args returns value A, xhci_urb_enqueque
> shouldn't return any
> other value, because that will change some driver's behavior(like r8152.c).

But you are changing how the code currently works.  Are you sure you
want to have this "succeed" if this is on a root hub?

> 2."So if 0 is returned, you will now return that here, is that ok?
> That is a change in functionality.
> But this can only ever be the case for a root hub, is that ok?"
> 
> It's the same logic, but now xhci_urb_enqueue can return -ENODEV if xHC is
> halted.
> If it happens on a root hub,  xhci_urb_enqueue won't be called.
> 
> 3."Again, this means all is good?  Why is this being called for a root hub?"
> 
> It is the same logic with the old one, but now xhci_check_streams_endpoint
> can return -ENODEV if xHC is halted.

This still feels wrong to me, but I'll let the maintainer decide, as I
don't understand why a root hub is special here.

thanks,

greg k-h
