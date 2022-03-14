Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC194D7FE9
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 11:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiCNKfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 06:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiCNKfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 06:35:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5988913CC4;
        Mon, 14 Mar 2022 03:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D396B80D91;
        Mon, 14 Mar 2022 10:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA60C340E9;
        Mon, 14 Mar 2022 10:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647254047;
        bh=ceK23KhbfArf02xnhKEUu0OSDxVRcDa0LB7v48ZAFLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ensrQicJT7ADxJeyo8j5kC8vU2EXiXwg5vCCJ3k1M0pJk5P8/kjjfOoVwIJvPy608
         +I6TyWLWeQJaKrhU5gjbporenurnGpC8HbpUw8ZjghJMmcxJnQzeAWl0vZ8aswC1dL
         fT9rcf7hnkxJ3ykoUqHsG5H0DTa3PYo9nxdLtPrLLJFHWj5uB8SaA5//COuGcmRXCu
         iSFXBbRK7bb6dHFYGIiwwSj5aDowdK01AX9iZKLQEHwSmV5MnHTAx4GoyYOuGyDrDg
         dyh2pm2l8+ppKKpLwqzbaMzKY41kc534Be7jDbVf5qShAGYd36lrP9kiJmqcIlVE8M
         k+pgNpygBhMGw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nTi1d-00EJct-GL; Mon, 14 Mar 2022 10:34:05 +0000
MIME-Version: 1.0
Date:   Mon, 14 Mar 2022 10:34:05 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     "A. Wilcox" <awilfox@adelielinux.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [BUG] arm64/m1: Accessing SYS_ID_AA64ISAR2_EL1 causes early boot
 failure on 5.15.28, 5.16.14, 5.17
In-Reply-To: <2498FEAE-DE38-46C5-A50A-93396BB0938A@adelielinux.org>
References: <32EA0FE1-5254-4A41-B684-AA2DEC021110@adelielinux.org>
 <Yi7iRSHaFGsYup1p@kroah.com>
 <1f0b74caa45a1d73af68eab8dcc15485@misterjones.org>
 <2498FEAE-DE38-46C5-A50A-93396BB0938A@adelielinux.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <907327093697278cd816aafec9e20b3e@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: awilfox@adelielinux.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

{switching email address]

On 2022-03-14 10:03, A. Wilcox wrote:
> On Mar 14, 2022, at 4:08 AM, Marc Zyngier <maz@misterjones.org> wrote:
>> On 2022-03-14 06:35, Greg KH wrote:
>>> On Sun, Mar 13, 2022 at 10:59:01PM -0500, A. Wilcox wrote:
>>>> Hello,
>>>> I’ve been testing kernel updates for the Adélie Linux distribution’s
>>>> ARM64 port using a Parallels VM on a MacBook Pro (13-inch, M1, 
>>>> 2020).
>>>> When the kernel attempts to access SYS_ID_AA64ISAR2_EL1, it causes a
>>>> fault as seen here booting 5.17.0-rc8:
>> 
>> […]
>> 
>>>> This is because detection of the clearbhb instruction support 
>>>> requires
>>>> accessing SYS_ID_AA64ISAR2_EL1. Commenting out the two uses of
>>>> supports_clearbhb in the kernel now yields a successful boot.
>>>> Qemu developers seem to have found this issue as well[1] when trying 
>>>> to
>>>> boot 5.17 using HVF, the Apple Hypervisor Framework. This seems to 
>>>> be
>>>> some sort of platform quirk on M1, or at least in HVF on M1. I’m not
>>>> sure what the best workaround would be for this. 
>>>> SYS_ID_AA64ISAR2_EL1
>>>> seems to be something added in ARMv8.7, so perhaps access to it 
>>>> could be
>>>> gated on that.
>>>> Unfortunately, this code was just added to 5.15.28 and 5.16.14, so
>>>> stable no longer boots on Parallels VM on M1. I am unsure if this
>>>> affects physical boot on Apple M1 or not.
>>> What commit causes this problem?  It sounds like you narrowed this 
>>> down
>>> already, right?
>> 
>> This really is a Parallels bug. These kernels run fine on bare metal
>> M1 and in KVM. QEMU was affected as well, and that was fixed in their
>> HVF handling. HVF itself is fine.
>> 
>> So this should be punted back to the hypervisor vendor for not 
>> properly
>> implementing the architecture (no ID register is allowed to UNDEF).
> 
> Thanks, I wasn’t able to test native boot.  Since this is a bug in the
> hypervisor, I’ll notify them in the morning.

Great, thanks.

> For those of us stuck with Parallels, I’ll assume reverting of these
> three commits in my own build is the best way forward until it’s
> fixed.  The M1 isn’t going to grow new instruction support in the
> meantime, so I don’t see a whole lot of harm in it - but the other
> mitigations in .28 seem useful.

As a *very* short term solution, that's probably the right thing to do.

However, this register is bound to grow new uses over time, and 
disabling
these features in a distro kernel is going to impact all users, unless
your particular kernel build is strictly limited to M1.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
