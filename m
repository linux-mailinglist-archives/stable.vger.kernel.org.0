Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D351200D1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 10:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfLPJSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 04:18:51 -0500
Received: from mail1.ugh.no ([178.79.162.34]:51510 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfLPJSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 04:18:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 54E8A24E3BA;
        Mon, 16 Dec 2019 10:18:49 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cDpM2SCLA60o; Mon, 16 Dec 2019 10:18:48 +0100 (CET)
Received: from [10.255.64.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 9C9ED24E3B3;
        Mon, 16 Dec 2019 10:18:48 +0100 (CET)
Subject: Re: [PATCH 4.19 153/306] block: fix the DISCARD request merge
 (4.19.87+ crash)
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203126.845809286@linuxfoundation.org>
 <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net>
 <CA+res+RtrAOfiVLeg1QE7V1Xjs6029y3tVmh0vfy+B71_bhsUw@mail.gmail.com>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <4d8343e0-f38a-3e08-edf6-3346b3011ddf@tomt.net>
Date:   Mon, 16 Dec 2019 10:18:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+res+RtrAOfiVLeg1QE7V1Xjs6029y3tVmh0vfy+B71_bhsUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.12.2019 08:42, Jack Wang wrote:
> Andre Tomt <andre@tomt.net> 于2019年12月14日周六 下午3:24写道：
>>
>> 4.19.87, 4.19.88, 4.19.89 all lock up frequently on some of my systems.
>> The same systems run 5.4.3 fine, so the newer trees are probably OK.
>> Reverting this commit on top of 4.19.87 makes everything stable.
>>
>> To trigger it all I have to do is re-rsyncing a directory tree with some
>> changed files churn, it will usually crash in 10 to 30 minutes.
>>
>> The systems crashing has ext4 filesystem on a two ssd md raid1 mounted
>> with the mount option discard. If mounting it without discard, the
>> crashes no longer seem to occur.
>>
>> No oops/panic made it to the ipmi console. I suspect the console is just
>> misbehaving and it didnt really livelock. At one point one line of the
>> crash made it to the console (kernel BUG at block/blk-core.c:1776), and
>> it was enough to pinpoint this commit. Note that the line number might
>> be off, as I was attempting a bisect at the time.
>>
>> This commit also made it to 4.14.x, but I have not tested it.
> Hi Andre,
> 
> I noticed one fix is missing for discard merge in 4.19.y
> 2a5cf35cd6c5 ("block: fix single range discard merge")
> 
> Can you try if it helps? just "git cherry-pick 2a5cf35cd6c5"

Indeed, adding this commit on top a clean 4.19.89 fixes the issue. So 
far survived about an hour of rsyncing file churn.

