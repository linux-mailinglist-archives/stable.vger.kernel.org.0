Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C64C49089D
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 13:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiAQMXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 07:23:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:27708 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239588AbiAQMX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jan 2022 07:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642422209; x=1673958209;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7qgtDhFYqtyV75FVvzgVQnoln6aCvcYogDhoI1pjh38=;
  b=Efc9uyYPULax0S2Jbs/xm4suxL/ND0mToRKvbLob+4cfmn7QUM8EJLsn
   0rfRVvVnuRkAdH1gzL8kYptL8qc8CzS82bxX/s6LIVU7Xayn9IUs3uhQ4
   YEd6FqsWVIV6s0rCFkKRctiOw7GpmsHOLHUZkEHRgNN8JdqwcZ9GYaKRe
   pnpf9JmDJ+ihNm4y7bODBeo/lVGmz9jBT2nnN0RmLuRfu/tt4f1jrXivw
   P8RvK7cRhpw7J7EiHl3OGQM3/kM6Px68Q01VsmmpFCUYaeZp8jnGC//Zo
   wIdhfoAs+YZE5SA6is+u+4fWgV9vADUh3PnqmrMXcF4ydo816tXcqWLqH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="224592813"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="224592813"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 04:23:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="625176278"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga004.jf.intel.com with ESMTP; 17 Jan 2022 04:23:26 -0800
Subject: Re: [PATCH v4] xhci: re-initialize the HC during resume if HCE was
 set
To:     Puma Hsu <pumahsu@google.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     s.shtylyov@omp.ru, albertccwang@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220117053918.671399-1-pumahsu@google.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <f6d19871-a9d0-85a8-d834-f8f8198cbe15@linux.intel.com>
Date:   Mon, 17 Jan 2022 14:24:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220117053918.671399-1-pumahsu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.1.2022 7.39, Puma Hsu wrote:
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
> 
>  drivers/usb/host/xhci.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index dc357cabb265..ab440ce8420f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1146,8 +1146,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  		temp = readl(&xhci->op_regs->status);
>  	}
>  
> -	/* If restore operation fails, re-initialize the HC during resume */
> -	if ((temp & STS_SRE) || hibernated) {
> +	/* If restore operation fails or HC error is detected, re-initialize the HC during resume */
> +	if ((temp & (STS_SRE | STS_HCE)) || hibernated) {

Add a debug message in case we reset due to HCE

-Mathias  
