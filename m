Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84BA5E7B20
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiIWMt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiIWMtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:49:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8C3139F4B
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 05:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79495B8317C
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 12:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC7AC433C1;
        Fri, 23 Sep 2022 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663937319;
        bh=QR1R9hnx/XwwNskUqHKclvW1kG78m+2I10WUYgPaztA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SiXsxh9BKL0836MxOlO0zWDw7NTMof/jODtBbYOY/FWAEmOJj8FdRn866NqmtVEqN
         TwFbF0lDupms1tNZEI2kXhc06/LDQFjRX/a8s9gozwKdjWYjdNC6D+HGKomGI1nq/W
         fTEYzmhGbAyWUSnc5RHthlNwMtag4m/KA3QeCWF0=
Date:   Fri, 23 Sep 2022 14:48:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Stable / LTS toolchain version requirements
Message-ID: <Yy2rI/ISpD00x/Ke@kroah.com>
References: <CANh8Qzy4CoXWDD=wpA5HAHWjmCmmin65A+1Y1FEm2BQAs38OWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANh8Qzy4CoXWDD=wpA5HAHWjmCmmin65A+1Y1FEm2BQAs38OWQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022 at 02:34:52PM +0200, Fuzzey, Martin wrote:
> Hi Greg & Sasha,
> 
> I have a question about the toolchain version requirements policy for
> LTS kernels.
> 
> I know the mainline kernel documents the requirements in
> Documentation/process/changes.rst
> but what happens if a patch added to -stable changes the requirements?
> 
> I am using 5.4-y and have 3 builds with different gcc versions:
> 1) 4.7.3
> 2) 4.9
> 3) 9.4
> 
> [yes, I know 1 and 2 are very old, they are the versions in AOSP 5 and 8...]
> 
> All three built fine on 5.4.143 but on upgrading to 5.4.214 build #1 failed.
> 
> I traced it to this stable commit
> 
> commit 352affc31e269ee6c3ec1c4d2fe65b72b7367df6
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Nov 10 11:01:03 2021 +0100
> 
>     bitfield.h: Fix "type of reg too small for mask" test
> 
>     [ Upstream commit bff8c3848e071d387d8b0784dc91fa49cd563774 ]
> 
> which introduces a use of _Generic which was only added in gcc 4.9 so
> that explains the build failure.
> 
> However  Documentation/process/changes.rst in 5.4.214 still lists 4.6
> as the minimum gcc version.
> 
> So, what is the policy on this?
> 
> A) -stable patches where the upstream version needs a newer compiler
> should be backported
>     so as to still work with the original minimum compiler version at the time?

Ideally this.  But we don't check this very well as you have seen.  Most
of the toolchain work on stable kernel releases is to get _newer_
versions of the tool chain to work properly.

Care to send a fix-up patch?

thanks,

greg k-h
