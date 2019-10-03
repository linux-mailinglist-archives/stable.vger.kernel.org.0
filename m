Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B6BC994F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfJCHz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfJCHz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 03:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A867521D71;
        Thu,  3 Oct 2019 07:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570089328;
        bh=jIfdfyldSW/4sG+r+fNpEW8b72MATdqkvG4z53ixNXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xCoQhDnc7CQajkXqGT/6mzA2zkCMMiHCku2PlhrRZiqOWJRX4eXpshbJ29J2clyb3
         8VwtZYXU4UDO2kzKb3OvYjDxcXDn/v4YxNgk0TlIpi+P+x0LT6HzNQ4X3Pvzx/O0Ct
         FsHgxU1iYMaFW99UchroNVTQVWa2S96amVO/8TGE=
Date:   Thu, 3 Oct 2019 09:55:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 4.14] x86/retpolines: Fix up backport of a9d57ef15cbe
Message-ID: <20191003075525.GB1848078@kroah.com>
References: <20190929183206.922721-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929183206.922721-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 11:32:06AM -0700, Nathan Chancellor wrote:
> Commit a9d57ef15cbe ("x86/retpolines: Disable switch jump tables when
> retpolines are enabled") added -fno-jump-tables to workaround a GCC issue
> while deliberately avoiding adding this flag when CONFIG_CC_IS_CLANG is
> set, which is defined by the kconfig system when CC=clang is provided.
> 
> However, this symbol was added in 4.18 in commit 469cb7376c06 ("kconfig:
> add CC_IS_CLANG and CLANG_VERSION") so it is always undefined in 4.14,
> meaning -fno-jump-tables gets added when using Clang.
> 
> Fix this up by using the equivalent $(cc-name) comparison, which matches
> what upstream did until commit 076f421da5d4 ("kbuild: replace cc-name
> test with CONFIG_CC_IS_CLANG").
> 
> Fixes: e28951100515 ("x86/retpolines: Disable switch jump tables when retpolines are enabled")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  arch/x86/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks!

greg k-h
