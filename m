Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34874410
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 05:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390075AbfGYDkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 23:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389704AbfGYDkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 23:40:35 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0EC216F4;
        Thu, 25 Jul 2019 03:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564026034;
        bh=hpaCgDwNS1P+6uaG/9WjvDSlPYKubAyqTyESkFBXPZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hor4+Z3nvpgoPiwv9nzdkhVrSK2GGGlhjsoKAyhcuK0p1sBN9nZ/56JMFZLgL2TDX
         M8Vuczg0+LHefOwiH39Ur0xbjCsCVxOoVYuXNisE8PlRfr0hlTOh7+w7kjC8c5vdYL
         /uIKhFr4erf8aODkz7AMeXIRFzPDzj+cfc+XCD7k=
Date:   Wed, 24 Jul 2019 23:40:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alessio Balsini <balsini@android.com>, astrachan@google.com,
        maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 1/2] um: Allow building and running on older hosts
Message-ID: <20190725034032.GA4099@sasha-vm>
References: <20190722103338.111753-1-balsini@android.com>
 <20190724120753.GH3244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190724120753.GH3244@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 02:07:53PM +0200, Greg KH wrote:
>On Mon, Jul 22, 2019 at 11:33:37AM +0100, Alessio Balsini wrote:
>> commit 0a987645672ebde7844a9c0732a5a25f3d4bb6c6 upstream.
>>
>> Commit a78ff1112263 ("um: add extended processor state save/restore
>> support") and b6024b21fec8 ("um: extend fpstate to _xstate to support
>> YMM registers") forced the use of the x86 FP _xstate and
>> PTRACE_GETREGSET/SETREGSET. On older hosts, we would neither be able to
>> build UML nor run it anymore with these two commits applied because we
>> don't have definitions for struct _xstate nor these two ptrace requests.
>>
>> We can determine at build time which fp context structure to check
>> against, just like we can keep using the old i387 fp save/restore if
>> PTRACE_GETRESET/SETREGSET are not defined.
>>
>> Fixes: a78ff1112263 ("um: add extended processor state save/restore support")
>> Fixes: b6024b21fec8 ("um: extend fpstate to _xstate to support YMM registers")
>> Change-Id: I2cda034c8a6637de392c2740a993982ad132bda5
>
>No need for change-id in upstream patches :)
>
>let me see if I can just take what is already in 4.13 directly...

Alessio,

Do we also need 2fb44600fe784 ("um: Fix check for _xstate for older
hosts")?

--
Thanks,
Sasha
