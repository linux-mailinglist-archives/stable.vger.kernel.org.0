Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623B8CE9CD
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfJGQsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 12:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfJGQsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 12:48:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1309C20659;
        Mon,  7 Oct 2019 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570466910;
        bh=uaIHpF/If6uI3IN+EaDDFj03MPBFPdqVnFBMY29qMGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddOCTBEdXHAyA68qXDQg1cPJd2U6TPN/ueiBHFOS2sAin/7R1r95CI53SY/BM9D2u
         rtvFzHTaMZu1OYD8a+6HO1+G/P8HuAhnvod8K2XAhGxqeTgo9JpYQ+YBcvedRjhMVU
         effOd7lieWvzjVh5RlfcHubSgBKHrJc1xQFPQ8sA=
Date:   Mon, 7 Oct 2019 18:48:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: filter of trusted xattr results in audit
Message-ID: <20191007164828.GB1090238@kroah.com>
References: <20191007160918.29504-1-salyzyn@android.com>
 <20191007161616.GA988623@kroah.com>
 <20191007161725.GB988623@kroah.com>
 <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 09:42:08AM -0700, Mark Salyzyn wrote:
> 
> <sigh>
> 
> Now what is the playbook, we have three options in order of preference:
> 
> 1) #ifdef MODULE use capable() to preserve API, add a short comment about
> the side effects if overlayfs is used as a module.
> 
> 2) export has_capability_nodaudit (proc and oom_kill use it, and are both
> built-in only), but affect the 3.18 API at near EOL. AFAIK no one wants
> that?

I'll just do this.  3.18 is EOL, this is only being done for a
distro-specific tree (i.e. AOSP).

> 3) Do nothing more. Make this a distro concern only. Leave this posted as a
> back-port for the record, but never merged, for those that are _interested_
> and declare 3.18 stable as noisy for sepolicy and overlayfs under some usage
> patterns with few user space mitigation unless they explicitly take this
> back-port into their tree (eg: android common kernel) if used built-in. This
> way, in 3.18.y at least the module and built-in version behave the _same_ in
> stable.

I'll just add the export to the patch and check this into AOSP, thanks!

greg k-h
