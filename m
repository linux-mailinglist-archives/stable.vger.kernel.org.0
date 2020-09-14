Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E552693CF
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINRnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:43:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:35229 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgINMRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 08:17:32 -0400
IronPort-SDR: TQWMj1zEqCU+fIadJbMG6FpQI/GUmzIOQlry1N6Wwk06k+mEz/y6/r/X/iP7/AAR+G6pbjxxj6
 IqrbhcJJ80fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9743"; a="146757109"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="146757109"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 05:14:29 -0700
IronPort-SDR: b34j+gzHlZXBkLI/FcXPAtUYFIqWzDW7HliECCjA8xKGFgDYjZuazHgtOMHX0l8CvBTyNIsh04
 aK34YPhcYfsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="408839789"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 14 Sep 2020 05:14:26 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 14 Sep 2020 15:14:25 +0300
Date:   Mon, 14 Sep 2020 15:14:25 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     linux-usb@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method
 for PM functionality
Message-ID: <20200914121425.GA810499@kuha.fi.intel.com>
References: <20200821131101.81915-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821131101.81915-1-heikki.krogerus@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Felipe,

On Fri, Aug 21, 2020 at 04:11:01PM +0300, Heikki Krogerus wrote:
> From: Raymond Tan <raymond.tan@intel.com>
> 
> Similar to some other IA platforms, Elkhart Lake too depends on the
> PMU register write to request transition of Dx power state.
> 
> Thus, we add the PCI_DEVICE_ID_INTEL_EHLLP to the list of devices that
> shall execute the ACPI _DSM method during D0/D3 sequence.
>a 
> [heikki.krogerus@linux.intel.com: included Fixes tag]
> 
> Fixes: dbb0569de852 ("usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/usb/dwc3/dwc3-pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index f5a61f57c74f0..242b6210380a4 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -147,7 +147,8 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
>  
>  	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
>  		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
> -				pdev->device == PCI_DEVICE_ID_INTEL_BXT_M) {
> +		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
> +		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
>  			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
>  			dwc->has_dsm_for_pm = true;
>  		}

I think this has gone under your radar. Let me know if you want
anything to be changed.

thanks,

-- 
heikki
