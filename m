Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65A929FA04
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJ3AwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ3AwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 20:52:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18627206CB;
        Fri, 30 Oct 2020 00:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604018486;
        bh=jaVoQ6gMlDU7VIZlY2vM9Xf4+Qo24p9tTO4G+6O8AMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QtpEEOsifaM5jXznMxw0z/om881741H8UIJn4/rGXErLYq4ISCK8Q4IRY1LNaVu4K
         4sPdtHPgNCSKDDQure/dgeHZgsRQWPi63jad9SDFWvpEqFnT7qq/OxUj6RB9TgP6xA
         m/qMwW+QZzaU+i/VuX1FV4Vk9CB5K233DbecbWkc=
Date:   Thu, 29 Oct 2020 20:41:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jian Cai <jiancai@google.com>, "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
Message-ID: <20201030004124.GG87646@sasha-vm>
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com>
 <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
 <20201029233635.GF87646@sasha-vm>
 <CAKwvOd=MLOKH-JoaiQcahz3bxXiCoH_hkfw2Q_Wu7514vP3zkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=MLOKH-JoaiQcahz3bxXiCoH_hkfw2Q_Wu7514vP3zkg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 04:45:52PM -0700, Nick Desaulniers wrote:
>On Thu, Oct 29, 2020 at 4:36 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Thu, Oct 29, 2020 at 11:05:01AM -0700, Nick Desaulniers wrote:
>> >Hi Jian,
>> >Thanks for proactively identifying and requesting a backport of
>> >44623b2818.  We'll need it for Android as well soon.
>> >
>> >One thing I do when requesting backports from stable is I checkout the
>> >branch of the stable tree and see if the patch cherry picks cleanly.
>>
>> btw, an easy way to get an idea of possible dependencies is to look at
>> the dependency repo :) For this commit on 5.4:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v5.4/44623b2818f4a442726639572f44fd9b6d0ef68c
>
>Why you guys never tell me this before? :P Very cool, how is the
>dependency chain built? Is it built for every commit?

git bisect run for each commit on each branch we have. I have a little
stable-deps tool that looks something like this to make it easy:

ver=$(make SUBLEVEL= kernelversion)
cmt=$(git rev-parse $1)

for i in $(curl -s https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v$ver/$cmt | awk {'print $1'}); do
         stable commit-in-tree $i
         if [ $? -eq 1 ]; then
                 continue
         fi
         git ol $i
done

-- 
Thanks,
Sasha
