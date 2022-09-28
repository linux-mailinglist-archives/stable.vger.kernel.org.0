Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71895ED455
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 07:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiI1FtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 01:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiI1FtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 01:49:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B1910B5A6;
        Tue, 27 Sep 2022 22:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664344158; x=1695880158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tfSVNvkkkk7LUtDYvoTctVOoAlifpjBiL33IWI+E+oc=;
  b=kbu/R9nOh+hYpfGf+TsGI72qsD6RCMEc8qmNi+B11adzrNfxn39svlCB
   qOc3E7ykBCihUHQgpOsBxz3IqnSfOa/EqqYnmgBCpoe5V+w7d3Uh4qsjI
   pvIyT57ux4wsLV4QoHhWFwu/vn9jExB8nlzX2HpOJcvA2FeXjIkDPH2zN
   Qd9EBBYQT6/Co54aMU/OyBts+atHKAVKfwshkTCFA044H5h031o+rPD7N
   BjdTkeonOC1uiVvQ0x/6VpNXVSvw0L722wfmJa+IS8xt6CF+GgphM8fDZ
   YO3NWykn9JZYCdnjHXjVfOaQ/+oWQE8M+OGwBO/i0eLh6H7GqsHomiqS0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="281230311"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="281230311"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 22:49:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="624023897"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="624023897"
Received: from mylly.fi.intel.com (HELO [10.237.72.162]) ([10.237.72.162])
  by fmsmga007.fm.intel.com with ESMTP; 27 Sep 2022 22:49:15 -0700
Message-ID: <31477388-b57b-5383-9c6a-18905c28253e@linux.intel.com>
Date:   Wed, 28 Sep 2022 08:49:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH] i2c: designware: Fix handling of real but unexpected
 device interrupts
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
References: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
 <YzMKHf+aNKiGVkyn@smile.fi.intel.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <YzMKHf+aNKiGVkyn@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Hans

I forgot to Cc you yesterday even especially had a question for you :-(

Patch here and my comment to Andy below.

https://patchwork.ozlabs.org/project/linux-i2c/patch/20220927135644.1656369-1-jarkko.nikula@linux.intel.com/

On 9/27/22 17:35, Andy Shevchenko wrote:
> On Tue, Sep 27, 2022 at 04:56:44PM +0300, Jarkko Nikula wrote:
>>   #define STATUS_IDLE			0x0
> 
> A side note: I think the clearer is to use STATUS_MASK and use
> '&= ~STATUS_MASK' instead of '= STATUS_IDLE' in the affected pieces
> of the code.
> 
>> -#define STATUS_WRITE_IN_PROGRESS	0x1
>> -#define STATUS_READ_IN_PROGRESS		0x2
>> +#define STATUS_ACTIVE			0x1
>> +#define STATUS_WRITE_IN_PROGRESS	0x2
>> +#define STATUS_READ_IN_PROGRESS		0x4
> 
> Can we at the same time replace them with BIT()?
> 
> ...
> 
> Otherwise looks good to me,
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
Good points. I'll add these to follow up patches.

Jarkko
