Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE6D3CC728
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 03:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGRBoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 21:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhGRBoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 21:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 347F361159;
        Sun, 18 Jul 2021 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626572487;
        bh=y4LVREzYXxclRGUfOfs3DtOMn9JOani/4YZmmLMPFL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCmdq19Bc8PhNfD2IPG99l+CW0c+ZBQOY5y3fbcxhXSp9k/sdVKTZS39ea+0IArAU
         MQAZEsKwtKzEAx+2McLwN4qCb3sNnmmMhj/nOIg119DXb5IXwL2ndJ+9TUs+a90+XQ
         WHyLPS9MpzHt/9S7fTrNXC34d82g1lV9PWb9+J7qa1NesY0LhysoaM/Gxbzavb3ajQ
         kydnUxhnEyNIAJFIgVzjNbiCDTULO6/bS3Q2bbu/jsxOAjxWkuO0EZlC3YLMENLYDz
         0g6dAnA5OShI2zVShZrcGTX7R7ueefc/oZ1MFCYceJBf9X7+VeT+rSxVIc4QtMhRhP
         8kTUgoOWamxpw==
Date:   Sat, 17 Jul 2021 21:41:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 5.12 42/43] virtio: fix up virtio_disable_cb
Message-ID: <YPOGxjBcq6f4l+0v@sashalap>
References: <20210710234915.3220342-1-sashal@kernel.org>
 <20210710234915.3220342-42-sashal@kernel.org>
 <20210711002242-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210711002242-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 11, 2021 at 12:23:59AM -0400, Michael S. Tsirkin wrote:
>On Sat, Jul 10, 2021 at 07:49:14PM -0400, Sasha Levin wrote:
>> From: "Michael S. Tsirkin" <mst@redhat.com>
>>
>> [ Upstream commit 8d622d21d24803408b256d96463eac4574dcf067 ]
>>
>> virtio_disable_cb is currently a nop for split ring with event index.
>> This is because it used to be always called from a callback when we know
>> device won't trigger more events until we update the index.  However,
>> now that we run with interrupts enabled a lot we also poll without a
>> callback so that is different: disabling callbacks will help reduce the
>> number of spurious interrupts.
>> Further, if using event index with a packed ring, and if being called
>> from a callback, we actually do disable interrupts which is unnecessary.
>>
>> Fix both issues by tracking whenever we get a callback. If that is
>> the case disabling interrupts with event index can be a nop.
>> If not the case disable interrupts. Note: with a split ring
>> there's no explicit "no interrupts" value. For now we write
>> a fixed value so our chance of triggering an interupt
>> is 1/ring size. It's probably better to write something
>> related to the last used index there to reduce the chance
>> even further. For now I'm keeping it simple.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I am not sure we want this in stable yet. It should in theory
>fix the reported interrupt storms but the reporter is on vacation.

Sure, I'll drop it for now. Let me know when you want it re-added.
Thanks!

-- 
Thanks,
Sasha
