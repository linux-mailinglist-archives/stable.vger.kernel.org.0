Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6386BAB0B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCOIqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCOIqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4674A5F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 162FCB81C69
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF85C433D2;
        Wed, 15 Mar 2023 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678870006;
        bh=9jWUyaP7AGHJCqsZbALicSthThjGiwGzhiGFbro6SRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tU8Tas/FrtitTgFe6L10CT641/qpNoXYQzdGlAvdDP68zjUUW3U2OT1oGaia/kZpm
         GniYypgwgWRSRYfZFwDUDul7ffEbmAhVmvEZ2pWZOHab7DLt6jdHcJEEbM+dwHF4Af
         aV/3wp3QjJ4YUQEZimIv9Jf0+QXJqeKFTXArM6XM=
Date:   Wed, 15 Mar 2023 09:46:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     rhythm.m.mahajan@oracle.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de,
        pawan.kumar.gupta@linux.intel.com, cascardo@canonical.com,
        surajjs@amazon.com, daniel.sneddon@linux.intel.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [External] : Re: [PATCH 4.14] x86/cpu: Fix LFENCE serialization
 check in init_amd()
Message-ID: <ZBGF9C/7lk7I6YXs@kroah.com>
References: <20230314111159.3536249-1-rhythm.m.mahajan@oracle.com>
 <ZBF6XaeboXtY6VS5@kroah.com>
 <d7c7edde-b358-a9ab-e2ae-6f11ade2d871@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c7edde-b358-a9ab-e2ae-6f11ade2d871@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 02:11:57PM +0530, rhythm.m.mahajan@oracle.com wrote:
> 
> 
> On 15/03/23 1:27 pm, Greg KH wrote:
> > On Tue, Mar 14, 2023 at 04:11:59AM -0700, Rhythm Mahajan wrote:
> > > The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
> > > renamed the MSR_F10H_DECFG_LFENCE_SERIALIZE macro to
> > > MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> > > The fix changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
> > > MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function,
> > > but should have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> > > This causes a discrepancy in the LFENCE serialization
> > > check in the init_amd() function.
> > > 
> > > This causes a ~16% sysbench memory regression, when running:
> > >    sysbench --test=memory run
> > > 
> > > Fixes: 3f235279828c2a8aff3164fef08d58f7af2d64fc("x86/cpu: Restore AMD's DE_CFG MSR after resume
> > > ")
> > 
> > Odd line-wrapping :(
> > 
> > And please use the proper way to reference SHA1 as documented in the
> > kernel documentation.
> Thanks, I will send a v2 for this.
> > 
> > And why is this only needed in 4.14.y?  What about Linus's tree and all
> > of the other stable trees?
> The regression was introduced after the backport of 2632daebafd0 ("x86/cpu:
> Restore AMD's DE_CFG MSR after resume") for 4.14.y and 4.9.y.
> Mainline and other stable don't have this regression.
> The fix is only needed for 4.14.y and 4.9.y.

Ah, then please make this more obvious in your changelog text that this
is a problem that is only caused by the backport and is not relevant
anywhere else.

thanks,

greg k-h
