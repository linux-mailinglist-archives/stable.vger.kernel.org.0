Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4689CC55
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfHZJN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbfHZJN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 05:13:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA7A7A2F6A0;
        Mon, 26 Aug 2019 09:13:28 +0000 (UTC)
Received: from [10.36.116.118] (ovpn-116-118.ams2.redhat.com [10.36.116.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56ED85D704;
        Mon, 26 Aug 2019 09:13:25 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e2?=
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
 <20190825144122.GA27775@kroah.com>
 <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
 <20190826083309.GA32549@kroah.com>
From:   Nikolai Kondrashov <Nikolai.Kondrashov@redhat.com>
Message-ID: <1e9a3221-f044-a3a0-bbe1-34e6f8a468f0@redhat.com>
Date:   Mon, 26 Aug 2019 12:13:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190826083309.GA32549@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Mon, 26 Aug 2019 09:13:28 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/19 11:33 AM, Greg KH wrote:
> On Mon, Aug 26, 2019 at 11:23:58AM +0300, Nikolai Kondrashov wrote:
>> On 8/25/19 5:41 PM, Greg KH wrote:
>>> On Sun, Aug 25, 2019 at 10:37:26AM -0400, CKI Project wrote:
>>>> Merge testing
>>>> -------------
>>>>
>>>> We cloned this repository and checked out the following commit:
>>>>
>>>>     Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>>>>     Commit: f7d5b3dc4792 - Linux 5.2.10
>>>>
>>>>
>>>> We grabbed the cc88f4442e50 commit of the stable queue repository.
>>>>
>>>> We then merged the patchset with `git am`:
>>>>
>>>>     keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
>>>
>>> That file is not in the repo, I think your system is messed up :(
>>
>> Sorry for the trouble, Greg, but I think it's a race between the changes to
>> the two repos.
>>
>> The job which triggered this message was started right before the moment this
>> commit was made:
>>
>>      https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=af2f46e26e770b3aa0bc304a13ecd24763f3b452
>>
>> At that moment, the repo was still on this commit, about five hours old:
>>
>>      https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=cc88f4442e505e9f1f21c8c119debe89cbf63ab2
>>
>> which still had the file. And when the job finished, and the message reached
>> you, yes, the repo no longer contained it.
>>
>> At the moment the job started, the latest commit to stable/linux.git
>> was about 22 minutes old:
>>
>>      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f7d5b3dc4792a5fe0a4d6b8106a8f3eb20c3c24c
>>
>> and the repo already contained the patches from the queue, including the one
>> the job tried to merge:
>>
>>      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f820ecf609cc38676071ec6c6d3e96b26c73b747
> 
> How in the world are you seeing such a messed up tree?
> 
> The 5.2.10 commit moved things around, in one single atomic move.
> 
>> IIRC, we agreed to not start testing both of the repos until the latest
>> commits are at least 5 minutes old. In this situation the latest commit was 22
>> minutes old, so the system started testing.
>>
>> We could increase the window to, say, 30 minutes (or something else), to avoid
>> misfires like this, but then the response time would be increased accordingly.
>>
>> It's your pick :)
> 
> Why is there any race at all?
> 
> Why do you not have a local mirror of the repo?  When it updates, then
> run the tests.  Every commit in the tree is "stand alone" and things
> should work at that point in time.  Don't use a commit as a "time to go
> mirror something at a later point in time", as you are ending up with
> trees that are obviously not correct at all.
> 
> I think you need to rework your systems as no one else seems to have
> this "stale random tree state" issue.
> 
> Git does commits in an atomic fashion, how you all are messing that up
> shows you are doing _way_ more work than you probably need to :)

Sorry, I'm not the one who implemented and maintains the system, I'm just
generally aware of how it works and am looking at the code right now, so I
could be misunderstanding something. Please bear with me :)

However, I don't see how anything could be done, if we have two git repos,
which are inconsistent with each other, when CI comes to test them.

I'll try to draw the timeline of what was happening to explain what I think is
the problem. All times are in my timezone (UTC+03:00).

Time            stable/linux.git    stable/stable-queue.git Comments
                 branch linux-5.2.y  branch master
                                     subdir queue-5.2
--------------- ------------------- ----------------------- -----------------
Aug 5 19:44:27  aad39e30fb9e6e72,                           Repos are
                 "Linux 5.2.9",                              consistent
                 *doesn't have* the
                 patch that failed

Aug 25 11:53:25                     cc88f4442e505e9f,       Repos are
                                     "Linux 4.4.190",        consistent
                                     *has* the patch
                                     that failed

Aug 25 17:13:54 f7d5b3dc4792a5,                             Repos are
                 "Linux 5.2.10",                             inconsistent,
                 contains patches                            both contain
                 from the queue                              the same patches
                 above, including
                 the failed one

Aug 25 17:36:18                                             Our CI job starts

Aug 25 17:36:19                     af2f46e26e770b3a        Repos are
                                     "Linux 5.2.10",         consistent
                                     "queue-5.2" dir is
                                     removed, doesn't
                                     have the failed
                                     patch

Aug 25 17:37:23                                             Our CI sends
                                                             failure report

I.e. I think the problem was that both linux-5.2.y branch of stable/linux.git,
and the queue-5.2 subdir of master branch of stable/stable-queue.git contained
the same patches for about 22 minutes on Aug 25, when our CI started.

We sample the latest commits from both repos at the same time (well, as close
as Python and HTTP allow us), and we update our clones to those before
testing.

We also don't start testing if the commits in either are less than 5 minutes
old to avoid testing inconsistent repos, assuming that 5 minutes are enough to
update them both to keep them in consistency. We can increase that time to
what you think best fits your workflow, to avoid hitting these problems.

Nick
