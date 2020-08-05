Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466FD23CBD3
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 17:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgHEPsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 11:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgHEPsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 11:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9B623130;
        Wed,  5 Aug 2020 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596637734;
        bh=w3YD5AQMew4L8Qrf+TDLB9YAW8ieRNKUyKBhg+PfZKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sj9xVCq6z66gJIPWnbY2Sp90eswvoaB47sXvGDz8A29evw9vQ3tmO99HR5q1Qtp2p
         AEUQrEje6yaCquuK7x9Rja1MrffNxVpUlrAbcLDCedXHKwJ+DZlxnv3kPA9DMGlyvS
         jcAeU0UrHInVgpa9SzzSTb+s11NnCWS2jbolbWWg=
Date:   Wed, 5 Aug 2020 16:29:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Boot failures in v4.4.y-queue
Message-ID: <20200805142911.GA2150858@kroah.com>
References: <89294140-4b19-0116-95e3-016295f96e09@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89294140-4b19-0116-95e3-016295f96e09@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 12:27:44PM -0700, Guenter Roeck wrote:
> Hi,
> 
> all x86 and x86_64 images fail to boot in v4.4.y-queue (v4.4.232-30-g52247eb).
> Bisect results below. Reverting both 3bc53626ab45 and d1c993b94751
> fixes the problem.
> 
> Guenter
> 
> ---
> # bad: [52247eb98ebec43288b5da7033c5b757a6fbd1d0] Linux 4.4.233-rc1
> # good: [e164d5f7b274f422f9cd4fa6a6638ea07c4969f1] Linux 4.4.232
> git bisect start 'HEAD' 'v4.4.232'
> # bad: [3bc53626ab45d3886eef382b83973969dc6fc429] x86, vmlinux.lds: Page-align end of ..page_aligned sections
> git bisect bad 3bc53626ab45d3886eef382b83973969dc6fc429
> # good: [34fda3ae46a68f53e4b18d9b5b560a9cecabb072] scsi: libsas: direct call probe and destruct
> git bisect good 34fda3ae46a68f53e4b18d9b5b560a9cecabb072
> # good: [994de7ca7e88d4c5e8893bd695dadf9af4751bc6] f2fs: check memory boundary by insane namelen
> git bisect good 994de7ca7e88d4c5e8893bd695dadf9af4751bc6
> # good: [93aa53738c81fc0e286b8cb37533e9697ae7ea6f] ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints
> git bisect good 93aa53738c81fc0e286b8cb37533e9697ae7ea6f
> # bad: [d1c993b94751c4a84604711b378906ab91fb16ad] x86/build/lto: Fix truncated .bss with -fdata-sections
> git bisect bad d1c993b94751c4a84604711b378906ab91fb16ad
> # first bad commit: [d1c993b94751c4a84604711b378906ab91fb16ad] x86/build/lto: Fix truncated .bss with -fdata-sections

Thanks, I have dropped this, and the patch after it as well, from the
tree.

greg k-h
