Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C906C16903C
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 17:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBVQWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 11:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgBVQWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 11:22:10 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5926206ED;
        Sat, 22 Feb 2020 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582388529;
        bh=kCtcl/dI+voA/1hcf1fPW0ZK0AQVr3DV06cFFUIwzO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZUHDgUkNTo+8MJM15VC2XCkR0KekLKB9BpvrWYNHowv3iXgrA86UvXYDkhjsWNd3
         7agwkvIUwAUNWPxiGLfhGT/KalvjpyuT1xOhvyBsdlpqnd6/fE1L/tZYybdYK4iKpQ
         P+syN/ieUplr1ul9XxaFZ97Q35ZBRa3IOvyjaMYY=
Date:   Sat, 22 Feb 2020 11:22:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steve French <stfrench@microsoft.com>,
        Oleg Kravtsov <oleg@tuxera.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: Re: [PATCH 4.19 188/191] cifs: log warning message (once) if out of
 disk space
Message-ID: <20200222162208.GA26320@sasha-vm>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072313.381537875@linuxfoundation.org>
 <20200222125931.GC14067@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200222125931.GC14067@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 01:59:31PM +0100, Pavel Machek wrote:
>On Fri 2020-02-21 08:42:41, Greg Kroah-Hartman wrote:
>> From: Steve French <stfrench@microsoft.com>
>>
>> [ Upstream commit d6fd41905ec577851734623fb905b1763801f5ef ]
>>
>> We ran into a confusing problem where an application wasn't checking
>> return code on close and so user didn't realize that the application
>> ran out of disk space.  log a warning message (once) in these
>> cases. For example:
>>
>>   [ 8407.391909] Out of space writing to \\oleg-server\small-share
>
>Out of space can happen on any filesystem, and yes, it can be
>confusing. But why is cifs so special that we warn here (and not

cifs isn't special, we tend to take this type of patches that address
usability issues. Here's an example of a similar patch for btrfs from
the previous release (3 days ago):

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=eb7a7968c9ee183def1d727d4bb209c701fe402a
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=f7447ff1d58a590e4b04479d1209fcee253a96d7

>elsewhere) and why was this marked for stable?

Reading the patch description, it describes a bug that happened because
of lacking kernel feedback.

-- 
Thanks,
Sasha
