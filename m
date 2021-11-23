Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9E459F16
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 10:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhKWJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 04:20:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:42710 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhKWJUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 04:20:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="321220014"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="321220014"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 01:17:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="650011034"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2021 01:17:03 -0800
Subject: Re: [RFT PATCH] usb: hub: Fix locking issues with address0_mutex
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
 <CGME20211122104844eucas1p193f1cdbe6255ccd2f945726711e719a4@eucas1p1.samsung.com>
 <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
 <22f12ed7-18f3-9800-3858-9738f9ccd1f2@samsung.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <e3be3b04-838a-2de6-2590-e2050af29b7d@linux.intel.com>
Date:   Tue, 23 Nov 2021 11:18:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <22f12ed7-18f3-9800-3858-9738f9ccd1f2@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.11.2021 14.27, Marek Szyprowski wrote:
> Hi,
> 
> On 22.11.2021 11:50, Mathias Nyman wrote:
>> Fix the circular lock dependency and unbalanced unlock of addess0_mutex
>> introduced when fixing an address0_mutex enumeration retry race in commit
>> ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
>>
>> Make sure locking order between port_dev->status_lock and address0_mutex
>> is correct, and that address0_mutex is not unlocked in hub_port_connect
>> "done:" codepath which may be reached without locking address0_mutex
>>
>> Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> This fixes the issue I've reported here: 
> https://lore.kernel.org/all/f3bfcbc7-f701-c74a-09bd-6491d4c8d863@samsung.com/
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thank you for testing, I'll add these tags

-Mathias
