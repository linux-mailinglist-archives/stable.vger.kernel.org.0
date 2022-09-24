Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68485E8AA5
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiIXJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiIXJTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9595812B5FB;
        Sat, 24 Sep 2022 02:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 284E961221;
        Sat, 24 Sep 2022 09:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A21C433D6;
        Sat, 24 Sep 2022 09:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664011162;
        bh=+S04GeAW3/TLKjCQ5LxuuH1wKpbCajXi/U4ujhoS9mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAMjQHP6GB5PCvySH2eTGeFQa4Eu4alKUt9TbSyCeCJ0oyKGebB/oTW/EXr8SDuUQ
         707Ema6O87JlR18n+dCXEG5gMDZi61PE7BeadC2oZltOeUqsokaNoBDT7Vr17ZFrxj
         M5KYBbsgcz1iyAAKuAY/JiluhGQmF0jE/Ot3/Q/4=
Date:   Sat, 24 Sep 2022 11:19:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Philipp Rudo <prudo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:KEXEC" <kexec@lists.infradead.org>,
        Coiby Xu <coxu@redhat.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 5.15 0/6] arm64: kexec_file: use more system keyrings to
 verify kernel image signature + dependencies
Message-ID: <Yy7Ll1QJ+u+nkic9@kroah.com>
References: <cover.1663951201.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1663951201.git.msuchanek@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022 at 07:10:28PM +0200, Michal Suchanek wrote:
> Hello,
> 
> this is backport of commit 0d519cadf751
> ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> to table 5.15 tree including the preparatory patches.

This feels to me like a new feature for arm64, one that has never worked
before and you are just making it feature-parity with x86, right?

Or is this a regression fix somewhere?  Why is this needed in 5.15.y and
why can't people who need this new feature just use a newer kernel
version (5.19?)

thanks,

greg k-h
