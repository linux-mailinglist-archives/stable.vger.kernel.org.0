Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587516474E7
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 18:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLHRQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 12:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLHRQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 12:16:06 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06547DA7C;
        Thu,  8 Dec 2022 09:16:04 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p3KV8-0003yK-TT; Thu, 08 Dec 2022 18:16:02 +0100
Message-ID: <e2a77778-7a2b-2811-95ff-be67a44afceb@leemhuis.info>
Date:   Thu, 8 Dec 2022 18:16:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Content-Language: en-US, de-DE
To:     Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu> <20221208091523.t6ka6tqtclcxnsrp@quack3>
 <Y5IFR4K9hO8ax1Y0@mit.edu>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Y5IFR4K9hO8ax1Y0@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1670519765;a7663b8f;
X-HE-SMSGID: 1p3KV8-0003yK-TT
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.12.22 16:39, Theodore Ts'o wrote:
> On Thu, Dec 08, 2022 at 10:15:23AM +0100, Jan Kara wrote:
>>> Furthermore, the fix which Jan provided, and which apparently fixes
>>> the user's problem, (a) doesn't touch the ext4_bmap function, and (b)
>>> has a fixes tag for the patch:
>>>
>>>     Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
>>>
>>> ... which is a commit which dates back to 2016, and the v4.6 kernel.  ?!?
>>
>> Yes. AFAICT the bitfield race in mbcache was introduced in this commit but
>> somehow ext4 was using mbcache in a way that wasn't tripping the race.
>> After 65f8b80053 ("ext4: fix race when reusing xattr blocks"), the race
>> became much more likely and users started to notice...
> 
> Ah, OK.  And 65f8b80053 landed in 6.0, so while the bug may have been
> around for much longer, this change made it much more likely that
> folks would notice.  That's the missing piece and why Microsoft
> started noticing this in their "Flatcar" container kernel.

Yeah, likely when 65f8b80053 was backported to 5.15.y in 1be97463696c

> So I'll update the commit description so that this is more clear,

Thx for taking care of this, I'm glad this is on track now.

Maybe I should talk to Greg again to revert backported changes like
1be97463696c until fixes for them are ready.

> and
> then I can figure out how to tell the regression-bot that the
> regression should be tracked using commit 65f8b80053 instead of
> 51ae846cff5 ("ext4: fix warning in ext4_iomap_begin as race between
> bmap and write").

FWIW, there is no strong need to, nobody looks at those details once the
regression is fixed. But yeah, that might change over time, so let me
take care of that:

#regzbot introduced: 65f8b80053

[normally things like that have to be done as a direct or indirect reply
to the report, but regzbot knows (famos last words...) how to associate
this command with the report, as the patch that started this thread
linked to the report using a Link: tag].

Ciao, Thorsten
