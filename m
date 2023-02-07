Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0068D321
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjBGJpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBGJpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:45:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218694224
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0E9561245
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE611C433EF;
        Tue,  7 Feb 2023 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675763117;
        bh=KOf3Uv+dcLyrkArrPfY20LxJS2T93cS9l8VoOwQ7OIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oiPVofDo/YeAMRizXCVbzZMNWbBfQfkmTKBftSs3m9DKJmnm3PaSYQyQQDooB+RkQ
         nHSowngfuzn+LbduhGeKJq6oDlF3UWOGfU9srViD/P2SMLyETZJYaV6BeTqUu21Vkl
         fO0cYUZELUieXAVchXU6fUl3B5Vv4NqMEa1RtNFc=
Date:   Tue, 7 Feb 2023 10:45:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     Jan Kara <jack@suse.cz>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4] udf: Avoid using stale lengthOfImpUse
Message-ID: <Y+IdqvBEMeUgvOxy@kroah.com>
References: <20230206224918.3636940-1-nobelbarakat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206224918.3636940-1-nobelbarakat@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 10:49:18PM +0000, Nobel Barakat wrote:
> From: Jan Kara <jack@suse.cz>
> 
> commit c1ad35dd0548ce947d97aaf92f7f2f9a202951cf upstream
> 
> udf_write_fi() uses lengthOfImpUse of the entry it is writing to.
> However this field has not yet been initialized so it either contains
> completely bogus value or value from last directory entry at that place.
> In either case this is wrong and can lead to filesystem corruption or
> kernel crashes.
> 
> This patch deviates from the original upstream patch because in the original
> upstream patch, udf_get_fi_ident(sfi) was being used instead of (uint8_t *)sfi->fileIdent + liu
> as the first arg to memcpy at line 77 and line 81. Those subsequent lines have been
> replaced with what the upstream patch passes in to memcpy.
> 
> 
> Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
> CC: stable@vger.kernel.org
> Fixes: 979a6e28dd96 ("udf: Get rid of 0-length arrays in struct fileIdentDesc")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
> ---
>  fs/udf/namei.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Both now queued up, thanks.

greg k-h
