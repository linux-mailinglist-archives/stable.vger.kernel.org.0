Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2A4C2F34
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 16:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiBXPQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 10:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiBXPQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 10:16:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B3219F453;
        Thu, 24 Feb 2022 07:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645715782; x=1677251782;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=RW4pCIgqi9NThdKppRLVW4N+od2ProNeT8oLseDiw6c=;
  b=dcUXEzF0SK1KoffxCaEhzr2HSCg5D0MdVpsnSyHXM3BMZnvTkNCMcOoG
   6gaataId9DyW3Kn2RGuBSKBW0FLm5jxA25G0hCuoEDzvkK2uS3YS6PY+e
   zVE3/HDZxcjYvFWWg4yWrCfEdSdIZ2EEc6yWrrv3EpHyITWt1NG76Xt/y
   GO74hyJH6vA32IyAJUTbt+fvLPZ20OgwhQ1vk/esuRITCp2AuMD/POfY1
   C6Hikddsld+k6/Zwp/wZ2nvexR1/R+5fR4ER70McgjkPXlxgB3RYDS81b
   EBnmsFdxEy+QHIsY3Z47XemmZppIwwwhMMPbXpNFsY2QTNnH+ogbyIk1A
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="232232334"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="232232334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 07:16:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="548785924"
Received: from vpirogov-mobl.amr.corp.intel.com (HELO [10.252.137.68]) ([10.252.137.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 07:16:21 -0800
Message-ID: <e495d70b-f138-367d-e1d7-67c77149db7a@intel.com>
Date:   Thu, 24 Feb 2022 07:16:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
In-Reply-To: <20220215192233.8717-1-bgeffon@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/22 11:22, Brian Geffon wrote:
> When eagerly switching PKRU in switch_fpu_finish() it checks that
> current is not a kernel thread as kernel threads will never use PKRU.
> It's possible that this_cpu_read_stable() on current_task
> (ie. get_current()) is returning an old cached value. To resolve this
> reference next_p directly rather than relying on current.
> 
> As written it's possible when switching from a kernel thread to a
> userspace thread to observe a cached PF_KTHREAD flag and never restore
> the PKRU. And as a result this issue only occurs when switching
> from a kernel thread to a userspace thread, switching from a non kernel
> thread works perfectly fine because all that is considered in that
> situation are the flags from some other non kernel task and the next fpu
> is passed in to switch_fpu_finish().
> 
> This behavior only exists between 5.2 and 5.13 when it was fixed by a
> rewrite decoupling PKRU from xstate, in:
>   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> 
> Unfortunately backporting the fix from 5.13 is probably not realistic as
> it's part of a 60+ patch series which rewrites most of the PKRU handling.
> 
> Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Willis Kung <williskung@google.com>
> Tested-by: Willis Kung <williskung@google.com>
> Cc: <stable@vger.kernel.org> # v5.4.x
> Cc: <stable@vger.kernel.org> # v5.10.x

I don't like forking the stable code from mainline.  But I also think
that backporting the FPU reworking that changed the PKRU handling is
likely to cause more bugs in stable than it fixes.

This fix is at least isolated to the protection keys code.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
