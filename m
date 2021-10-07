Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43606424D3C
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 08:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhJGGWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 02:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240244AbhJGGWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 02:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F20E6105A;
        Thu,  7 Oct 2021 06:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633587628;
        bh=aPJR8rveZdMSK49HX1bEHqB+5KjL8kWqjuTWukml0+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=byukPJNaia1CkVDazXrQhFtWL9WnFDb7GOGRZ8QKxvIE+9SQV6izufbjdgPYfCMBU
         2L3hLZ6c0W2PiJrdO68dDn09J/xL2Pro9EwuDlKSxHh52rEszR16V3h6Y2FFq6WtlS
         DHLCAdH8N8VTkRk8nsANJfXnOJ58Jvs6VznbVF38=
Date:   Thu, 7 Oct 2021 08:20:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Stable release 4.4.286 broken for ARM64 with
 CONFIG_CC_STACKPROTECTOR=y
Message-ID: <YV6RqtU4uLJs5ntR@kroah.com>
References: <DM5PR11MB001226B8D03B8CC8FA093AC6DDB09@DM5PR11MB0012.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR11MB001226B8D03B8CC8FA093AC6DDB09@DM5PR11MB0012.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 09:20:42PM +0000, Hans-Christian Egtvedt (hegtvedt) wrote:
> Hello,
> 
> latest stable release 4.4.286 does not build for me on ARM64 with 
> CONFIG_CC_STACKPROTECTOR=y.
> 
> The offending commit
> 
> commit 69e450b170995e8a4e3eb94fb14c822553124870
> Author: Dan Li <ashimida@linux.alibaba.com>
> Date:   Tue Sep 14 11:44:02 2021
> 
>      arm64: Mark __stack_chk_guard as __ro_after_init
> 
> The 4.4.y kernel does not have the ro_after_init section defined at all, 
> stable kernel 4.9.y is the first to have it.
> 
> I do not have an overview of this feature, but it appears to have 
> started with commit
> 
> commit c74ba8b3480da6ddaea17df2263ec09b869ac496
> Author: Kees Cook <keescook@chromium.org>
> Date:   Wed Feb 17 23:41:15 2016
> 
>      arch: Introduce post-init read-only memory
> 
> -- 
> Best regards, Hans-Christian Noren Egtvedt.

Thank you for letting me know.  I'll go revert this and do a new release
with this fixed.

greg k-h
