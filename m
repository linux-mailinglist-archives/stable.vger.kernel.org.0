Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB78317E86
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfEHQxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 12:53:04 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:46444 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfEHQxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 12:53:04 -0400
Received: from [81.155.195.4] (helo=[192.168.1.118])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1hOPoT-0001Zo-3p; Wed, 08 May 2019 17:53:01 +0100
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     "Guilherme G. Piccoli" <guilherme@gpiccoli.net>,
        Song Liu <liu.song.a23@gmail.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com>
 <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
 <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
 <5CD2A172.4010302@youngman.org.uk>
 <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5CD3096B.4030302@youngman.org.uk>
Date:   Wed, 8 May 2019 17:52:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/05/19 15:52, Guilherme G. Piccoli wrote:
> Hi, I understand your concern. But all other raid levels contains
> failure-event mechanisms. For example, in all my tests with raid5 or
> raid1, it first complained the device was removed, then it failed in
> super_written() when no other available device was present.
> On the other hand, raid0 does "blind-writes": it just selects the device
> in which that bio should be written (given the stripe math) and change
> the bio's device, sending it back via generic_make_request(). It's
> dummy, but not in a bad way, but rather for performance reasons. It has
> no "intelligence" for failures, as all other raid levels.
> 
> That said, we could fix md.c for all raid levels, but I personally think
> it's a bazooka shot, only raid0 shows consistently this issue.
> 
The academic in me says we should push that error handling into
generic_make_request() or some raid function in md.c that deals with
those problems. Sounds like there's a fair bit of duplicate
functionality that could be re-factored out.
>>
>> Academic purity versus engineering practicality :-)
> 
> Heheh you have good points here! Thanks for the input =)
> Cheers,
> 
Doesn't help when there's not an architect to design an overall "grand
scheme", but my usual way of working is to design top down academically,
and then ask myself "what do I need" before implementing bottom-up.
Hopefully with a load of documentation saying "I haven't done this
because I don't need it, but this is where it goes".

Cheers,
Wol

