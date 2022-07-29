Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6897D5856FA
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 00:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiG2WzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiG2WzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 18:55:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A6D83F35;
        Fri, 29 Jul 2022 15:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659135300; x=1690671300;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RxGyrQX3VcKrDZrjlFCWR11WzftdxIDuBbyGkk0QBfY=;
  b=F37/l6QmqEvIN5hKH412uKwqIr3Wz9DLv70I1j+a8z1jEC81DFztcQgN
   xD2Pi/6EreMSNxKBRlmLakfJAt5p2KEvV3WPANeWID8luG7a5qzlWnKSq
   W9D0RQHwuDUMW4hdT3CWwgHyjjA8ikPrhCNk05Epa07tYENhFvrBw3FjR
   SdqCWLIhHO2FYIi0vOoHI6OCGahizjphlvOsyRm3VwyP5o6GSGhrPzk0h
   Imft2ef+0a4+M29g/Cxh+HjNEmZq/go/iKk3DudbNfQ5kLyqr8uPJvz7P
   PXdTpfR8pM55ELZ82M7f3SFdhKVoD8mgDgKtcM6SNbcSEw37ahfn7aUKb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="269245423"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="269245423"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 15:54:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="669415484"
Received: from svdas-mobl.amr.corp.intel.com (HELO [10.209.20.175]) ([10.209.20.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 15:54:59 -0700
Message-ID: <1bcf0b54-6ddf-b343-87c5-f7fd7538759c@intel.com>
Date:   Fri, 29 Jul 2022 15:54:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Content-Language: en-US
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic> <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic> <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic> <20220729214627.wowu5sny226c5pe4@desk>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220729214627.wowu5sny226c5pe4@desk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/22 14:46, Pawan Gupta wrote:
> Let me see if there is a way to distinguish between 4. and 5. below:
> 
>    CPU category				  X86_BUG_MMIO_STALE_DATA	X86_BUG_MMIO_UNKNOWN
> -----------------------------------------------------------------------------------------------
> 1. Known affected (in cpu list)			1				0
> 2. CPUs with HW immunity (MMIO_NO=1)		0				0
> 3. Other vendors				0				0
> 4. Older Intel CPUs				0				1
> 5. Not affected current CPUs (but MMIO_NO=0)	0				?

This seems like something we would need to go back to our colleagues to
figure out.  Basically, at the time of publishing the
X86_BUG_MMIO_STALE_DATA papers, what was considered "older"?

In other words, we need the folks at Intel that did this good work to
_show_ their work (at least part of it).
