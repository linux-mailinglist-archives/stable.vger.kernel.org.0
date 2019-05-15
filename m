Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451981F649
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfEOOQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 10:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbfEOOQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 10:16:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE5462084E;
        Wed, 15 May 2019 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557929767;
        bh=nBsn7/9SkqhQaLs4aJMbNED/PvzJuaH0Nvbb1xhB1ds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WN0knMRvCCL1HFnQ8nQFtCpu4hbzkZzP0UtfAlnjItM1hQW429xwlxGPIuFUPBrD8
         BTqh9i+pGG9kqYAVI3zEBcpAZ6FxAxalF2be+eBc2h6MGk1lr00rjglbQAKN+mj19e
         K8loKcIQ3jwFdqT6d3iCtSycnkYwWlCjgbY21BZI=
Date:   Wed, 15 May 2019 16:16:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, erhard_f@mailbox.org,
        Michael Neuling <mikey@neuling.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH stable 4.4] powerpc/lib: fix book3s/32 boot failure due
 to code patching
Message-ID: <20190515141604.GB8999@kroah.com>
References: <71dbc8bdad5da9f6cb0446535fb2a29c68fccf80.1557926850.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71dbc8bdad5da9f6cb0446535fb2a29c68fccf80.1557926850.git.christophe.leroy@c-s.fr>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 01:30:42PM +0000, Christophe Leroy wrote:
> [Backport of upstream commit b45ba4a51cde29b2939365ef0c07ad34c8321789]
> 
> On powerpc32, patch_instruction() is called by apply_feature_fixups()
> which is called from early_init()
> 
> There is the following note in front of early_init():
>  * Note that the kernel may be running at an address which is different
>  * from the address that it was linked at, so we must use RELOC/PTRRELOC
>  * to access static data (including strings).  -- paulus
> 
> Therefore init_mem_is_free must be accessed with PTRRELOC()
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203597
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> Can't apply the upstream commit as such due to several other unrelated stuff
> like for instance STRICT_KERNEL_RWX which are missing.
> So instead, using same approach as for commit 252eb55816a6f69ef9464cad303cdb3326cdc61d
> 
> Removed the Fixes: tag as I don't know yet the commit Id of the fixed commit on 4.4 branch.
> ---
>  arch/powerpc/lib/code-patching.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now added, thanks.

greg k-h
