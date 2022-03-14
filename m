Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AE54D7ECB
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiCNJkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiCNJkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:40:21 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 02:39:10 PDT
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F81CFC4;
        Mon, 14 Mar 2022 02:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=misterjones.org; s=dkim20211231; h=Content-Transfer-Encoding:Content-Type:
        Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W6hA5uboJeNKWm9S/YhbgP1yFsg53zZeeTZz0HBXZ24=; b=tUdS10g3hHpgWYXp6qMtkuqPC9
        4b8Mt9MqhqXEfDHG5LlDtoPXsF/vwfCpj6zJGriJY0/jlMATm3ERM0hZj/b5if5/hOOgcEcUkSecv
        PfrhOw45Xq2EcyzGoRnrfSzTrFxORQ5jFJV639NZM/0xAGloxOZv2Oww5ZN+z6zPIeSsYCOYwVlgK
        W09wC7HrqT85hr1jM9Irwn3+HvQDrMnsfXIKnzz7HxYLRArahrY36ukeJevs/tILQjNjTjDjc9oN7
        0TwHqX6JEPtzHyaGZVgNPxJu6LbFIWub2aHe9/2mKxfxkQNUD2Cf4AP2HPQAYqDb87maABqFuLkQN
        GFIKtw8Q==;
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@misterjones.org>)
        id 1nTgh0-00EIQa-Ux; Mon, 14 Mar 2022 09:08:43 +0000
MIME-Version: 1.0
Date:   Mon, 14 Mar 2022 09:08:42 +0000
From:   Marc Zyngier <maz@misterjones.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "A. Wilcox" <awilfox@adelielinux.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUG] arm64/m1: Accessing SYS_ID_AA64ISAR2_EL1 causes early boot
 failure on 5.15.28, 5.16.14, 5.17
In-Reply-To: <Yi7iRSHaFGsYup1p@kroah.com>
References: <32EA0FE1-5254-4A41-B684-AA2DEC021110@adelielinux.org>
 <Yi7iRSHaFGsYup1p@kroah.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1f0b74caa45a1d73af68eab8dcc15485@misterjones.org>
X-Sender: maz@misterjones.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, awilfox@adelielinux.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-14 06:35, Greg KH wrote:
> On Sun, Mar 13, 2022 at 10:59:01PM -0500, A. Wilcox wrote:
>> Hello,
>> 
>> I’ve been testing kernel updates for the Adélie Linux distribution’s 
>> ARM64 port using a Parallels VM on a MacBook Pro (13-inch, M1, 2020).  
>> When the kernel attempts to access SYS_ID_AA64ISAR2_EL1, it causes a 
>> fault as seen here booting 5.17.0-rc8:

[...]

>> This is because detection of the clearbhb instruction support requires 
>> accessing SYS_ID_AA64ISAR2_EL1.  Commenting out the two uses of 
>> supports_clearbhb in the kernel now yields a successful boot.
>> 
>> Qemu developers seem to have found this issue as well[1] when trying 
>> to boot 5.17 using HVF, the Apple Hypervisor Framework.  This seems to 
>> be some sort of platform quirk on M1, or at least in HVF on M1.  I’m 
>> not sure what the best workaround would be for this.  
>> SYS_ID_AA64ISAR2_EL1 seems to be something added in ARMv8.7, so 
>> perhaps access to it could be gated on that.
>> 
>> Unfortunately, this code was just added to 5.15.28 and 5.16.14, so 
>> stable no longer boots on Parallels VM on M1.  I am unsure if this 
>> affects physical boot on Apple M1 or not.
> 
> What commit causes this problem?  It sounds like you narrowed this down
> already, right?

This really is a Parallels bug. These kernels run fine on bare metal
M1 and in KVM. QEMU was affected as well, and that was fixed in their
HVF handling. HVF itself is fine.

So this should be punted back to the hypervisor vendor for not properly
implementing the architecture (no ID register is allowed to UNDEF).

         M.
-- 
Who you jivin' with that Cosmik Debris?
