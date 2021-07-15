Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0703C9F67
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhGON0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhGON0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:26:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08556120A;
        Thu, 15 Jul 2021 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626355435;
        bh=iujzuDDFqFyvf+YRa8xW35zE11LmA51I8hMsOmW6W7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v/AEcrKJCO2s3J8dV5FK+22nIPtpehtkgEk6h+A2TDJvHbvWm8wpSX4NXKGLEzTRI
         AWZTMFcOCZwA0mVDz3KkkYoxdBdmQhNPwHzrM4gDktNAuB9bEpcDA+UM0lUlxXzqMP
         db1qtH81Guxcs9la7Czp4bJAgwXmb8r2gZe1SuxM=
Date:   Thu, 15 Jul 2021 15:23:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable <stable@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 5.4.y stable only v2] MIPS: fix "mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'"
Message-ID: <YPA26PKsFwA2Wn+H@kroah.com>
References: <20210715130806.195223-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715130806.195223-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 09:08:06PM +0800, Gao Xiang wrote:
> This is _not_ an upstream commit and just for 5.4.y only.
> 
> kernel test robot reported a 5.4.y build issue found by randconfig [1]
> after backporting commit 89b158635ad7 ("lib/lz4: explicitly support
> in-place decompression"") due to "undefined reference to `memmove'".
> 
> However, upstream and 5.10 LTS seem fine. After digging further,
> I found commit a510b616131f ("MIPS: Add support for ZSTD-compressed
> kernels") introduced memmove() occasionally and it has been included
> since v5.10.
> 
> This partially cherry-picks the memmove() part of commit a510b616131f
> to fix the reported build regression since we don't need the whole
> patch for 5.4 LTS at all.
> 
> [1] https://lore.kernel.org/r/202107070120.6dOj1kB7-lkp@intel.com/
> Fixes: defcc2b5e54a ("lib/lz4: explicitly support in-place decompression") # 5.4.y
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> v2:
>  "just submit the fix and say _why_ this is not an upstream
> commit, do not attempt to emulate an upstream commit like
> your change did." as Greg suggested...

Thanks, much better, now queued up.

greg k-h
