Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB6922FDE4
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgG0Xbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Xbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:31:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CB620809;
        Mon, 27 Jul 2020 23:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892696;
        bh=3WgOruOKzCSuzhkkhtjKIh8EczQGKvyOznv0UR13wA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zmqIbNd+qEmNo/XqbC3rfdu0JXJaGEwSp8aMRgMUPt42CQabXbvH4hsNLsHxtkFZu
         5EDzecX2WfqeeCPihvDpw1525g6f6V75oab3La1CZPsJEojbizc4LktsQBl5oMG6/D
         4XyRG/2/zgYN8LGHfqfNTZK4mYpXlIFbTrgDs+3o=
Date:   Mon, 27 Jul 2020 19:31:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4.19 84/86] dm integrity: fix integrity recalculation
 that is improperly skipped
Message-ID: <20200727233135.GL406581@sasha-vm>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134918.614819996@linuxfoundation.org>
 <20200727205635.t23z72lkdofoewi3@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200727205635.t23z72lkdofoewi3@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 10:56:35PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> commit 5df96f2b9f58a5d2dc1f30fe7de75e197f2c25f2 upstream.
>>
>> Commit adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 ("dm: report suspended
>> device during destroy") broke integrity recalculation.
>>
>> The problem is dm_suspended() returns true not only during suspend,
>> but also during resume. So this race condition could occur:
>> 1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
>> 2. integrity_recalc (&ic->recalc_work) preempts the current thread
>> 3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
>> 4. integrity_recalc exits and no recalculating is done.
>>
>> To fix this race condition, add a function dm_post_suspending that is
>> only true during the postsuspend phase and use it instead of
>> dm_suspended().
>>
>> Signed-off-by: Mikulas Patocka <mpatocka redhat com>
>
>Something is wrong with signoff here...

Heh, and the same thing happened with the stable tag:

	Cc: stable vger kernel org # v4.18+

But given that this is the way the upstream commit looks like we can't
do much here.

-- 
Thanks,
Sasha
