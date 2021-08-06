Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3F3E2CCD
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhHFOiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhHFOiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9E1611C5;
        Fri,  6 Aug 2021 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628260668;
        bh=khVI8wg5QxaDDJH7JuaRSGEyoJH/4rUxT9m7dXRWG1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KVKfc1Ir285DW3HtQ33xC4sHEMUy18HQZ/n1lE6cRszead/7RZHCY7zvzm8LsPK8h
         cnsiX6zPoQlWRBa74NfQKREX1XTTDHuugKMSCy/GfqW4L5NdHKIrelcg11qxtwGdwo
         QJ5HAk4zHmYJTsFHeN5zcfmsS7yNmP9/f2y+P+Y64TadZy2MuSfv2fIhBST/Eg86+Q
         CVwpZ2CtnNn9hKsUI7cMs5PzANUpI1Zx+fy9xPiuiIK6Lx+emHrrkrQgWkSxVIhbrb
         lWOAdqasT9SQ+mhkXW/nQhSLrbT2s23HiLtdRWaG8VliBRt7ldF6wZK3apvbtsoX7Z
         F57TlR/osBhNQ==
Date:   Fri, 6 Aug 2021 10:37:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Regressions in stable releases
Message-ID: <YQ1JO1KpaBrRdSNo@sashalap>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <20210805164254.GG17808@1wt.eu>
 <20210805172949.GA3691426@roeck-us.net>
 <20210805183055.GA21961@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210805183055.GA21961@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 08:30:55PM +0200, Willy Tarreau wrote:
>On Thu, Aug 05, 2021 at 10:29:49AM -0700, Guenter Roeck wrote:
>> > It looks like a typical "works for me" regression. The best thing that
>> > could possibly be done to limit such occurrences would be to wait "long
>> > enough" before backporting them, in hope to catch breakage reports before
>> > the backport, but here there were already 3 weeks between the patch was
>> > submitted and it was backported.
>>
>> No. The patch is wrong. It just _looks_ correct at first glance.
>
>So that's the core of the problem. Stable maintainers cannot be tasked
>to try to analyse each patch in its finest details to figure whether a
>maintainer that's expected to be more knowledgeable than them on their
>driver did something wrong.
>
>Then in my opinion we should encourage *not* to use "Fixes:" on untested
>patches (untested patches will always happen due to hardware availability
>or lack of a reliable reproducer).
>
>What about this to try to improve the situation in this specific case ?

No, please let's not. If there is no testing story behind a buggy patch
then it'll explode either when we go to the next version, or when we
pull it into -stable.

If we avoid taking groups of patches into -stable it'll just mean that
we end up with a huge amount of issues waiting for us during a version
upgrade.

Yes, we may be taking bugs in now, but the regression rate (according to
LWN) is pretty low, and the somewhat linear distribution of those bugs
throughout our releases makes them managable (to review when they're
sent out, to find during testing, to bisect if we hit the bug).

As Guenter points out, the path forward should be to improve our testing
story.

-- 
Thanks,
Sasha
