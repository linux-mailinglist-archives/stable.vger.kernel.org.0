Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC54AF26C
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 14:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiBINLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 08:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiBINLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 08:11:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DCEC05CBBB;
        Wed,  9 Feb 2022 05:11:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF15361924;
        Wed,  9 Feb 2022 13:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85819C340E7;
        Wed,  9 Feb 2022 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644412310;
        bh=4r5rcK4jLguRj/Ewp6yZZZX2qQCo/K36PKV3SeN0yW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmnUogQgqQCLvsQthQlgwI7PusgW066+aROHvuRuBk4ae86M5sOndoHZp4EJuoFIu
         YbVMy6ZD2PKSn1fMIMlnluXf94s7Oa2g+GjDVFRimXCV46xft0sOtwEHLSXVop4ZM/
         qFs6WdBsgN+yskAunHWy9xvgWaA6RKwAzffd75so=
Date:   Wed, 9 Feb 2022 14:11:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     luofei <luofei@unicloud.com>
Cc:     stable@vger.kernel.org, tony.luck@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm, mm/hwpoison: Fix the unmap kernel 1:1 pages
 check condition
Message-ID: <YgO9kyM6C4HResiG@kroah.com>
References: <20220208032028.852302-1-luofei@unicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208032028.852302-1-luofei@unicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 10:20:28PM -0500, luofei wrote:
> [ Upstream commit fd0e786d9d09024f67bd71ec094b110237dc3840 ]
> 
> This commit solves the problem of unmap kernel 1:1 pages
> unconditionally, it appears in Linus's tree 4.16 and later
> versions, and is backported to 4.14.x and 4.15.x stable branches.
> 
> But the backported patch has its logic reversed when calling
> memory_failure() to determine whether it needs to unmap the
> kernel page. Only when memory_failure() returns successfully,
> the kernel page can be unmapped.
> 
> Signed-off-by: luofei <luofei@unicloud.com>
> Cc: stable@vger.kernel.org #v4.14.x
> Cc: stable@vger.kernel.org #v4.15.x
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, now queued up.

greg k-h
