Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B1F9CB79
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfHZIYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:24:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbfHZIYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 04:24:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71C5310C696C;
        Mon, 26 Aug 2019 08:24:06 +0000 (UTC)
Received: from [10.36.116.118] (ovpn-116-118.ams2.redhat.com [10.36.116.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3075600C4;
        Mon, 26 Aug 2019 08:24:00 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e2?=
To:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
 <20190825144122.GA27775@kroah.com>
From:   Nikolai Kondrashov <Nikolai.Kondrashov@redhat.com>
Message-ID: <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
Date:   Mon, 26 Aug 2019 11:23:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190825144122.GA27775@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 26 Aug 2019 08:24:06 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/25/19 5:41 PM, Greg KH wrote:
> On Sun, Aug 25, 2019 at 10:37:26AM -0400, CKI Project wrote:
>> Merge testing
>> -------------
>>
>> We cloned this repository and checked out the following commit:
>>
>>    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>>    Commit: f7d5b3dc4792 - Linux 5.2.10
>>
>>
>> We grabbed the cc88f4442e50 commit of the stable queue repository.
>>
>> We then merged the patchset with `git am`:
>>
>>    keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
> 
> That file is not in the repo, I think your system is messed up :(

Sorry for the trouble, Greg, but I think it's a race between the changes to
the two repos.

The job which triggered this message was started right before the moment this
commit was made:

     https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=af2f46e26e770b3aa0bc304a13ecd24763f3b452

At that moment, the repo was still on this commit, about five hours old:

     https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=cc88f4442e505e9f1f21c8c119debe89cbf63ab2

which still had the file. And when the job finished, and the message reached
you, yes, the repo no longer contained it.

At the moment the job started, the latest commit to stable/linux.git
was about 22 minutes old:

     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f7d5b3dc4792a5fe0a4d6b8106a8f3eb20c3c24c

and the repo already contained the patches from the queue, including the one
the job tried to merge:

     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f820ecf609cc38676071ec6c6d3e96b26c73b747

IIRC, we agreed to not start testing both of the repos until the latest
commits are at least 5 minutes old. In this situation the latest commit was 22
minutes old, so the system started testing.

We could increase the window to, say, 30 minutes (or something else), to avoid
misfires like this, but then the response time would be increased accordingly.

It's your pick :)

Nick
