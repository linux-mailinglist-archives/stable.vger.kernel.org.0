Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A6B0CED
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 12:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfILKbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 06:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbfILKbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 06:31:17 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F48320692;
        Thu, 12 Sep 2019 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568284277;
        bh=FSvDZkymsbGwN3yUhTgIMqAGPqGhMRfbTAxS1kGDkGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=db+Uzp7CCNX7O+qxnGT/wkh8CYu9WidEfnxySFVJ5cH3KoH7mtxgaQU9ZyGhK40ee
         lDYCLNLSq+3PxLD4qUm99Eb6J3IPsRLsjn2yYlzyQjqn90+1MGcCQoRmD2tDJPtd33
         yNQCEjZluWOqtR6/ToFmbATfdWzZO9ZsxgAf8mYQ=
Date:   Thu, 12 Sep 2019 11:31:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ilie Halip <ilie.halip@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.4] x86, boot: Remove multiple copy of static function
 sanitize_boot_params()
Message-ID: <20190912103114.GA56013@kroah.com>
References: <20190912072146.68410-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912072146.68410-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 12:21:48AM -0700, Nathan Chancellor wrote:
> From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> 
> commit 8c5477e8046ca139bac250386c08453da37ec1ae upstream.
> 
> Kernel build warns:
>  'sanitize_boot_params' defined but not used [-Wunused-function]
> 
> at below files:
>   arch/x86/boot/compressed/cmdline.c
>   arch/x86/boot/compressed/error.c
>   arch/x86/boot/compressed/early_serial_console.c
>   arch/x86/boot/compressed/acpi.c
> 
> That's becausethey each include misc.h which includes a definition of
> sanitize_boot_params() via bootparam_utils.h.
> 
> Remove the inclusion from misc.h and have the c file including
> bootparam_utils.h directly.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/1563283092-1189-1-git-send-email-zhenzhong.duan@oracle.com
> [nc: Fixed conflict around lack of 67b6662559f7f]
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Hi Greg and Sasha,
> 
> Please consider applying this to 4.4 as it resolves a compilation error
> with clang on 4.4 and it has already been applied to 4.9 and newer:
> 
> https://travis-ci.com/ClangBuiltLinux/continuous-integration/jobs/232287034
> 
> https://github.com/ClangBuiltLinux/linux/issues/654
> 
> Thanks to Ilie Halip for debugging this; TL;DR: clang pretends that it
> is GCC 4.2.1 for glibc compatibility and this trips up a definition of
> memcpy for GCC < 4.3. This is not an issue on mainline because GCC 4.6
> is the earliest supported GCC version so that code was removed and this
> patch resolves it because string.h redefines memcpy to a proper version.

Now queued up, thanks.

greg k-h
