Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645E249E3C5
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiA0NnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:43:14 -0500
Received: from mga04.intel.com ([192.55.52.120]:11195 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbiA0NnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 08:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643290994; x=1674826994;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=T3jge4M1H+sDr7MteSE5XID5ZBBUEb8nGJFq+vwNK+8=;
  b=Jvfadtvq6PDSKXbLx0zdAb9eLY8UYuNGSAH/f3TIbh8W+BcCdRbvjQYO
   QbuCIc8xwJIY/iCjvm+9TlKzLTkSqHqWfNGQLSv0dHJh61w2yF0mxAVkI
   PBOEcwxx5BDwxbrtF2laUbGggRZLHmJ/cXF+QvvWsT1egDzHwzfqhtV1c
   ce+lE/n0g59DWp+nUpEOEVsmWPzmD6yM0tqgnA6tpH9HXDauayFnnoBxM
   krViHLXwOeQQXrf89Hn1hVAJe1HYsIgu4TXtVYn4J2+AcKAc0UoGP4EhZ
   i3toALQ+22MdWWRHKM6Z5Baq4wV/dsbWJADzXaNqMuZmKVsW3bLMdtODP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245688934"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="245688934"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:43:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="563786907"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 27 Jan 2022 05:43:11 -0800
Subject: Re: [PATCH v5] xhci: re-initialize the HC during resume if HCE was
 set
To:     Puma Hsu <pumahsu@google.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     s.shtylyov@omp.ru, albertccwang@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220119064013.1381172-1-pumahsu@google.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <e2baf3c5-0d80-9143-5fec-98a9e1474068@linux.intel.com>
Date:   Thu, 27 Jan 2022 15:44:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220119064013.1381172-1-pumahsu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.1.2022 8.40, Puma Hsu wrote:
> When HCE(Host Controller Error) is set, it means an internal
> error condition has been detected. Software needs to re-initialize
> the HC, so add this check in xhci resume.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Puma Hsu <pumahsu@google.com>
> ---
> v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> v3: Add stable@vger.kernel.org for stable release.
> v4: Refine the commit message.
> v5: Add a debug log. Follow Mathias Nyman <mathias.nyman@linux.intel.com>'s comment.
> 
>  drivers/usb/host/xhci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index dc357cabb265..41f594f0f73f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1146,8 +1146,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  		temp = readl(&xhci->op_regs->status);
>  	}
>  
> -	/* If restore operation fails, re-initialize the HC during resume */
> -	if ((temp & STS_SRE) || hibernated) {
> +	/* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> +	if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
> +		xhci_warn(xhci, "re-initialize HC during resume, USBSTS:%s\n",
> +			  xhci_decode_usbsts(str, temp));
>  
>  		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
>  				!(xhci_all_ports_seen_u0(xhci))) {
> 

Tried to compile, something is missing in this patch:

drivers/usb/host/xhci.c:1152:25: error: ‘str’ undeclared (first use in this function); did you mean ‘qstr’?

-Mathias
