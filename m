Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993C54B798B
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiBOVme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:42:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiBOVme (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:42:34 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD5477A98;
        Tue, 15 Feb 2022 13:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644961343; x=1676497343;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=6nOQyQn4qkItz0k8hfiai/vmAMIv8bluxSimBsP+gyI=;
  b=ErR1zqYS5J44FTU31iPZWJE0u0sfmT1nU5JEZ9CdiGEiYNhMGQXaUN73
   a4HIV3laGZ/KSvr4HfEP59M8GUr9N8In0MvgyTyZRbxrgz4RhdoUc/XVh
   0U73vykeknXNxI68QTFSksnqbgEezYZDKGRwCm/WxMuy6dioZTrpuKCHt
   rSG4tuqFMZg4c9CXv5yB2dTgVES/aD9Kn9wj9Sw5cb9TqEVmEmRNlEgHJ
   yauJMA+m8rTCcz+COoN770FE8L79Qznk0j52n+tmOl7qmJW/r/gWvlna5
   Z7YEE/QpRImgBy62Ps3wx3ssDR4bZfdrVARvjZJdHWhwtfSt2DjYxkE1r
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250200652"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250200652"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 13:42:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="529080814"
Received: from tngodup-mobl.amr.corp.intel.com (HELO [10.209.32.98]) ([10.209.32.98])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 13:42:23 -0800
Message-ID: <066c9f4b-b0a3-9343-9db9-1c1c7303da6f@intel.com>
Date:   Tue, 15 Feb 2022 13:42:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
In-Reply-To: <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/22 13:32, Brian Geffon wrote:
>> How was this tested, and what do the maintainers of this subsystem
>> think?  And will you be around to fix the bugs in this when they are
>> found?
> This has been trivial to reproduce, I've used a small repro which I've
> put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> , I also was able to reproduce this using the protection_keys self
> tests on a 11th Gen Core i5-1135G7. 

I've got an i7-1165G7, but I'm not seeing any failures on a
5.11 distro kernel.

How long does this take for you to reproduce?
