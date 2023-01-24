Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8593A67983D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbjAXMmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAXMmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:42:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B84A2BF13;
        Tue, 24 Jan 2023 04:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674564153; x=1706100153;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=azRAjyHYATG0pAS/puvlhaA3TL8JqYMWIj5+ISxcN20=;
  b=g1AiOTAB0H4Q7Iv1LzRRHtjeX8ZtTkL4tMJ2b8U7h3zMZH8zXae4hMlA
   1B8jBStnFdaLzJjY5/9gaNff9q9yaDvIYPxMJUj/3YY/0CzfkBaiIosyk
   wqNz/1g4WyLqtMr3gwjADz5Yh2uStcv8RDTpqeYD1AUrsrj9ihZN59Ckg
   OleA3fkHs6bENWVbb3vlNKjHscsaG9eVXdrRIHXND8nObt1/jQRGLDItT
   ie5wp/VGiafK2uHMUCRP9wW92BWflvIUGKRZRUzaXHEv5cnqfLCLShuwI
   fKtvYJx6Gl/jqhbFktoUw4wL2T2GPBFbWywpuKW17SQXEWoArlyCFbsXx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="314184931"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="314184931"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 04:42:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="612034493"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="612034493"
Received: from ubik.fi.intel.com (HELO localhost) ([10.237.72.184])
  by orsmga003.jf.intel.com with ESMTP; 24 Jan 2023 04:42:12 -0800
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
In-Reply-To: <Y8/Kyzh+stow83lQ@unreal>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal> <87v8kwp2t6.fsf@ubik.fi.intel.com>
 <Y8/Kyzh+stow83lQ@unreal>
Date:   Tue, 24 Jan 2023 14:42:11 +0200
Message-ID: <87pmb4p0ik.fsf@ubik.fi.intel.com>
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

> On Tue, Jan 24, 2023 at 01:52:37PM +0200, Alexander Shishkin wrote:
>> Leon Romanovsky <leon@kernel.org> writes:
>> 
>> > I'm not security expert here, but not sure that this protects from anything.
>> > 1. Kernel relies on working and not-malicious HW. There are gazillion ways
>> > to cause crashes other than changing MSI-X.
>> 
>> This particular bug was preventing our fuzzing from going deeper into
>> the code and reaching some more of the aforementioned gazillion bugs.
>
> Your commit message says nothing about fuzzing, but talks about
> malicious device. 

A malicious device is what the fuzzing is aiming to simulate. The fact
of fuzzing process itself didn't seem relevant to the patch, so I didn't
include it, going instead for the problem statement and proposed
solution. Will the commit message benefit from mentioning fuzzing?

> Do you see "gazillion bugs" for devices which don't change their MSI-X
> table size under the hood, which is main kernel assumption?

Not so far.

> If yes, you should fix these bugs.

That's absolutely the intention.

>> > 2. Device can report large table size, kernel will cache it and
>> > malicious device will reduce it back. It is not handled and will cause
>> > to kernel crash too.
>> 
>> How would that happen? If the device decides to have fewer vectors,
>> they'll all still fit in the ioremapped MSIX table. The worst thing that
>> can happen is 0xffffffff reads from the mmio space, which a device can
>> do anyway. But that shouldn't trigger a page fault or otherwise
>> crash. Or am I missing something?
>
> Like I said, I'm no expert. You should tell me if it safe for all
> callers of pci_msix_vec_count().

Well, since you stated that the reverse will cause a kernel crash, I had
to ask how. I'll include some version of the above paragraph in the
commit message to indicate that we reverse situation has been considered.

Regards,
--
Alex
