Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F231B4BA64F
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 17:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiBQQoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 11:44:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242697AbiBQQog (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 11:44:36 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA549AC;
        Thu, 17 Feb 2022 08:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645116261; x=1676652261;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=XqrJSESx4co6rylkuJdM9NA+JNlPqfIB9lAf1Ua1BBA=;
  b=IG1/OdJJG4CmrkH8uJ+hXfvapFyTqIXRmcbr1EbRLcqrzbGd+hj/phJk
   2zddSoTlBaD8EiPuiilzq1XKShZjA4BQSEHZZ5vREOsNSObXiNndzEKxq
   Efsu1vy23Zr4Ph2EEfabKjkgUtiGK7uB7HTR+GAUVebcEvFSaK4+fNPUU
   vgm/EbgjJVHa5YxUYf3Mx8ZeqmlW32mH5TikpaqPVq7xuTWLsxzGiXdRZ
   pZqs2Gs89wJaqcMps35jB6tPjY02/RuV7xF9ZQpkKYtA2um3e/pt0u6FF
   jLjjKK5IL0EKfb/6H0oqePU+GUKniLzh+nLYdU5uL9DZKh5aYVM3xqOR5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="314181323"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="314181323"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 08:44:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530351502"
Received: from drichard-mobl2.amr.corp.intel.com (HELO [10.209.21.238]) ([10.209.21.238])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 08:44:21 -0800
Message-ID: <dbe8b78e-bc55-c796-358f-a93e0eac87d1@intel.com>
Date:   Thu, 17 Feb 2022 08:44:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
 <YgzMTrVMCVt+n7cE@kroah.com> <fc86d51c-7aa2-6379-5f26-ad533c762da3@intel.com>
 <CADyq12yGvqbb3+hp6f39RqyEM3Mu896yY6ik7Lh39W=o44bYbA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
In-Reply-To: <CADyq12yGvqbb3+hp6f39RqyEM3Mu896yY6ik7Lh39W=o44bYbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/17/22 05:31, Brian Geffon wrote:
> How would you and Greg KH like to proceed with this? I'm happy to help
> however I can.

If I could wave a magic wand, I'd just apply the whole FPU rewrite to
stable.

My second choice would be to stop managing PKRU with XSAVE.
x86_pkru_load() uses WRPKRU instead of XSAVE and keeps the task's PKRU
in task->pkru instead of the XSAVE buffer.  Doing that will take some
care, including pulling XFEATURE_PKRU out of the feature mask (RFBM) at
XRSTOR.  I _think_ that can be done in a manageable set of patches which
 will keep stable close to mainline.  I recognize that more bugs might
get introduced in the process which are unique to stable.

If you give that a shot and realize that it's not feasible to do a
subset, then we can fall back to the minimal fix.  I'm not asking for a
multi-month engineering effort here.  Maybe an hour or two to see if
it's really as scary as it looks.
