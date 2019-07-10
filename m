Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10ED6483F
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 16:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfGJOYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 10:24:21 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:59424 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbfGJOYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 10:24:21 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 84F472E148C;
        Wed, 10 Jul 2019 17:24:17 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id P99c9oXlfq-OGtaLe0V;
        Wed, 10 Jul 2019 17:24:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1562768657; bh=uyHdLmnNK6wDjc0FbiZHSr4crktRu3Qh+meXtiizJCA=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=pVHBABQlzV1NxxP+TDNxdXd1oAjFvsQubsq0/n8lPjX7gYejh2cdj9CGgt87MAY6s
         oV89O1eIFr9zBpXb+vmGuEaQ/JhiseBjUArrxtZha1U1f24xbfMEXZUj9hivWwmsgX
         aOBxGayo32RadXonR90WJBUiMFD2Im4fEaqsOwXY=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:fce8:911:2fe8:4dfb])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id wy86eJmWtT-OGw4BaM7;
        Wed, 10 Jul 2019 17:24:16 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH] blk-throttle: fix zero wait time for iops throttled group
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, stable@vger.kernel.org
References: <156259979778.2486.6296077059654653057.stgit@buzz>
 <30caacb5-4d45-016b-a97d-db8b37010218@kernel.dk>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <f4be51ff-e426-cc44-db94-3c26e2cfbca9@yandex-team.ru>
Date:   Wed, 10 Jul 2019 17:24:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <30caacb5-4d45-016b-a97d-db8b37010218@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.2019 17:00, Jens Axboe wrote:
> On 7/8/19 9:29 AM, Konstantin Khlebnikov wrote:
>> After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
>> limit is enforced") wait time could be zero even if group is throttled and
>> cannot issue requests right now. As a result throtl_select_dispatch() turns
>> into busy-loop under irq-safe queue spinlock.
>>
>> Fix is simple: always round up target time to the next throttle slice.
> 
> Applied, thanks. In the future, please break lines at 72 chars in
> commit messages, I fixed it up.
> 

Ok, but Documentation/process/submitting-patches.rst and
scripts/checkpatch.pl recommends 75 chars per line.
