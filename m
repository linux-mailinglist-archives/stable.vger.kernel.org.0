Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA612E9E00
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 20:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhADTMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 14:12:34 -0500
Received: from mail1.ugh.no ([178.79.162.34]:53764 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbhADTMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 14:12:34 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2021 14:12:33 EST
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 7B0D42538B6;
        Mon,  4 Jan 2021 20:04:10 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qqLuc-hxzn-r; Mon,  4 Jan 2021 20:04:09 +0100 (CET)
Received: from [IPv6:2a0a:2780:4d57:40:54fd:5612:86a2:2c2f] (unknown [IPv6:2a0a:2780:4d57:40:54fd:5612:86a2:2c2f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 4A6DD2538FB;
        Mon,  4 Jan 2021 20:04:09 +0100 (CET)
Subject: Re: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
 resume
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125051.444911072@linuxfoundation.org>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <e5d9703f-42a4-f154-cf13-55a3eba10859@tomt.net>
Date:   Mon, 4 Jan 2021 20:04:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201228125051.444911072@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.12.2020 13:50, Greg Kroah-Hartman wrote:
> From: Stylon Wang <stylon.wang@amd.com>
> 
> commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.
> 
> EDID parsing in S3 resume pushes new display modes
> to probed_modes list but doesn't consolidate to actual
> mode list. This creates a race condition when
> amdgpu_dm_connector_ddc_get_modes() re-initializes the
> list head without walking the list and results in  memory leak.

This commit is causing me problems on 5.10.4: when I turn off the 
display (a LG TV in this case), and turn it back on again later there is 
no video output and I get the following in the kernel log:

[ 8245.259628] [drm:dm_restore_drm_connector_state [amdgpu]] *ERROR* 
Restoring old state failed with -12

I've found another report on this commit as well:
https://bugzilla.kernel.org/show_bug.cgi?id=211033

And I suspect this is the same:
https://bugs.archlinux.org/task/69202

Reverting it from 5.10.4 makes things behave again.

Have not tested 5.4.86 or 5.11-rc.

I'm using a RX570 Polaris based card.
