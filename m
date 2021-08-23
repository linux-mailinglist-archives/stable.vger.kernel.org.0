Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA763F5325
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 00:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhHWWCx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 23 Aug 2021 18:02:53 -0400
Received: from foss.arm.com ([217.140.110.172]:57484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233042AbhHWWCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 18:02:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CA611042;
        Mon, 23 Aug 2021 15:02:10 -0700 (PDT)
Received: from [127.0.0.1] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D198B3F766;
        Mon, 23 Aug 2021 15:02:09 -0700 (PDT)
Date:   Mon, 23 Aug 2021 23:02:05 +0100
From:   Steven Price <steven.price@arm.com>
To:     dri-devel@lists.freedesktop.org,
        Alyssa Rosenzweig <alyssa@collabora.com>
CC:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] drm/panfrost: Clamp lock region to Bifrost minimum
User-Agent: K-9 Mail for Android
In-Reply-To: <YSQPiQX8IOkJJSoY@maud>
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com> <20210820213117.13050-4-alyssa.rosenzweig@collabora.com> <818b1a15-ddf4-461b-1d6a-cea539deaf76@arm.com> <YSQPiQX8IOkJJSoY@maud>
Message-ID: <FA069E32-03E1-4193-8918-C750A4ECE5F8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23 August 2021 22:13:45 BST, Alyssa Rosenzweig <alyssa@collabora.com> wrote:
>> > When locking a region, we currently clamp to a PAGE_SIZE as the minimum
>> > lock region. While this is valid for Midgard, it is invalid for Bifrost,
>> 
>> While the spec does seem to state it's invalid for Bifrost - kbase
>> didn't bother with a lower clamp for a long time. I actually think this
>> is in many ways more of a spec bug: i.e. implementation details of the
>> round-up that the hardware does. But it's much safer following the spec
>> ;) And it seems like kbase eventually caught up too.
>
>Yeah, makes sense. Should I drop the Cc: stable in that case? If the
>issue is purely theoretical.

I think it might still be worth fixing. Early Bifrost should be fine, but something triggered a bug report that caused kbase to be fixed, so I'm less confident that there's nothing out there that cares. Following both kbase and the spec seems the safest approach.

Thanks,
Steve
