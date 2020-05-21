Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B11DDB0D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgEUXdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgEUXdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:33:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12EE207F9;
        Thu, 21 May 2020 23:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590104017;
        bh=TTXDeIznmIIlZXV9EcNFfCAfuo/5Y/87PKwV9vgyTNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YeAwyYizXUT2Nl2OXXNPY1pN/x0YNE/Plzx3mF9Ug/5Rb8CzoquPb4cco++5c9iqm
         hkUOvhNQAUzRuctDcGrdRytLI/ImjUb745XNB8BH24bIS8jpUaiK6rJq/pgDCRp09+
         yC40nXZc1uAsYs0g/VBHqdLGlptwU7qeY6C4h3I0=
Date:   Thu, 21 May 2020 19:33:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] i2c: dev: Fix the race between the release of i2c_dev
 and cdev
Message-ID: <20200521233335.GI33628@sasha-vm>
References: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
 <20200521055011.GA2330588@kroah.com>
 <1d4004d71924fa2e4c422ae086166c280e5b43be.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1d4004d71924fa2e4c422ae086166c280e5b43be.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 09:58:57PM +0100, Ben Hutchings wrote:
>On Thu, 2020-05-21 at 07:50 +0200, Greg Kroah-Hartman wrote:
>> On Wed, May 20, 2020 at 08:45:15PM +0100, Ben Hutchings wrote:
>> > Please pick this fix for all stable branches:
>> >
>> > commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6
>> > Author: Kevin Hao <haokexin@gmail.com>
>> > Date:   Fri Oct 11 23:00:14 2019 +0800
>> >
>> >     i2c: dev: Fix the race between the release of i2c_dev and cdev
>> >
>> > I don't know whether it will apply cleanly to all of them; I can deal
>> > with those where it doesn't.
>>
>> I applied it to 4.14, 4.19, 5.4, and 5.6.  It does apply to 4.9 but as
>> the patch it depends on is not there, I don't think it will help.
>
>It was included in 4.9.224, so both this and the similar watchdog fix
>should be applicable for 4.9.

I took it for 4.9, haven't noticed any issues.

I don't think it applies to 4.4 though as we don't have:

	d6760b14d4a1 ("i2c: dev: switch from register_chrdev to cdev API")

I did notice 3 other commits which I've taken in:

	5136ed4fcb05 ("i2c-dev: don't get i2c adapter via i2c_dev")
	e6be18f6d62c ("i2c: dev: use after free in detach")
	72a71f869c95 ("i2c: dev: don't start function name with	'return'")

-- 
Thanks,
Sasha
