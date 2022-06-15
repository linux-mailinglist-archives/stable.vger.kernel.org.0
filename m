Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CF54C022
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 05:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346067AbiFODZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242783AbiFODZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 23:25:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D4A2EA2F;
        Tue, 14 Jun 2022 20:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655263509; x=1686799509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nfIkT7wPRcLTa+ExZuFEoTXQprLjk5Z6wnnNpzCnmyI=;
  b=DJtWj3DvyqJL715y8brO+KdR1W/ri/1eFT84fkjt/7tm9y6sysCcLr24
   hLbvnowvN1XxrjXHniisc86B1PjXT38XbL8LxUups5F5CXhI6qcYDDqRU
   IiMxHoaIBZwmTFOkpnPl/ul8Sk3rZIvaGNabaAaf6oKFd79b6nus8+L/c
   EuLCFr5uruBPjg3NqCVLsHRvgSp+5VvbOi4EThdcvyQ9YUqyOvn9sxf3D
   HYSZvUbuJbFrUADra+iKFEZ0myk9Cx8P0NHhgoy3eIZKNQYn4hff2AUqx
   s55Rg3oPIIEk1jnr4VReLksW6xFyNSnYW4y4J0aKaklApofTZekB+IsYu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="365166761"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="365166761"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 20:25:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640745354"
Received: from avogale-mobl1.amr.corp.intel.com (HELO guptapa-desk) ([10.212.205.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 20:25:08 -0700
Date:   Tue, 14 Jun 2022 20:25:07 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 5.18 01/11] Documentation: Add documentation for
 Processor MMIO Stale Data
Message-ID: <20220615032507.go6t24dyzotpe3xv@guptapa-desk>
References: <20220614183720.861582392@linuxfoundation.org>
 <20220614183721.248466580@linuxfoundation.org>
 <94468546-5571-b61f-0d98-8501626e30e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <94468546-5571-b61f-0d98-8501626e30e3@gmail.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 08:06:37AM +0700, Bagas Sanjaya wrote:
>On 6/15/22 01:40, Greg Kroah-Hartman wrote:
>> +  .. list-table::
>> +
>> +     * - 'Not affected'
>> +       - The processor is not vulnerable
>> +     * - 'Vulnerable'
>> +       - The processor is vulnerable, but no mitigation enabled
>> +     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
>> +       - The processor is vulnerable, but microcode is not updated. The
>> +         mitigation is enabled on a best effort basis.
>> +     * - 'Mitigation: Clear CPU buffers'
>> +       - The processor is vulnerable and the CPU buffer clearing mitigation is
>> +         enabled.
>> +
>> +If the processor is vulnerable then the following information is appended to
>> +the above information:
>> +
>> +  ========================  ===========================================
>> +  'SMT vulnerable'          SMT is enabled
>> +  'SMT disabled'            SMT is disabled
>> +  'SMT Host state unknown'  Kernel runs in a VM, Host SMT state unknown
>> +  ========================  ===========================================
>> +
>
>Why is list-table used in sysfs table instead of usual ASCII table in SMT
>vulnerabilities list above? I think using ASCII table in both cases is enough
>for the purpose.

Maybe you are right (and I am no expert in this), but quite a few
documents use list-table for sysfs status:

   https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/mds.rst
   https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/spectre.rst
   https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst
