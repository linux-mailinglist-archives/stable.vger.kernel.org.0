Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C397E420734
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJDIV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 04:21:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:13562 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhJDIVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 04:21:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="224098058"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="224098058"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 01:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="558287008"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Oct 2021 01:19:29 -0700
Subject: Re: [PATCH] xhci: Fix command ring pointer corruption while aborting
 a command
To:     Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jack Pham <jackp@codeaurora.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <1633072946-16826-1-git-send-email-pkondeti@codeaurora.org>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <8fe3756c-c927-4fd5-d5aa-163f9680fdb3@linux.intel.com>
Date:   Mon, 4 Oct 2021 11:22:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1633072946-16826-1-git-send-email-pkondeti@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1.10.2021 10.22, Pavankumar Kondeti wrote:
> The command ring pointer is located at [6:63] bits of the command
> ring control register (CRCR). All the control bits like command stop,
> abort are located at [0:3] bits. While aborting a command, we read the
> CRCR and set the abort bit and write to the CRCR. The read will always
> give command ring pointer as all zeros. So we essentially write only
> the control bits. Since we split the 64 bit write into two 32 bit writes,
> there is a possibility of xHC command ring stopped before the upper
> dword (all zeros) is written. If that happens, xHC updates the upper
> dword of its internal command ring pointer with all zeros. Next time,
> when the command ring is restarted, we see xHC memory access failures.
> Fix this issue by only writing to the lower dword of CRCR where all
> control bits are located.
> 
> Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>


Thanks, nice catch.

Adding to queue

-Mathias

