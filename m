Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F236585741
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 01:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbiG2XTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 19:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiG2XS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 19:18:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CF04E854;
        Fri, 29 Jul 2022 16:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659136738; x=1690672738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Fw0WZLKvo2oyc4VCQcZ7xgjGE2qBBBrJnQzUXlechQ=;
  b=KAyPx2QdeJvE8s9kkoUSUmhNGZ9LkDQ9B0I+D22eC1ZjS1RxOR6H1Alh
   eDDsiFmLSvT6WGLZ9XV8IwoxGfIg/Hc6nNIx0oJV6pZsdfdJ8EZfiP7a/
   17zNewnGgqPkraxMfGyKkvw5s5mp1NvJVrySVF9PfX5w+3JLaJ0tFEV6I
   RyoWaV+/zpAl3YhTjxaN36dPriljP0G8fswXa3VgGw7MU/kBIOt89bkxi
   SIg2PNIteD9sV4gy9Y9U0pJTuWUWSMlUdHK+k6AOkfMD8uqqCrmZ6XgXw
   7iHRk9RSL+Ft6TKtZ/N68jA11QasnN1Is4lOrenhDs0jXbU1pIRLioFWK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="314674424"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="314674424"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 16:18:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="601431913"
Received: from svdas-mobl.amr.corp.intel.com (HELO [10.209.20.175]) ([10.209.20.175])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 16:18:58 -0700
Message-ID: <31d026f3-a356-d7bd-26f1-32d163a7f5b4@intel.com>
Date:   Fri, 29 Jul 2022 16:18:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Content-Language: en-US
To:     Tony Luck <tony.luck@intel.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic> <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic> <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic> <20220729214627.wowu5sny226c5pe4@desk>
 <1bcf0b54-6ddf-b343-87c5-f7fd7538759c@intel.com>
 <YuRoOCUxGUJ/8QVH@agluck-desk3.sc.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YuRoOCUxGUJ/8QVH@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/22 16:07, Tony Luck wrote:
> https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html
> 
> Click to the 2022 tab. The MMIO affected/not-affected status is there
> (you'll need to use the horizontal scroll to shift over to see those
> columns).
> 
> This table lists all the CPUs that were not "older".
> 
> Any CPU not on that list is out of servicing period.

Perfect!  Thanks, Tony!
