Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED6202DCD
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 02:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgFVAHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 20:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgFVAHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 20:07:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333F424954;
        Mon, 22 Jun 2020 00:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592784422;
        bh=b6aXNGIeBta3+bmIav8PwZcjpEFB8BDGe5CiRWg9Lxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5HW5DDcHJQsWxzpUXQPX8TtJK20DRZ3tBixnhs3IFTOgQ+pIB7DaGjXiJsd2L3H/
         5zqtWPOOVHnTw+rc+FdRvDOzf6XgUtMqekObx7wr2c9hdtdCMJ10yuImehD1HQxgrn
         Fm9MUvqDyEYWskwZibh28GCyH2+2yLH3jd5BTJVA=
Date:   Sun, 21 Jun 2020 20:07:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 03/60] iio: light: isl29125: fix
 iio_triggered_buffer_{predisable,postenable} positions
Message-ID: <20200622000701.GD1931@sasha-vm>
References: <20200618013004.610532-1-sashal@kernel.org>
 <20200618013004.610532-3-sashal@kernel.org>
 <20200619173101.000045a2@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200619173101.000045a2@Huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 05:31:01PM +0100, Jonathan Cameron wrote:
>On Wed, 17 Jun 2020 21:29:07 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
>>
>> [ Upstream commit 9b7a12c3e090cf3fba6f66f1f23abbc6e0e86021 ]
>>
>> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
>> the poll functions.
>>
>> For the predisable hook, the disable code should occur before detaching
>> the poll func, and for the postenable hook, the poll func should be
>> attached before the enable code.
>>
>> This change reworks the predisable/postenable hooks so that the pollfunc is
>> attached/detached in the correct position.
>> It also balances the calls a bit, by grouping the preenable and the
>> iio_triggered_buffer_postenable() into a single
>> isl29125_buffer_postenable() function.
>>
>
>This is really part of some rework.  It doesn't 'fix' a bug
>as such (I think), but rather a bit of logical inconsistency.
>
>Shouldn't do any harm though beyond adding noise to stable.
>I added notes to some of these to mark them as not stable material,
>but clearly missed this one. Sorry about that.

I'll drop it, thanks!

-- 
Thanks,
Sasha
