Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE605EB38E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 23:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIZVtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiIZVtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 17:49:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA299792C4;
        Mon, 26 Sep 2022 14:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664228989; x=1695764989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7TT080Crbah1HOhPKORs2ZNGlgRDfHlqPppfwXjOuaw=;
  b=WC3tPOJEDMDsF2094BX8hZxagInet2gwyRd6qMxv46VJILgnRvo3XjYv
   zKXaurPI/mooTVTFrlhOMPqXn5aAWyVR1ceRRRuKY5LgRMY6ofUteuMWr
   eR68jX0a8x7XliyoeTjTfhEkSQZiUSM9Z69L3yhE03P8Kg4rfnZhA4ppS
   HcsbUUx0aM9saKbQIvmQvsyStuU4plxhwBALd2ycJpkdVRLL6o29DRrlo
   BKo9ojGsmzPHtUeWPMjl8lkn3JQNr4akIk9sXhWMGzRqJL9rVLc01YlrI
   7l9JZjaAnn3uN7rvkVkkmGJbHYsMB1btkAtTOFG+YrNcHA+bMcDqDp+tK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="362982005"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="362982005"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 14:49:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="763611668"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="763611668"
Received: from yzhou16-mobl.amr.corp.intel.com (HELO [10.209.44.81]) ([10.209.44.81])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 14:49:47 -0700
Message-ID: <faa01372-07b0-3438-9305-123a3de9cc47@intel.com>
Date:   Mon, 26 Sep 2022 14:49:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor idle: Practically limit "Dummy wait"
 workaround to old Intel systems
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-acpi@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        stable@vger.kernel.org
References: <20220922184745.3252932-1-dave.hansen@intel.com>
 <78d13a19-2806-c8af-573e-7f2625edfab8@intel.com>
 <54572271-d5ca-820f-911e-19fd9d80ae2c@intel.com>
 <edfe5f4c-70fa-5fcc-868f-497c428445f1@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <edfe5f4c-70fa-5fcc-868f-497c428445f1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/23/22 11:36, Kim Phillips wrote:
> Can it be cc:stable@vger.kernel.org, since it applies cleanly as far
> back as this v5.4 commit?:

I just sent the pull request to Linus for this fix.  I realized that I
didn't tag it for stable@.  If it gets applied, I'll send a request for
it to be picked up for stable@, via "Option 2":

> Option 2
> ********
> 
> After the patch has been merged to Linus' tree, send an email to
> stable@vger.kernel.org containing the subject of the patch, the commit ID,
> why you think it should be applied, and what kernel version you wish it to
> be applied to.

Sorry about that.
