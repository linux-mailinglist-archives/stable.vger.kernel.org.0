Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A8641728
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLCNyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLCNya (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:54:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6432B2790B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1141BB803F4
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 13:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40791C433C1;
        Sat,  3 Dec 2022 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670075666;
        bh=x4ty8CfEIeQx9YHcY7XrQlCFmT6k32BycbxpDHZowsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sq8e7ExzRsvo38DzeS0JZhEbJ/e7OEbsrfiyQiAIEqld3lElIzTMlsVmr4EFyOysZ
         e2fiBmVdE1EArfUiOlPKpb1ZFSe4kbxv2Lv4Nh0RDUJcWnLujV6X6W/IY2oEf3g+1K
         NUobDofsIxj5Gjm2DMCgvtmuHuY1O0u7dANUxCjg=
Date:   Sat, 3 Dec 2022 14:54:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH 4.14] efi: random: Properly limit the size of the random
 seed
Message-ID: <Y4tVD2zCPR/8jk/4@kroah.com>
References: <Y4frikbdKtF5V1WU@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4frikbdKtF5V1WU@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 12:47:22AM +0100, Ben Hutchings wrote:
> Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
> added a READ_ONCE() and also changed the call to
> add_bootloader_randomness() to use the local size variable.  Neither
> of these changes was actually needed and this was not backported to
> the 4.14 stable branch.
> 
> Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
> reverted the addition of READ_ONCE() and added a limit to the value of
> size.  This depends on the earlier commit, because size can now differ
> from seed->size, but it was wrongly backported to the 4.14 stable
> branch by itself.
> 
> Apply the missing change to the add_bootloader_randomness() parameter
> (except that here we are still using add_device_randomness()).
> 
> Fixes: 700485f70e50 ("efi: random: reduce seed size to 32 bytes")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/firmware/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Both now queued up, thanks,

greg k-h
