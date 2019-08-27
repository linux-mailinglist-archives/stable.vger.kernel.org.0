Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0469F213
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfH0SKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbfH0SKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 14:10:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B90602186A;
        Tue, 27 Aug 2019 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566929405;
        bh=Cl4WqdEwxFG5Ia9GOuMmaWrr96ffrxjjYfl5cWQNmq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=un5jYKiKOukvdy8PicxXO4lPJE9UnQn1r1OZP0EFEMfeFg29d2EKyohccdkTxWdIB
         VTdUL5ooWl2SOs9bXOfv8/cIWGeM8OI6KWgbqohkf/ghje6NbjvzXm6ZzHuVUfE7b0
         uhsg8kBXvqQboaBZM9kxRorpwrRBZa6RUTztVuQ4=
Date:   Tue, 27 Aug 2019 14:10:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190827181003.GR5281@sasha-vm>
References: <20190827171621.GA30360@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190827171621.GA30360@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
>Hi,
>
>I recently wrote a script which identifies patches potentially missing
>in downstream kernel branches. The idea is to identify patches backported/
>applied to a downstream branch for which patches tagged with Fixes: are
>available in the upstream kernel, but those fixes are missing from the
>downstream branch. The script workflow is something like:
>
>- Identify locally applied patches in downstream branch
>- For each patch, identify the matching upstream SHA
>- Search the upstream kernel for Fixes: tags with this SHA
>- If one or more patches with matching Fixes: tags are found, check
>  if the patch was applied to the downstream branch.
>- If the patch was not applied to the downstream branch, report
>
>Running this script on chromeos-4.19 identified, not surprisingly, a number
>of such patches. However, and more surprisingly, it also identified several
>patches applied to v4.19.y for which fixes are available in the upstream
>kernel, but those fixes have not been applied to v4.19.y. Some of those
>are on the cosmetic side, but several seem to be relevant. I didn't
>cross-check all of them, but the ones I tried did apply to linux-4.19.y.
>The complete list is attached below.
>
>Question: Do Sasha's automated scripts identify such patches ? If not,
>would it make sense to do it ? Or is there some reason why the patches
>have not been applied to v4.19.y ?

Hey Guenter,

I have a very similar script with a slight difference: I don't try to
find just "Fixes:" tags, but rather just any reference from one patch to
another. This tends to catch cases where once patch states it's "a
similar fix to ..." and such.

The tricky part is that it's causing a whole bunch of false positives,
which takes a while to weed through - and that's where the issue is
right now.

I try to review a few each week and queue them up together with my
autosel patches, but I guess I should step it up a bit.

Let me go over my list and try to catch up - I think I'll have time in
the very near future.

--
Thanks,
Sasha
