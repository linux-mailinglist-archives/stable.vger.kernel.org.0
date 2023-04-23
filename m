Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7026EC1C6
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 21:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDWTOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 15:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWTOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 15:14:42 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8A8BC10E6
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:14:40 -0700 (PDT)
Received: (qmail 6389 invoked by uid 1000); 23 Apr 2023 14:14:38 -0400
Date:   Sun, 23 Apr 2023 14:14:38 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tonywwang@zhaoxin.com,
        weitaowang@zhaoxin.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] UHCI:adjust zhaoxin UHCI controllers OverCurrent bit
 value
Message-ID: <75fa0424-d0e5-4d7d-a553-55f11218f960@rowland.harvard.edu>
References: <20230423105952.4526-1-WeitaoWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423105952.4526-1-WeitaoWang-oc@zhaoxin.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 23, 2023 at 06:59:52PM +0800, Weitao Wang wrote:
> OverCurrent condition is not standardized in the UHCI spec.
> Zhaoxin UHCI controllers report OverCurrent bit active off.
> In order to handle OverCurrent condition correctly, the uhci-hcd
> driver needs to be told to expect the active-off behavior.
> 
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: stable@vger.kernel.org
> Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
> ---
> v2->v3
>  - Change patch code style.
> 
>  drivers/usb/host/uhci-pci.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
> index 3592f757fe05..7bd2fddde770 100644
> --- a/drivers/usb/host/uhci-pci.c
> +++ b/drivers/usb/host/uhci-pci.c
> @@ -119,11 +119,13 @@ static int uhci_pci_init(struct usb_hcd *hcd)
>  
>  	uhci->rh_numports = uhci_count_ports(hcd);
>  
> -	/* Intel controllers report the OverCurrent bit active on.
> -	 * VIA controllers report it active off, so we'll adjust the
> -	 * bit value.  (It's not standardized in the UHCI spec.)
> +	/*
> +	 * Intel controllers report the OverCurrent bit active on.  VIA
> +	 * and ZHAOXIN controllers report it active off, so we'll adjust
> +	 * the bit value.  (It's not standardized in the UHCI spec.)
>  	 */
> -	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA)
> +	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA ||
> +			to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_ZHAOXIN)
>  		uhci->oc_low = 1;
>  
>  	/* HP's server management chip requires a longer port reset delay. */

Acked-by: Alan Stern <stern@rowland.harvard.edu>
