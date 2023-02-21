Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F14369E842
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBUT35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBUT3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:29:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799112279C;
        Tue, 21 Feb 2023 11:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A17B810A4;
        Tue, 21 Feb 2023 19:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7093AC433D2;
        Tue, 21 Feb 2023 19:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677007788;
        bh=ofMhM2dExFxHhPE1ZMCv/RtWFuMHRKLsE+vEiQe9g2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMq579K/LueNch3lfjbzObwcK2eaiQ6+KxNnSY7YNJ5LAMbv5khcTtTPmIV7kCku/
         zm8gQ4iwUUHYWa/MjKHEQb1NjJXtYlqJWOKtIsXaPBCXb7fARrYzoQgWJFANm2oxJz
         8SCl/TdQi1S8CP9Ga5CzT0oG8G/lqnvVV8dcfcvo=
Date:   Tue, 21 Feb 2023 20:29:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/UbqiHQ2/aczPzg@kroah.com>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221184908.2349578-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 07:49:07PM +0100, KP Singh wrote:
> Setting the IBRS bit implicitly enables STIBP to protect against
> cross-thread branch target injection. With enhanced IBRS, the bit it set
> once and is not cleared again. However, on CPUs with just legacy IBRS,
> IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
> KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
> STIBP, thus requiring some form of cross-thread protection in userspace.
> 
> Enable STIBP, either opt-in via prctl or seccomp, or always on depending
> on the choice of mitigation selected via spectre_v2_user.
> 
> Reported-by: José Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)

Why isn't patch 2/2 for stable as well?

thanks,

greg k-h
