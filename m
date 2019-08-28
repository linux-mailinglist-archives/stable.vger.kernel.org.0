Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51ACA0187
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfH1MWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfH1MWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:22:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2FC120856;
        Wed, 28 Aug 2019 12:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566994962;
        bh=yTsjRs8gSBXdAGSmvmHfZ1OcyAj6phsNTV4hsF62HaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdtAUIGUI03GVAlpt4j6SjGgD/VAljnqPTqV54sskUdWcoZrN8W3snFZuzIT4hnDk
         fDBK0Mk6inPmyB3/JyI1YNbZvkl4J9sfTCE72qBQ6ki8qdZsRLN5AlmfLrP0PBP74y
         TSOx0FjpEdds5lEG2NbQ3/xNXmhsK8LuOfSaJaN8=
Date:   Wed, 28 Aug 2019 08:22:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190828122240.GC5281@sasha-vm>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
 <20190827200151.GA19618@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190827200151.GA19618@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
>On Tue, Aug 27, 2019 at 02:10:03PM -0400, Sasha Levin wrote:
>> On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
>> >Hi,
>> >
>> >I recently wrote a script which identifies patches potentially missing
>> >in downstream kernel branches. The idea is to identify patches backported/
>> >applied to a downstream branch for which patches tagged with Fixes: are
>> >available in the upstream kernel, but those fixes are missing from the
>> >downstream branch. The script workflow is something like:
>> >
>> >- Identify locally applied patches in downstream branch
>> >- For each patch, identify the matching upstream SHA
>> >- Search the upstream kernel for Fixes: tags with this SHA
>> >- If one or more patches with matching Fixes: tags are found, check
>> > if the patch was applied to the downstream branch.
>> >- If the patch was not applied to the downstream branch, report
>> >
>> >Running this script on chromeos-4.19 identified, not surprisingly, a number
>> >of such patches. However, and more surprisingly, it also identified several
>> >patches applied to v4.19.y for which fixes are available in the upstream
>> >kernel, but those fixes have not been applied to v4.19.y. Some of those
>> >are on the cosmetic side, but several seem to be relevant. I didn't
>> >cross-check all of them, but the ones I tried did apply to linux-4.19.y.
>> >The complete list is attached below.
>> >
>> >Question: Do Sasha's automated scripts identify such patches ? If not,
>> >would it make sense to do it ? Or is there some reason why the patches
>> >have not been applied to v4.19.y ?
>>
>> Hey Guenter,
>>
>> I have a very similar script with a slight difference: I don't try to
>> find just "Fixes:" tags, but rather just any reference from one patch to
>> another. This tends to catch cases where once patch states it's "a
>> similar fix to ..." and such.
>>
>> The tricky part is that it's causing a whole bunch of false positives,
>> which takes a while to weed through - and that's where the issue is
>> right now.
>>
>
>I didn't see any false positives, at least not yet. Would it possibly

I was referring to things that say that they "fixes:", but the fix it
not stable material (typos, fallthrough, etc).

>make sense to start with looking at Fixes: ? After all, additional
>references (wich higher chance for false positives) can always be
>searched for later.

Yes, let me send a branch out for review later today and we could
compare our results.

--
Thanks,
Sasha
