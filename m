Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3513D1228
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhGUOi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 10:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238083AbhGUOiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 10:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9D861245;
        Wed, 21 Jul 2021 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880742;
        bh=iyJmmnRrmq3NjJ0o9+o2VxFl1R0JWz/x6crIEc3pGdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bztUAqqMxqi/SzVRjgbhD2sJ8CieKxas0xnNwFaILxOp3EoCBq3Waf/Va5tII0mwJ
         4wdTIg4KizMLZcLI/V38eZAAgf7a8gxfkS8ScDn5xK5w0XGb3f9qtGahOTvZ7d4Bk4
         cVrnyNhrO9KsGeSo4aoMC+Q3PN2E19SIWeC6YO/bkFflFZgjpgu1xKzo545Vg5+hc2
         2yhnpji+iBW9SIO9Vc5GQ/FNNS5C2/+l8hUhBbp4D23zSZGkPDzQs5/BLbBvJd9mrb
         zUJ987dbD9oYOQFoS5FSU0Ivex0N53tYBs0cJV09Euxnsh19p7ENC96XMFMLzj+Jeo
         jRKH1gb/918nw==
Date:   Wed, 21 Jul 2021 11:19:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wysochanski <dwysocha@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: [PATCH 5.10 147/243] NFSD: Fix TP_printk() format specifier in
 nfsd_clid_class
Message-ID: <YPg65XyiPf+A/2yi@sashalap>
References: <20210719144940.904087935@linuxfoundation.org>
 <20210719144945.657682587@linuxfoundation.org>
 <20210720214847.GB704@amd>
 <20210721100413.227fd0cb@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210721100413.227fd0cb@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 10:04:13AM -0400, Steven Rostedt wrote:
>On Tue, 20 Jul 2021 23:48:47 +0200
>Pavel Machek <pavel@denx.de> wrote:
>
>> Hi!
>>
>> > [ Upstream commit a948b1142cae66785521a389cab2cce74069b547 ]
>> >
>> > Since commit 9a6944fee68e ("tracing: Add a verifier to check string
>> > pointers for trace events"), which was merged in v5.13-rc1,
>> > TP_printk() no longer tacitly supports the "%.*s" format specifier.
>> >
>> > These are low value tracepoints, so just remove them.
>>
>> So I understand we want this for mainline, but AFAICT 5.10 does not
>> have 9a6944fee68e ("tracing: Add a verifier to check string pointers
>> for trace events") commit, so this does not fix any bug and removal of
>> tracepoints can be surprising.
>>
>
>Thanks for pointing this out. I get so many stable patches, I don't
>have time to look at all of them.
>
>Greg, I don't think this should be backported. The verifier code had a
>bug in it that broke the '%.*s' formats. This patch removed the good
>code because of the broken code.
>
>See eb01f5353bdaa ("tracing: Handle %.*s in trace_check_vprintf()")

Uh, yes, I'll drop it. Thanks for catching this!

-- 
Thanks,
Sasha
