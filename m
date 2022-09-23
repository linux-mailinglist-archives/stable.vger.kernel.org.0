Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995E35E751E
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 09:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiIWHq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 03:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiIWHqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 03:46:32 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8F7AC16;
        Fri, 23 Sep 2022 00:46:26 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1obdOC-0001G0-LO; Fri, 23 Sep 2022 09:46:24 +0200
Message-ID: <d9a3460b-0ed6-4bfa-5bdd-032f4bc4ebce@leemhuis.info>
Date:   Fri, 23 Sep 2022 09:46:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
References: <f6755107-b62c-a388-0ab5-0a6633bf9082@garloff.de>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        Kurt Garloff <kurt@garloff.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>
Subject: Re: linux-5.15.69 breaks nfs client
In-Reply-To: <f6755107-b62c-a388-0ab5-0a6633bf9082@garloff.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663919186;60e90cd8;
X-HE-SMSGID: 1obdOC-0001G0-LO
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. CCing the regression
mailing list, as it should be in the loop for all regressions, as
explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
Also CCing the stable ml, the NFS maintainers, and the authors of
31b992b3c39b, too.

On 22.09.22 23:46, Kurt Garloff wrote:
> 
> a freshly compiled 5.15.69 kernel showed hangs with NFS.
> Typically mkdir would end up in a 'D' process state, but I
> have seen ls -l hanging as well.
> Server is kernel NFS 5.15.69.
> 
> After reverting the last three NFS related commits,
> a68a734b19af NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests
> 3b97deb4abf5 NFS: Fix another fsync() issue after a server reboot
> 31b992b3c39b NFS: Save some space in the inode
> 
> things work normally again.
> 
> As you can see, I suspected 31b992b3c39b ...

FWIW, that's e591b298d7ec in mainline.

> I know this report is light on details; if nothing like this has been
> reported yet, let me know and I'll try to find some time to investigate
> further.
> 
> PS: Please keep me on Cc, I'm not subscribed to linux-nfs.

I wonder if this is this is a dup of this report:

https://lore.kernel.org/all/c5d8485b-0dbc-5192-4dc6-10ef2b86b520@molgen.mpg.de/

In that thread Trond mentioned
```
I believe this is a dependency that was introduced by the back port of
commit e591b298d7ec ("NFS: Save some space in the inode") into 5.15.68.
So the reason it wasn't seen is because the change is very recent.

FYI Greg and Sasha: please also consider pulling 6e176d47160c ("NFSv4:
Fixes for nfs4_inode_return_delegation()") into that stable series.
```

Anyway, for the rest of this mail:
[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 31b992b3c39b
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; above webpage explains why this is
important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
