Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABE2326616
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 18:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBZRGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 12:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhBZRGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 12:06:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AADA64EEE;
        Fri, 26 Feb 2021 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614359154;
        bh=pS0c6BwAKO3ZjluaXv1iRIncVUi4cLS3BtdLS4xBl1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYW97vfBxwyIJC3LI6Bo+bbN81aYChOrzDRcDFF4KcMJ6XXu/fyXlIGBy2sMURUvs
         iCcslhVW/RtaSyebIs5i9HzYPlgiSEIPX0maW26wowsVgVXV2Y60zbRN9R7TDqj//s
         f1AtZtSoBFFAWjc8I/l59rDVAHLNJ8XD3d/1j2PY836c/TJuwz3LD8GKjIXBDRRqKk
         3rsLNjBueLB2l3HEWN/GKnQ01ZVLiOJ5OGFwDU/aPLUSqlXmnXIMS340ToOtBb96OY
         s5//0MX13QizRySjeNUdMiJ7SXrlV9MCw7LQfWiYg9R76v6N7mBqvJgg5GbL3OLPyb
         dLDzLLOPMaM3g==
Date:   Fri, 26 Feb 2021 12:05:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 50/67] Drivers: hv: vmbus: Initialize memory
 to be sent to the host
Message-ID: <20210226170553.GB473487@sasha-vm>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-50-sashal@kernel.org>
 <20210224131457.GA1920@anparri>
 <20210224133052.GA2058@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210224133052.GA2058@anparri>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 02:30:52PM +0100, Andrea Parri wrote:
>On Wed, Feb 24, 2021 at 02:16:00PM +0100, Andrea Parri wrote:
>> On Wed, Feb 24, 2021 at 07:50:08AM -0500, Sasha Levin wrote:
>> > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
>> >
>> > [ Upstream commit e99c4afbee07e9323e9191a20b24d74dbf815bdf ]
>> >
>> > __vmbus_open() and vmbus_teardown_gpadl() do not inizialite the memory
>> > for the vmbus_channel_open_channel and the vmbus_channel_gpadl_teardown
>> > objects they allocate respectively.  These objects contain padding bytes
>> > and fields that are left uninitialized and that are later sent to the
>> > host, potentially leaking guest data.  Zero initialize such fields to
>> > avoid leaking sensitive information to the host.
>> >
>> > Reported-by: Juan Vazquez <juvazq@microsoft.com>
>> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
>> > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>> > Link: https://lore.kernel.org/r/20201209070827.29335-2-parri.andrea@gmail.com
>> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Sasha - This patch is one of a group of patches where a Linux guest running on
>> Hyper-V will start assuming that hypervisor behavior might be malicious, and
>> guards against such behavior.  Because this is a new assumption, these patches
>> are more properly treated as new functionality rather than as bug fixes.  So I
>> would propose that we *not* bring such patches back to stable branches.
>
>For future/similar cases: I'm wondering, is there some way to annotate a patch
>with "please do not bring it back"?

There's nothing explicit for the AUTOSEL stuff. A note in the changelog
could work.

-- 
Thanks,
Sasha
