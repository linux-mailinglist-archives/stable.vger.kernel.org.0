Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DC159AD3F
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiHTK2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbiHTK2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2912C40BE5;
        Sat, 20 Aug 2022 03:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B844C61128;
        Sat, 20 Aug 2022 10:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057D7C433D7;
        Sat, 20 Aug 2022 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660991315;
        bh=BfeRXrXK+kyAATA3rrD7DNtJBTOICyTG3ENmWC40kJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2H3QtvFpVNEciH1WtySMYZsnaQJiuDNmwW3V8xZkYT0ZwMVQwgnWnt304CfGooPp
         aTkiOPAOoJlTo1251krr6e2ou6u9aRZh9DGgCurLraTPBUEGpOnbRcf5PPZBrQc6Jo
         fSRSefBXYORAQKflTiQq00j82dOzqK/iVSrPGuLc=
Date:   Sat, 20 Aug 2022 12:28:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
Message-ID: <YwC3Wmj2Fq11EWVg@kroah.com>
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820092533.29420-2-jgross@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 11:25:24AM +0200, Juergen Gross wrote:
> When booting or resuming the system MTRR state is saved on the boot
> processor and then this state is loaded into MTRRs of all other cpus.
> During update of the MTRRs the MTRR mechanism needs to be disabled by
> writing the related MSR. The old contents of this MSR are saved in a
> set of static variables and later those static variables are used to
> restore the MSR.
> 
> In case the MSR contents need to be modified on a cpu due to the MSR
> not having been initialized properly by the BIOS, the related update
> function is modifying the static variables accordingly.
> 
> Unfortunately the MTRR state update is usually running on all cpus
> at the same time, so using just one set of static variables for all
> cpus is racy in case the MSR contents differ across cpus.
> 
> Fix that by using percpu variables for saving the MSR contents.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> I thought adding a "Fixes:" tag for the kernel's initial git commit
> would maybe be entertaining, but without being really helpful.

So that means I will just do a "best guess" as to how far to backport
things.  Hopefully I guess well...

thanks,

greg k-h
