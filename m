Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F5679D77
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbjAXP2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbjAXP2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:28:33 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D865A8;
        Tue, 24 Jan 2023 07:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674574112; x=1706110112;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=tkzGpVlFyCfFjd/vFXWy7GqH6aY1OKezZNGGV0z+nSY=;
  b=lPBi56tc4A08dFfvTkUhbp2MvwEO7agQwJapJPOaNp+WIxVS1KDcI/mB
   gI+IhS57poVmaUtL5HymCJRhB7035uwwmGMwiPrPfCAnPMvKe/yqpYlbT
   nYw2hDM5QsHwa5d8u79MrOmGgaZEYwZjBjHbe63Qv9TXaoZf3OJE0MChL
   MHK4H6M+NBNrWhZOC6+9ynqg67v1CwG3VeTw8RgfD93s40OPeGO05GahY
   xHo7kvkyF9HHH5Ce/Om9dKpO4i2eQxjHnt8QD04FKxGtBnWdgfJilWS8d
   6j9Z5Rr0dgW2OVe0Rk0F905ONUJRKoiqsqau50/GOQdkh+opcXJCc6XuR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="327575317"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="327575317"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 07:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="770354522"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="770354522"
Received: from ubik.fi.intel.com (HELO localhost) ([10.237.72.184])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jan 2023 07:28:28 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
In-Reply-To: <Y8/WPAqZACAHcmf+@unreal>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal> <87v8kwp2t6.fsf@ubik.fi.intel.com>
 <Y8/Kyzh+stow83lQ@unreal> <87pmb4p0ik.fsf@ubik.fi.intel.com>
 <Y8/WPAqZACAHcmf+@unreal>
Date:   Tue, 24 Jan 2023 17:28:27 +0200
Message-ID: <87mt68ostg.fsf@ubik.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Leon Romanovsky <leon@kernel.org> writes:

> On Tue, Jan 24, 2023 at 02:42:11PM +0200, Alexander Shishkin wrote:
>> Leon Romanovsky <leon@kernel.org> writes:
>> 
>> A malicious device is what the fuzzing is aiming to simulate. The fact
>> of fuzzing process itself didn't seem relevant to the patch, so I didn't
>> include it, going instead for the problem statement and proposed
>> solution. Will the commit message benefit from mentioning fuzzing?
>
> No, for most if not all kernel developers, the fuzzing means some sort of
> random user-space input. PCI devices are trusted in the kernel.

Right, it's a different kind of fuzzing. Apologies, I should have made
it clear.

>> > Do you see "gazillion bugs" for devices which don't change their MSI-X
>> > table size under the hood, which is main kernel assumption?
>> 
>> Not so far.
>
> So please share them with us.

We do, as soon as we find them. This patch is one such instance.

>> > If yes, you should fix these bugs.
>> 
>> That's absolutely the intention.
>
> So let's fix the bugs and not hide them.

Yes, that's what this patch aims to achieve.

Thanks,
--
Alex
