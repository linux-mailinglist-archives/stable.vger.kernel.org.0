Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72363F940
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 21:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiLAUjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 15:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiLAUjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 15:39:00 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAA5C0569
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 12:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669927131; x=1701463131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KUCD+YWjI0e9FpR4ExqPRhLUrJ/T8B5WvR0IYSPRLhQ=;
  b=jRCbjs2AVhNYGL72PITJ+hfAzQWPz+AV73149CJRNpPX3D/0YuXn1+JR
   OVK/aB8jspw8S8UPgdsH1c748mbs5xl2V02jjDJIq3saxO+iw5KlPOglJ
   nf0cyWeBC9l3aJGP5ck1Rm0/F5yvXgvfd9pRxmC6eQtqvhaztrRZky2W8
   /QgIxuPuemcbMestoNr9uzTPDa7lWJgBXycd4Y+LHdqPLbGGd1zRN9F38
   UaKkayda0Z89CDiREcwCOSB0y9vDUFGbOqLVwbotlDSQEPQjGSxRsKz9W
   OXP/iwlArr2ZnXqpYDWUk8FyEpal/GPwSnLQqswzXWsbWPjnKakCpVmer
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313432440"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313432440"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 12:38:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="646904685"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="646904685"
Received: from subratad-mobl1.amr.corp.intel.com (HELO desk) ([10.209.101.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 12:38:50 -0800
Date:   Thu, 1 Dec 2022 12:38:48 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/pm: Add enumeration check before spec
 MSRs save/restore" failed to apply to 5.10-stable tree
Message-ID: <20221201203848.rn5y3dan2jvia5lq@desk>
References: <1669811516103161@kroah.com>
 <20221130231109.ohdusribjld4t4f5@desk>
 <Y4hCnMlrnLe98IQ4@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y4hCnMlrnLe98IQ4@kroah.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 06:58:52AM +0100, Greg KH wrote:
>On Wed, Nov 30, 2022 at 03:11:09PM -0800, Pawan Gupta wrote:
>> On Wed, Nov 30, 2022 at 01:31:56PM +0100, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 5.10-stable tree.
>>
>> Patch is applying cleanly on v5.10.156. Is it not where it should be
>> applied?
>
>Did you try building with the patch applied?  :(

No because the message said "does not apply" and I wanted to make sure I
am applying at the right place. I see the build issue, its because the
dependent patch aaa65d17eec3 ("x86/tsx: Add a feature bit for TSX
control MSR support") was missing. Strangely the dependent patch got
picked up for 5.15:

   https://lore.kernel.org/stable/20221130180537.128827808@linuxfoundation.org/

but not for 5.10 and older. I sent the 5.10 backport for both the
patches. They were compile and boot tested.

>> Same observation for failed patch on 5.4.
>
>Same on 5.4, breaks the build, right?

Yes, fixing it.

>I don't have special emails for "this applied but did not build" as
>that's more rare.

Ohk, will keep that in mind.
