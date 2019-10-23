Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05738E1741
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 12:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390940AbfJWKDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 06:03:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:56935 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390897AbfJWKDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 06:03:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 03:03:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="223133571"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 23 Oct 2019 03:03:47 -0700
Subject: Re: [PATCH] usb: xhci: fix Immediate Data Transfer endianness
To:     Samuel Holland <samuel@sholland.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191020015313.4558-1-samuel@sholland.org>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <f5029323-9b3b-1c66-3c89-c3230d5a24ea@linux.intel.com>
Date:   Wed, 23 Oct 2019 13:05:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191020015313.4558-1-samuel@sholland.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.10.2019 4.53, Samuel Holland wrote:
> The arguments to queue_trb are always byteswapped to LE for placement in
> the ring, but this should not happen in the case of immediate data; the
> bytes copied out of transfer_buffer are already in the correct order.
> Add a complementary byteswap so the bytes end up in the ring correctly.
> 
> This was observed on BE ppc64 with a "Texas Instruments TUSB73x0
> SuperSpeed USB 3.0 xHCI Host Controller [104c:8241]" as a ch341
> usb-serial adapter ("1a86:7523 QinHeng Electronics HL-340 USB-Serial
> adapter") always transmitting the same character (generally NUL) over
> the serial link regardless of the key pressed.
> 

Thanks, nice catch.

It's unfortunate that we ended up with a situation where this fix is the
least intrusive one.
With IDT we would just want to memcpy() bytes an not care about endianness,
but on BE we end up storing data bytes in a u64, and start with a complementary u64
byteswap to counter a later u32 byteswap done after splitting the u64 to upper
and lower 32 bit parts.

This because that TRB field is normally used for 64bit data buffer pointers,
and all code is written to support that

adding to queue

-Mathias
