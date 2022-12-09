Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250F3647E02
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 07:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLIGxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 01:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLIGxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 01:53:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BCF21802;
        Thu,  8 Dec 2022 22:53:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B6DFB827BB;
        Fri,  9 Dec 2022 06:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C29C433EF;
        Fri,  9 Dec 2022 06:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670568785;
        bh=XNFEy3iO8bhcXdgTiK3BJXgGhDVDovoZXiBXRmu+VzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3m4s1oOZo6hN4APtw1sUf0Mz5CVtt8tZ/e95ewXQvjp6uyEZAL4/MkLbUYHBKhCS
         g/qOWb8EILjrOwstDkpThqNCoq0hR+dz+9SFiz6VwfeEOLlybeC3l2j8WhPupqjCwg
         +5uoQaXp8EaFp8MFMEgyflHJWwBNMav9TvcpAsevQQo/NqSmjVeyjonjjPyq40ASTO
         S3iKofOzZhjbYMIWY6iLsrRorDInVdGzuaclIR7BuskZ67gSugthXQcrJlvTnzqQwU
         5SvHzecyKkvR00hhGrcL/tpFwhmffzgkFbBVdlFstjZJ1VCOTtTVDbpe0KLyNEx6n0
         fr3rC4M2dc1Vg==
Date:   Fri, 9 Dec 2022 01:53:02 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <Y5LbTkjORxVhgpKy@sashalap>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu>
 <20221208091523.t6ka6tqtclcxnsrp@quack3>
 <Y5IFR4K9hO8ax1Y0@mit.edu>
 <e2a77778-7a2b-2811-95ff-be67a44afceb@leemhuis.info>
 <Y5LR2ffwz39donWu@mit.edu>
 <cf8401c8-d9cb-c0be-890b-6aa14d06c1d2@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cf8401c8-d9cb-c0be-890b-6aa14d06c1d2@leemhuis.info>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 07:31:03AM +0100, Thorsten Leemhuis wrote:
>On 09.12.22 07:12, Theodore Ts'o wrote:
>> On Thu, Dec 08, 2022 at 06:16:02PM +0100, Thorsten Leemhuis wrote:
>>>
>>> Maybe I should talk to Greg again to revert backported changes like
>>> 1be97463696c until fixes for them are ready.
>>
>> The fix is in the ext4 git tree, and it's ready to be pushed to Linus
>> when the merge window opens --- presumably, on Sunday.
>
>Thx!
>
>> So it's probably not worth it to revert the backported change, only to
>> reapply immediately afterwards.
>
>Definitely agreed, I was more taking in the general sense (sorry, should
>have been clearer), as it's not the first time some backport exposes
>existing problems that take a while to get analyzed and fixed in
>mainline. Which is just how it is sometimes, hence a revert and a
>reapply of that backport (once the fix is available) in stable/longterm
>sounds appropriate to me to prevent users from running into known problems.

It's a balancing act: reverting a fix would mean that we reintroduce an
issue that was previously fixed back to users. It's not always the right
thing to do, and sometimes we won't.

-- 
Thanks,
Sasha
