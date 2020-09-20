Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65F22714C4
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 16:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgITOFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 10:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgITOFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Sep 2020 10:05:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0675C2073A;
        Sun, 20 Sep 2020 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600610749;
        bh=DWXjZLxc4sinwtGYqBALJFxo6CL3HHXILazarm/+YLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YV6jxANRUQeVNcE2GHkgkbcb8jagfCP2dx1TFmDc/pyoVwrIaBRnmot5mAXRKaJfU
         TCKFCMpvJoRGKEn6t5N9ZLnIN2IfOgizkRZ9wvQuvrThmftpd0yVhUvjK9qx9PAMLx
         /f8kRxYR5wg2rcYFrWgjPFk7ojnEnctGP65fX8yI=
Date:   Sun, 20 Sep 2020 10:05:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH AUTOSEL 4.14 09/15] kobject: Drop unneeded conditional in
 __kobject_del()
Message-ID: <20200920140548.GL2431@sasha-vm>
References: <20200914130526.1804913-1-sashal@kernel.org>
 <20200914130526.1804913-9-sashal@kernel.org>
 <20200914141318.GA3357018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200914141318.GA3357018@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 04:13:18PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Sep 14, 2020 at 09:05:20AM -0400, Sasha Levin wrote:
>> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> [ Upstream commit 07ecc6693f9157cf293da5d165c73fb28fd69bf4 ]
>>
>> __kobject_del() is called from two places, in one where kobj is dereferenced
>> before and thus can't be NULL, and in the other the NULL check is done before
>> call. Drop unneeded conditional in __kobject_del().
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Link: https://lore.kernel.org/r/20200803083520.5460-1-andriy.shevchenko@linux.intel.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  lib/kobject.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index bbbb067de8ecd..e02f1bb67c99f 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -568,9 +568,6 @@ void kobject_del(struct kobject *kobj)
>>  {
>>  	struct kernfs_node *sd;
>>
>> -	if (!kobj)
>> -		return;
>> -
>>  	sd = kobj->sd;
>>  	sysfs_remove_dir(kobj);
>>  	sysfs_put(sd);
>> --
>> 2.25.1
>>
>
>Ouch, no, this patch should not be backported ANYWHERE or bad things
>will happen.
>
>Please drop from all AUTOSEL trees.

Dropped, thanks!

-- 
Thanks,
Sasha
