Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9663B51A5C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 20:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfFXSTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 14:19:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:50413 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfFXSTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 14:19:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 11:19:07 -0700
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="172073852"
Received: from rchatre-mobl.amr.corp.intel.com (HELO [10.24.14.145]) ([10.24.14.145])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 24 Jun 2019 11:19:07 -0700
Subject: Re: [PATCH] x86/resctrl: Prevent possible overrun during bitmap
 operations
To:     David Laight <David.Laight@ACULAB.COM>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
 <2b15f4ce814a425c8278e910289398c1@AcuMS.aculab.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <ad8c7da0-3ced-0cb7-2e74-135b30fe2b64@intel.com>
Date:   Mon, 24 Jun 2019 11:19:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <2b15f4ce814a425c8278e910289398c1@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On 6/24/2019 6:55 AM, David Laight wrote:
> From: Reinette Chatre
>> Sent: 19 June 2019 21:27
>>
>> While the DOC at the beginning of lib/bitmap.c explicitly states that
>> "The number of valid bits in a given bitmap does _not_ need to be an
>> exact multiple of BITS_PER_LONG.", some of the bitmap operations do
>> indeed access BITS_PER_LONG portions of the provided bitmap no matter
>> the size of the provided bitmap. For example, if find_first_bit()
>> is provided with an 8 bit bitmap the operation will access
>> BITS_PER_LONG bits from the provided bitmap. While the operation
>> ensures that these extra bits do not affect the result, the memory
>> is still accessed.
> 
> I suspect that comment also needs correcting.
> On BE systems you really do need to have a array of longs.
> 

Thank you very much for taking a look. I believe that the lib/bitmap.c
documentation is correct, it is me that misinterpreted it and to make
matters worse I only provided the portion I misinterpreted in my commit
message. Before the portion that I quote above it is stated clearly that
it is implemented using an array of unsigned longs.

Reinette



