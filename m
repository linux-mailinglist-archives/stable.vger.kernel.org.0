Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9576C3115B4
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBEWjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:39:17 -0500
Received: from mail.as201155.net ([185.84.6.188]:37157 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhBEOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:02:46 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2021 09:02:44 EST
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:54738 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1l81au-0005uJ-0o; Fri, 05 Feb 2021 14:56:20 +0100
X-CTCH-RefID: str=0001.0A782F1F.601D4E84.0044,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=Rf+HCZnVCxrSyqvS0/esXCFSgmlBe9x1otRSFfy9SyM=;
        b=oNjIY3+lWy5k6RzTfn3vekGFgXCTwSxguNHVhT07NXhDuRkj7k7csiebHmTurkWB5arjM9aXolXlktydtWIeKO4NCJrvOIUKvPexIfe9YPS+UYT8GtXkLtgWGY8IG3KMicjmzXphH/ldaWQoA5mh/dTrZ/+90dZMYj+sgq1siAo=;
Message-ID: <c4f17a35-9254-7275-375a-7f85b54a2ece@dd-wrt.com>
Date:   Fri, 5 Feb 2021 14:56:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101
 Thunderbird/86.0
Subject: Re: [PATCH 4.4 00/12] Futex back-port from v4.9
To:     Greg KH <greg@kroah.com>, Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
References: <20210201151214.2193508-1-lee.jones@linaro.org>
 <YBgdRJxWt8Y1Oog2@kroah.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
In-Reply-To: <YBgdRJxWt8Y1Oog2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [81.201.155.134] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1l81at-0000MF-Un; Fri, 05 Feb 2021 14:56:19 +0100
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

if CONFIG_FUTEX is not set

kernel/fork.c: In function 'exit_mm_release':
kernel/fork.c:1121:2: error: implicit declaration of function 
'futex_exit_release'; did you mean 'mutex_release'? 
[-Werror=implicit-function-declaration]
 1121 |  futex_exit_release(tsk);
      |  ^~~~~~~~~~~~~~~~~~
      |  mutex_release
kernel/fork.c: In function 'exec_mm_release':
kernel/fork.c:1127:2: error: implicit declaration of function 
'futex_exec_release'; did you mean 'mutex_release'? 
[-Werror=implicit-function-declaration]
 1127 |  futex_exec_release(tsk);
      |  ^~~~~~~~~~~~~~~~~~
      |  mutex_release
kernel/fork.c: In function 'copy_process':
kernel/fork.c:1705:2: error: implicit declaration of function 
'futex_init_task'; did you mean 'rt_mutex_init_task'? 
[-Werror=implicit-function-declaration]
 1705 |  futex_init_task(p);
      |  ^~~~~~~~~~~~~~~
      |  rt_mutex_init_task
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:304: kernel/fork.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      mm/mempool.o
  CC      fs/open.o
kernel/exit.c: In function 'do_exit':
kernel/exit.c:788:3: error: implicit declaration of function 
'futex_exit_recursive' [-Werror=implicit-function-declaration]
  788 |   futex_exit_recursive(tsk);
      |   ^~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Am 01.02.2021 um 16:24 schrieb Greg KH:
> On Mon, Feb 01, 2021 at 03:12:02PM +0000, Lee Jones wrote:
>> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt
>>
>> This set required 1 additional patch dragged back from v4.14 to avoid build errors.
>>
> Many thanks for these, now all queued up!
>
> greg k-h
>
