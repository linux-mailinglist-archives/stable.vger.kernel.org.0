Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8BA58AF80
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbiHESDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiHESDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:03:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D124FCC;
        Fri,  5 Aug 2022 11:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659722611; x=1691258611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4UbjXMUoFUj6pk9VzCRvRkLjyHe1GWl9h8Xxca2jeaI=;
  b=YU9duljHeyHGz1u8aVmDmtgo7T4Y0VZn/Tw9Z0ZCBIV3whIApgl2mJHZ
   d5ZahDTZYWfwGxej7vhKZAW/RzKUzIoWCIvsuvwMx+qkwXtu25AZqMvvB
   kP1Sb/OCGtl5uNN/fCiCyWwqV8x6wIX/LBIu1P9ciQDo5dbnfcuL8QPNG
   vX6TL515MlyXLKyw9L0XGTsGpg0LgSOeIws/Hg9pSsNbGt7JwPFHTwbg0
   mCg5fKJJOzeyfUeVuUymJjSqvdVB7ebjn05IkUcaLD2LPuBz2hp5PVeTx
   59W/OcByViqR8KdSZThX2ygKJyI8BPyla3Vnwl6zWBvcISBa8D7jK1/Kt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="291031704"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291031704"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 11:03:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="579584529"
Received: from rderber-mobl1.amr.corp.intel.com (HELO [10.212.217.71]) ([10.212.217.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 11:03:30 -0700
Message-ID: <d815d964-3a31-024b-7f07-04da86cc62ae@intel.com>
Date:   Fri, 5 Aug 2022 11:03:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] x86/fpu: Allow PKRU to be (once again) written by
 ptrace.
Content-Language: en-US
To:     Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20220804031632.52921-1-khuey@kylehuey.com>
 <b3464e21-95e8-a80e-bf98-3c90c06afb91@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <b3464e21-95e8-a80e-bf98-3c90c06afb91@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/22 10:24, Dave Hansen wrote:
> On 8/3/22 20:16, Kyle Huey wrote:
>> When management of the PKRU register was moved away from XSTATE, emulation
>> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
>> for APIs that write XSTATE. This can be seen by running gdb and executing
>> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
>> write to the PKRU register (which gdb performs through ptrace) is ignored.
> Do you happen to have a reproducer for this sitting around?  I'd love to
> get an addition to the pkeys selftest/ in place to make sure we don't
> break this again.  PKRU is a very special snowflake.

Let me put this another way: I'm much more likely to quickly merge fixes
that come with a selftest that demonstrates the breakage and the fix.
An in-kernel test ensures:

1. There is a problem now
2. The patch fixes the problem
3. The problem does not recur
