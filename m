Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0732F6BAA19
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjCOHy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCOHyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F3C2D144
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A0FCB81D18
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C04BC433EF;
        Wed, 15 Mar 2023 07:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678866881;
        bh=OpW+S+L1WyEEC+9FAO6MYfsatIVVFWVYayqaXqwg3Rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lx8f9pTDVS8m0mUMSUUPsIF3B4him7FNs9JSiGDZOhquoo1Zn3jXc0jrjbpnBTbgW
         GbA1eayyurv0ICTIcjHGteVPkyX5Ma037AEoJrPJY2fOGTK0BSklQ5wMzv5rlkd781
         WKrBLN2ptOpr0/Vp8HbZooPBSIexHAgvJzC/oIFo=
Date:   Wed, 15 Mar 2023 08:54:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Feng Tang <feng.tang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] kexec: move locking into do_kexec_load
Message-ID: <ZBF5vkkwB+qs2GlS@kroah.com>
References: <tencent_FE90DDE46BFA03B385DFC4B367953D357206@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_FE90DDE46BFA03B385DFC4B367953D357206@qq.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 12:18:04AM +0800, wenyang.linux@foxmail.com wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> commit 4b692e861619353ce069e547a67c8d0e32d9ef3d upstream.
> 
> Patch series "compat: remove compat_alloc_user_space", v5.
> 
> Going through compat_alloc_user_space() to convert indirect system call
> arguments tends to add complexity compared to handling the native and
> compat logic in the same code.
> 
> This patch (of 6):

What about the other 6?

And what kernel is this going to, just 5.10.y?

Can you resend this as an actual patch series linked together?  They do
not show up properly for some reason (same for your 5.15.y patches.)

Try using git send-email to send them out.

thanks,

greg k-h
