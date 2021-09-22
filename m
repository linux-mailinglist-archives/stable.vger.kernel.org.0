Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A041413FF4
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 05:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhIVDTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 23:19:47 -0400
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:44178 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230054AbhIVDTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 23:19:47 -0400
X-Greylist: delayed 7564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 23:19:46 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 18M14RMp018835;
        Tue, 21 Sep 2021 18:12:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=20180706;
 bh=zZZFHkUmg/mGDmtSyh4MrjFB8Z7qNYtR8PonpEq7USA=;
 b=iJL264QiDhTBzZFxiC3gf3zZ5q/emvbG3mLrHbjXtUpAKrcWFIKK81rX13N9EwACdP3w
 5P55ZsilvYyakLakjbO6g9vzs3XttXepiG3p5gck1sEQppLZQcqW12StzS8oNhWJsI4B
 duQ0y/6rQt80jIzQSRdb41hQXi8fE85Lhln/Z60EgeVWGJZsY2M3vNaVbY7VFnnIVh2X
 7GLkGWbUKSG6w9vvG6sxkP1CRGrueReD+kyZvK0LwbE2nN5ZEW3lssLFKgymTIHTRIBa
 g1PcmZ0lLct0d4C/rc+NnLZF6IqLroVeoBONuGqDOttZcAUKf/kUOxSquOoZLGPKy6Kg uQ== 
Received: from ma-mailsvcp-mta-lapp03.corp.apple.com (ma-mailsvcp-mta-lapp03.corp.apple.com [10.226.18.135])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 3b7q70tnmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Sep 2021 18:12:10 -0700
Received: from ma-mailsvcp-mmp-lapp02.apple.com
 (ma-mailsvcp-mmp-lapp02.apple.com [17.32.222.15])
 by ma-mailsvcp-mta-lapp03.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021))
 with ESMTPS id <0QZT00G7PA0AC410@ma-mailsvcp-mta-lapp03.corp.apple.com>; Tue,
 21 Sep 2021 18:12:10 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp02.apple.com by
 ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021)) id <0QZT00U009PAHB00@ma-mailsvcp-mmp-lapp02.apple.com>; Tue,
 21 Sep 2021 18:12:10 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 8279f20af508038af8ea9fdfadf6b314
X-Va-E-CD: 2f88a753162e729d369e404b9c5b28b1
X-Va-R-CD: 1fa5f19b10e6b411cd2f116d64d67f65
X-Va-CD: 0
X-Va-ID: dc1bd214-bc11-4c2a-b694-7d2b96cf8531
X-V-A:  
X-V-T-CD: 8279f20af508038af8ea9fdfadf6b314
X-V-E-CD: 2f88a753162e729d369e404b9c5b28b1
X-V-R-CD: 1fa5f19b10e6b411cd2f116d64d67f65
X-V-CD: 0
X-V-ID: 577c2a28-5e2d-4d32-b8d7-b3b21f500e27
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-21_07:2021-09-20,2021-09-21 signatures=0
Received: from Vishnus-iPro.lan (unknown [17.168.70.240])
 by ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.9.20210415 64bit (built Apr 15
 2021)) with ESMTPSA id <0QZT00T9KA09BI00@ma-mailsvcp-mmp-lapp02.apple.com>;
 Tue, 21 Sep 2021 18:12:09 -0700 (PDT)
Subject: Re: [PATCH] fs: fix for core dumping of a process getting oom-killed
To:     Michal Hocko <mhocko@suse.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
 <YUm7LLqwrXygzKll@dhcp22.suse.cz>
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Message-id: <216745b1-2d4c-8707-2403-07117e6b3bca@apple.com>
Date:   Tue, 21 Sep 2021 20:12:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-version: 1.0
In-reply-to: <YUm7LLqwrXygzKll@dhcp22.suse.cz>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-21_07:2021-09-20,2021-09-21 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/21/21 5:59 AM, Michal Hocko wrote:
> On Mon 20-09-21 23:38:40, Vishnu Rangayyan wrote:
>>
>> Processes inside a memcg that get core dumped when there is less memory
>> available in the memcg can have the core dumping interrupted by the
>> oom-killer.
>> We saw this with qemu processes inside a memcg, as in this trace below.
>> The memcg was not out of memory when the core dump was triggered.
> 
> Why is it important to mention that the the memcg was not oom when the
> dump was triggered?
> 
>> [201169.028782] qemu-kata-syste invoked oom-killer: gfp_mask=0x101c4a(GFP_NOFS|__GFP_HIGHMEM|__GFP_HARDWALL|__GFP_MOVABLE|__GFP_WRITE),
>> order=0, oom_score_adj=-100
> [...]
>> [201169.028863] memory: usage 12218368kB, limit 12218368kB, failcnt 1728013
> 
> it obviously is for the particular allocation from the core dumping
> code.
> 
>> [201169.028864] memory+swap: usage 12218368kB, limit 9007199254740988kB, failcnt 0
>> [201169.028864] kmem: usage 154424kB, limit 9007199254740988kB, failcnt 0
>> [201169.028880] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=podacfa3d53-2068-4b61-a754-fa21968b4201,mems_allowed=0-1,oom_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task=qemu-kata-syste,pid=1887079,uid=0
>> [201169.028888] Memory cgroup out of memory: Killed process 1887079
>> (qemu-kata-syste) total-vm:13598556kB, anon-rss:39836kB, file-rss:8712kB, shmem-rss:12017992kB, UID:0 pgtables:24204kB oom_score_adj:-100
>> [201169.045201] oom_reaper: reaped process 1887079 (qemu-kata-syste), now anon-rss:0kB, file-rss:28kB, shmem-rss:12018016kB
>>
>> This change adds an fsync only for regular file core dumps based on a
>> configurable limit core_sync_bytes placed alongside other core dump params
>> and defaults the limit to (an arbitrary value) of 128KB.
>> Setting core_sync_bytes to zero disables the sync.
> 
> This doesn't really explain neither the problem nor the solution.
My apologies for not explaining better.
  Why
> is fsync helping at all? Why do we need a new sysctl to address the
> problem and how does it help to prevent the memcg OOM. Also why is this
> a problem in the first place.
The simple intent is to allow the core dumping to succeed in low memory 
situations where the dump_emit doesn't tip over the thing and trigger 
the oom-killer. This change avoids only that particular issue.
Agree, its not the actual problem at all. If the core dumping fails, 
that sometimes prevents or delays looking into the actual issue.
The sysctl was to allow disabling this behavior or to fine tune for 
special cases such as limited memory environments.
> 
> Have a look at the oom report. It says that only 8MB of the 11GB limit
> is consumed by the file backed memory. The absolute majority (98%) is
> sitting in the shmem and fsync will not help a wee bit there.
Agree.
> 
