Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E5599DAD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349448AbiHSOoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 10:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348671AbiHSOoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 10:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959A0CD539
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 07:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A69B827DF
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 14:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF1C433D6;
        Fri, 19 Aug 2022 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660920270;
        bh=/emqM6IKfRTbTqYtQrkqrh+LUTx3ouTqWcOrtjmalw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3gS51eLRJmDUI2ZRzHAvJDkHfumrikDYXATEJU+Farbh5Tb/vzJIxaV6jg4C7Z8x
         uTFocJHal3knPTAxmke+K1Sq9WjvR14ySE8m6g8I/pRVNlRMsnJrcREtwiUn4EhSVL
         8b0lL3/eUABJMvJ6Gh5GC3fkaoEJvof2l0fZXYRQ=
Date:   Fri, 19 Aug 2022 16:44:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.10-stable tree
Message-ID: <Yv+hy5nWTPpei0C5@kroah.com>
References: <166057758686253@kroah.com>
 <20220818041536.5urxrunzmdawkdh7@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818041536.5urxrunzmdawkdh7@Rk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 12:15:36PM +0800, Coiby Xu wrote:
> Hi Greg,
> 
> 
> This patch depends on three prerequisites. This full list of commit ids
> should be backported is shown below,
> 
> 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> 
> $ git checkout -b arm_key_5.10.y stable/linux-5.10.y
> Updating files: 100% (33255/33255), done.
> branch 'arm_key_5.10.y' set up to track 'stable/linux-5.10.y'.
> Switched to a new branch 'arm_key_5.10.y'
> $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
> Auto-merging arch/arm64/include/asm/kexec.h
> Auto-merging arch/powerpc/include/asm/kexec.h
> Auto-merging arch/s390/include/asm/kexec.h
> Auto-merging arch/x86/include/asm/kexec.h
> Auto-merging include/linux/kexec.h
> Auto-merging kernel/kexec_file.c
> [arm_key_5.10.y 624dfcf3b8de] kexec_file: drop weak attribute from functions
>  Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>  Date: Fri Jul 1 13:04:04 2022 +0530
>  6 files changed, 61 insertions(+), 40 deletions(-)
> Auto-merging include/linux/kexec.h
> Auto-merging kernel/kexec_file.c
> [arm_key_5.10.y da8cfa52682e] kexec: clean up arch_kexec_kernel_verify_sig
>  Date: Thu Jul 14 21:40:24 2022 +0800
>  2 files changed, 13 insertions(+), 25 deletions(-)
> Auto-merging arch/x86/kernel/kexec-bzimage64.c
> Auto-merging include/linux/kexec.h
> Auto-merging kernel/kexec_file.c
> [arm_key_5.10.y 0bb032082ce6] kexec, KEYS: make the code in bzImage64_verify_sig generic
>  Date: Thu Jul 14 21:40:25 2022 +0800
>  3 files changed, 25 insertions(+), 19 deletions(-)
> [arm_key_5.10.y fde64a36fa74] arm64: kexec_file: use more system keyrings to verify kernel image signature
>  Date: Thu Jul 14 21:40:26 2022 +0800
>  1 file changed, 1 insertion(+), 10 deletions(-)

Now queued up, thanks.

greg k-h
