Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7737E61FDF
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfGHNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfGHNzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 09:55:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41CFA20861;
        Mon,  8 Jul 2019 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562594122;
        bh=h+JIToW0VCwcJEr296yFCpDhwCUUbZ8SK/H8fB8sNm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WPMUQ37Ip1m0+HL8UsuR0HVexFctKEmvovH1tduZmAclun03+5wHsL1cbUph3OrPt
         qUUICEx9UG/ro6jsSbsvZOQjXH4sxqf9QaKZrVBPG+4aVImlikivXAJX40bG/EfAm4
         SerCdZizK8pcfaTWC5XXuSfjvFZ6HxBI1Ju9AjGE=
Date:   Mon, 8 Jul 2019 15:55:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failures in v4.4.y.queue, v4.9.queue
Message-ID: <20190708135519.GA2900@kroah.com>
References: <1d749d61-a489-11e2-bb6b-21408e1057ff@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d749d61-a489-11e2-bb6b-21408e1057ff@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 06:21:31AM -0700, Guenter Roeck wrote:
> Various cris builds:
> 
> init/built-in.o: In function `repair_env_string':
> main.c:(.init.text+0x106): undefined reference to `abort'
> arch/cris/mm/built-in.o: In function `do_page_fault':
> (.text+0x44e): undefined reference to `abort'
> arch/cris/mm/built-in.o: In function `mem_init':
> (.init.text+0x12): undefined reference to `abort'
> arch/cris/arch-v10/kernel/built-in.o: In function `cris_request_io_interface':
> (.text+0x219e): undefined reference to `abort'
> arch/cris/arch-v10/kernel/built-in.o: In function `cris_free_io_interface':
> (.text+0x2644): undefined reference to `abort'
> kernel/built-in.o:(.text+0x416): more undefined references to `abort' follow
> 
> Caused by commit commit b068c10cde7f3e ("bug.h: work around GCC PR82365 in BUG()").
> Reverting it fixes the problem. I would suggest to undo the cris specific changes
> in that backport. An alternative would be for me to stop build-testing for the
> architecture if there is no further interest in keeping it alive for older branches.

Odd, why doesn't that trigger in mainline?

Oh, cris is gone upstream, that makes sense.  I'll just go drop that
hunk from the patches so that things keep building.

thanks,

greg k-h
