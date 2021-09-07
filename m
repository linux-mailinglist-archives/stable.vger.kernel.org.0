Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA964024FE
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhIGIUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 04:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236269AbhIGIUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 04:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA3E6108E;
        Tue,  7 Sep 2021 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631002751;
        bh=W647jj4n/AXY270eoCzaSU0MNI6C5cZZM2tLOwvy4dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GwrFcHOmtxjGue4i9D6qdqgrvk0OR6iC3tV0naM/bXv9Oj+uGVMuJyYkVRQ+9Oywg
         sT7ipWMNYjguL8dVntyII+SJfz+C3A0cHmglfMYUQ7/u22AX+oWg6+Pngf7Nwhmj7R
         BS0XesHF94zOfSJmuARfbxF13M8QurSS4yBX3fvXnhIkhQcQQcLq1TcI9kyREGt6fm
         GDd/tiImzApHen6zXo+Y/QFgbTir7vMZ5OyAhMZbE9WwqTVv+8zDQig6/ZPceaQqfv
         3/L9po5mIvfjwtpxfZGYMCzss4JBCGrfUl3ykDVAIJP+YqOGsq26GoWMpqMjvcG3DD
         Hu/c0YnueZHaQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mNWJn-00013I-Db; Tue, 07 Sep 2021 10:18:59 +0200
Date:   Tue, 7 Sep 2021 10:18:59 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Subject: Re: [PATCH] USB: cdc-acm: fix minor-number release
Message-ID: <YTcgc/wMDEpIpJG1@hovoldconsulting.com>
References: <20210906124339.22264-1-johan@kernel.org>
 <b0af8328-52c4-e5f8-5e11-36f95f32e735@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0af8328-52c4-e5f8-5e11-36f95f32e735@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 03:02:43PM +0200, Oliver Neukum wrote:
> 
> On 06.09.21 14:43, Johan Hovold wrote:
> > @@ -1323,8 +1324,10 @@ static int acm_probe(struct usb_interface *intf,
> >  	usb_get_intf(acm->control); /* undone in destruct() */
> >  
> >  	minor = acm_alloc_minor(acm);
> > -	if (minor < 0)
> > +	if (minor < 0) {
> > +		acm->minor = ACM_TTY_MINORS;
> >  		goto err_put_port;

> Congratulations for catching that one.

Heh, thanks.

> May I request to improve understandability of the code that you give
> the constant a distinct name for this purpose? Something like
> 
> ACM_MINOR_POISON or ACM_INVALID_MINOR
> 
> so that normal people can understand the fixed code?

Sure, I'll use ACM_MINOR_INVALID.

Johan
