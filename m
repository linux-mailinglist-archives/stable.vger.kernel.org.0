Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D36B5C54
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 14:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCKNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 08:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKNls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 08:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8708120846;
        Sat, 11 Mar 2023 05:41:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2F6B8255A;
        Sat, 11 Mar 2023 13:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125B7C433EF;
        Sat, 11 Mar 2023 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678542104;
        bh=TUj6B2JUwlbSCcSD1ruoTBbqXG49LuQK4EwxuZZ0zq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hkbIgcPL81/oRuov0WC7BfBxYy5TC4QaNo3Uz+QpuYt7UUGUUDIzuEkD4Vq8vShAD
         d0QiZPUfaox+OJwmsTW1N3lKPLZYf+bv4zCQ+zYLQC4h2GNb/sSDD7ng0zH2qjo8wt
         eMUmnntqFrAJwk/M1+wJh+zXVl/VwT/gYYsVms/VNgBninB83XZRblWg0oLqwmfmwt
         72QdGC1JxC19AWXGk2XcbeI1Osck+aDFwIfzCygp7HfXqH/VRMhcFEIN6/8ozmhH5n
         SSQaDpTxKtJr3vFd/JDApUjnPYxzP9TqQPIJ43f26WtafxRFdkHA+qM4X/2SgNIajM
         JsuPdXTDxN0Tg==
Date:   Sat, 11 Mar 2023 08:41:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAyFFtORBosdarMr@sashalap>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <ZAu4GE0q4jzRI+F6@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAu4GE0q4jzRI+F6@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 03:07:04PM -0800, Eric Biggers wrote:
>On Mon, Feb 27, 2023 at 07:41:31PM -0800, Eric Biggers wrote:
>>
>> Well, probably more common is that prerequisites are in the same patchset, and
>> the prerequisites are tagged for stable too.  Whereas AUTOSEL often just picks
>> patch X of N.  Also, developers and maintainers who tag patches for stable are
>> probably more likely to help with the stable process in general and make sure
>> patches are backported correctly...
>>
>> Anyway, the point is, AUTOSEL needs to be fixed to stop inappropriately
>> cherry-picking patch X of N so often.
>>
>
>... and AUTOSEL strikes again, with the 6.1 and 6.2 kernels currently crashing
>whenever a block device is removed, due to patches 1 and 3 of a 3-patch series
>being AUTOSEL'ed (on the same day I started this discussion, no less):
>
>https://lore.kernel.org/linux-block/CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com/T/#u
>
>Oh sorry, ignore this, it's just an anecdotal example.

Yes, clearly a problem with AUTOSEL and not with how sad the testing
story is for stable releases.

-- 
Thanks,
Sasha
