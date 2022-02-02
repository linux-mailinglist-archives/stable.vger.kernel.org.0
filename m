Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B354A7889
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 20:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346880AbiBBTL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 14:11:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:65517 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346879AbiBBTLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Feb 2022 14:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643829085; x=1675365085;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=04YNTjZ52QYkffJs25AZu4KFLG44YowR5bbPOEbkOxY=;
  b=fvswi80sqpszEaJLDJFDoWf8+UPMIq2HxB8MKfdXSmP5y7UGulvMFEcv
   xTD+4odI1ZafhhzykCniq4KDr7iJK5TNw9TqkjcZh70i8PceNACii8IaV
   h++XMLbOsu1XyuILD9YTgXlc2zcjpdaQHjAMKiiuz5EwroyNSOOMGU8ut
   EpXfqFst+f0ueZ5eIVegwFsbZQZhx+sjgyv4Wnsm+Q+z6f4TTc9UIfwS6
   AdmSrKeR6s727GBi5a0Rq48KncaORV7Ya+kMB8Sa9RTU7vKzc/hpKST1w
   dq8o6X9w7QYbCQe/i63657bA/i8sh3aY5igU3RKsWuOmANuxgv1PeYYVU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="246834634"
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="246834634"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:11:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="566126434"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2022 11:11:20 -0800
To:     Puma Hsu <pumahsu@google.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     s.shtylyov@omp.ru, albertccwang@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220129093036.488231-1-pumahsu@google.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH v6] xhci: re-initialize the HC during resume if HCE was
 set
Message-ID: <413ce7e5-1c35-c3d0-a89e-a3c7f03b4db7@linux.intel.com>
Date:   Wed, 2 Feb 2022 21:12:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220129093036.488231-1-pumahsu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.1.2022 11.30, Puma Hsu wrote:
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
> v6: Fix the missing declaration for str.
> 
>  drivers/usb/host/xhci.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index dc357cabb265..6f1198068004 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  	int			retval = 0;
>  	bool			comp_timer_running = false;
>  	bool			pending_portevent = false;
> +	char			str[XHCI_MSG_MAX];
>  
>  	if (!hcd->state)
>  		return 0;
> @@ -1146,8 +1147,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
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

Ended up modifying this patch a bit more than I first intended,
- don't print warning in hibernation case, only error.
- maybe using a lot of stack for a debug string isn't really needed.
- make sure we read the usbsts register before checking for the HCE bit.

Does the below work for you? If yes, and you agree I'll apply it instead

---

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dc357cabb265..04ec2de158bf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
        int                     retval = 0;
        bool                    comp_timer_running = false;
        bool                    pending_portevent = false;
+       bool                    reinit_xhc = false;
 
        if (!hcd->state)
                return 0;
@@ -1107,10 +1108,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
        set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
 
        spin_lock_irq(&xhci->lock);
-       if ((xhci->quirks & XHCI_RESET_ON_RESUME) || xhci->broken_suspend)
-               hibernated = true;
 
-       if (!hibernated) {
+       if (hibernated || xhci->quirks & XHCI_RESET_ON_RESUME || xhci->broken_suspend)
+               reinit_xhc = true;
+
+       if (!reinit_xhc) {
                /*
                 * Some controllers might lose power during suspend, so wait
                 * for controller not ready bit to clear, just as in xHC init.
@@ -1143,12 +1145,17 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
                        spin_unlock_irq(&xhci->lock);
                        return -ETIMEDOUT;
                }
-               temp = readl(&xhci->op_regs->status);
        }
 
-       /* If restore operation fails, re-initialize the HC during resume */
-       if ((temp & STS_SRE) || hibernated) {
+       temp = readl(&xhci->op_regs->status);
+
+       /* re-initialize the HC on Restore Error, or Host Controller Error */
+       if (temp & (STS_SRE | STS_HCE)) {
+               reinit_xhc = true;
+               xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+       }
 
+       if (reinit_xhc) {
                if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
                                !(xhci_all_ports_seen_u0(xhci))) {
                        del_timer_sync(&xhci->comp_mode_recovery_timer);

