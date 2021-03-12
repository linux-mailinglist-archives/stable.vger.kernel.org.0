Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A833389C9
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhCLKOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233241AbhCLKNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:13:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A3764FE0;
        Fri, 12 Mar 2021 10:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615543392;
        bh=CXYKx7axsfKXw2XBYeApFSKwoY/rOIiGq6qs42H2XdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vnnGNkrII1WysOM8poKSTCBYj60kbz3yq1rn7CYyUxeK/lkqEKf5YcdyGLwKSDp0G
         bj05gpqdtZkRK4eOkQws3TCQHG0n7Nb8E7t0BPSaPuYwVmow7zyJNp5fu0jh13bRz/
         d/lAqUBbjuLMFORpWAcJ4qQolA8SgR2kPSLSIVog=
Date:   Fri, 12 Mar 2021 11:03:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] [backport for 5.10] powerpc/603: Fix protection of user
 pages mapped with PROT_NONE
Message-ID: <YEs8XbJwrkZzc1eJ@kroah.com>
References: <656520fecf792b8842dc54beec2da3bc29d0133c.1615486986.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <656520fecf792b8842dc54beec2da3bc29d0133c.1615486986.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 06:24:30PM +0000, Christophe Leroy wrote:
> (cherry picked from commit c119565a15a628efdfa51352f9f6c5186e506a1c)
> 
> On book3s/32, page protection is defined by the PP bits in the PTE
> which provide the following protection depending on the access
> keys defined in the matching segment register:
> - PP 00 means RW with key 0 and N/A with key 1.
> - PP 01 means RW with key 0 and RO with key 1.
> - PP 10 means RW with both key 0 and key 1.
> - PP 11 means RO with both key 0 and key 1.
> 
> Since the implementation of kernel userspace access protection,
> PP bits have been set as follows:
> - PP00 for pages without _PAGE_USER
> - PP01 for pages with _PAGE_USER and _PAGE_RW
> - PP11 for pages with _PAGE_USER and without _PAGE_RW
> 
> For kernelspace segments, kernel accesses are performed with key 0
> and user accesses are performed with key 1. As PP00 is used for
> non _PAGE_USER pages, user can't access kernel pages not flagged
> _PAGE_USER while kernel can.
> 
> For userspace segments, both kernel and user accesses are performed
> with key 0, therefore pages not flagged _PAGE_USER are still
> accessible to the user.
> 
> This shouldn't be an issue, because userspace is expected to be
> accessible to the user. But unlike most other architectures, powerpc
> implements PROT_NONE protection by removing _PAGE_USER flag instead of
> flagging the page as not valid. This means that pages in userspace
> that are not flagged _PAGE_USER shall remain inaccessible.
> 
> To get the expected behaviour, just mimic other architectures in the
> TLB miss handler by checking _PAGE_USER permission on userspace
> accesses as if it was the _PAGE_PRESENT bit.
> 
> Note that this problem only is only for 603 cores. The 604+ have
> an hash table, and hash_page() function already implement the
> verification of _PAGE_USER permission on userspace pages.
> 
> Fixes: f342adca3afc ("powerpc/32s: Prepare Kernel Userspace Access Protection")
> Change-Id: I68bc5e5ff4542bdfcdcd12923fa96a5811707475
> Cc: stable@vger.kernel.org # v5.2+
> Reported-by: Christoph Plattner <christoph.plattner@thalesgroup.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/4a0c6e3bb8f0c162457bf54d9bc6fd8d7b55129f.1612160907.git.christophe.leroy@csgroup.eu
> ---
>  arch/powerpc/kernel/head_book3s_32.S | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Both backports applied, thanks.

greg k-h
