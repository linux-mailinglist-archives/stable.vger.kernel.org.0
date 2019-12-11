Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3698B11AC45
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfLKNkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbfLKNkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:40:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54CC220836;
        Wed, 11 Dec 2019 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576071651;
        bh=iCkbJSzBOoHP0gXvXdS/Lpa9tSyAjMi1mXdByMHq1H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lC5YpXgA9olUrXfhnnWTv+n8veXTR7ZW/WNBe4CfCgbR+7kp30Kh8HfZwLDbUW/U+
         C3swt3mvtpiJqkCBM9kRXgpNjv47n9nJsXI3j++DqV/P6DZBZA7EKq5NGQUGylwOaN
         alZUSV/saPyH/nMH37Q1ilQDY/jX6txy1dn5Nnco=
Date:   Wed, 11 Dec 2019 14:40:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     kernel.openeuler@huawei.com, Oliver Neukum <oneukum@suse.com>,
        syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH rh7.3 06/11] usb: iowarrior: fix deadlock on disconnect
Message-ID: <20191211134049.GB523125@kroah.com>
References: <20191211123154.141040-1-maowenan@huawei.com>
 <20191211123154.141040-7-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211123154.141040-7-maowenan@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 08:31:49PM +0800, Mao Wenan wrote:
> From: Oliver Neukum <oneukum@suse.com>
> 
> mainline inclusion
> from mainline-5.3
> commit c468a8aa790e0dfe0a7f8a39db282d39c2c00b46
> category: bugfix
> bugzilla: NA
> DTS: NA
> CVE: CVE-2019-19528
> 
> -------------------------------------------------
> 
> We have to drop the mutex before we close() upon disconnect()
> as close() needs the lock. This is safe to do by dropping the
> mutex as intfdata is already set to NULL, so open() will fail.
> 
> Fixes: 03f36e885fc26 ("USB: open disconnect race in iowarrior")
> Reported-by: syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Link: https://lore.kernel.org/r/20190808092728.23417-1-oneukum@suse.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/usb/misc/iowarrior.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Why are you cc:ing us all on these patches???
