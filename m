Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080F95FE095
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiJMSLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiJMSLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12546152C4D;
        Thu, 13 Oct 2022 11:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30948618CF;
        Thu, 13 Oct 2022 17:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC1AC433D7;
        Thu, 13 Oct 2022 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683797;
        bh=3BQqcau0mTJ2WJ8I+0RhdaTW9TR9ahxBYKkS/ywxSgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e60sYZxotFftMrl0lGwyZqUrma4ZcaZ7Da3q+ZuQJkwrPNR1vSDmHJowHhpeXiWsw
         p/psL85p3HjyhpXaV2SIUPHAgL4of/Z1egpTe3Ky1ufRM1A+hy22972zOgny3OBkpn
         HrQstIfKQCh631cbGyHMzPvIWse5I/tpbXb2GCu1tgNiQezK2efwe0xnE9zjGndVF4
         q4bugui5ZeK6VurFAjDvSU+JQ9manSHb4jx69p2+N47EP4hV6vQPgxKHC2T9iZ+2vq
         aYm7t/Yg69tOsecRwKM8OKgC7r1TmXzY/kVjT7t1fifjdwDq0cpf4vFJT8XBDqabwn
         RmNxE8FFByL5A==
Date:   Thu, 13 Oct 2022 13:56:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 38/46] btrfs: introduce
 BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
Message-ID: <Y0hRVO+l3oSPlJd6@sashalap>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-38-sashal@kernel.org>
 <20221012125648.GX13389@suse.cz>
 <7cf55e21-4d68-8371-a4a5-08cd8278bcf9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7cf55e21-4d68-8371-a4a5-08cd8278bcf9@gmx.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:12:10AM +0800, Qu Wenruo wrote:
>
>
>On 2022/10/12 20:56, David Sterba wrote:
>>On Tue, Oct 11, 2022 at 10:50:06AM -0400, Sasha Levin wrote:
>>>From: Qu Wenruo <wqu@suse.com>
>>>
>>>[ Upstream commit e562a8bdf652b010ce2525bcf15d145c9d3932bf ]
>>>
>>>Introduce a new runtime flag, BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN,
>>>which will inform qgroup rescan to cancel its work asynchronously.
>>>
>>>This is to address the window when an operation makes qgroup numbers
>>>inconsistent (like qgroup inheriting) while a qgroup rescan is running.
>>>
>>>In that case, qgroup inconsistent flag will be cleared when qgroup
>>>rescan finishes.
>>>But we changed the ownership of some extents, which means the rescan is
>>>already meaningless, and the qgroup inconsistent flag should not be
>>>cleared.
>>>
>>>With the new flag, each time we set INCONSISTENT flag, we also set this
>>>new flag to inform any running qgroup rescan to exit immediately, and
>>>leaving the INCONSISTENT flag there.
>>>
>>>The new runtime flag can only be cleared when a new rescan is started.
>>
>>Qu, does this patch make sense for stable on itself? It was part of a
>>series adding some new flags and the sysfs knob.  As I read it there's a
>>case where it can affect how the rescan is done and that it can be
>>cancelled but still am not sure if it's worth the backport.
>
>Considering the qgroup still lacks a way to handle large subvolume drop,
>and a lot of things can mark qgroup inconsistent halfway, I think
>backporting this patch itself is not that bad.
>
>The problem is, why only backporting this one?
>
>To me, it would make more sense to backport either all or none.
>
>Sure, if we can cancel rescan it's an improvement, but rescan itself is
>already relatively cheap compared to other qgroup operations.
>Thus I prefer to backport all the qgroup patches.

I'll drop this one and happily take a series if you want to send one
out.

-- 
Thanks,
Sasha
