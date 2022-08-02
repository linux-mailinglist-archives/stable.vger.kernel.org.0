Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F25877AC
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 09:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiHBHRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 03:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHBHRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 03:17:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE73145F63;
        Tue,  2 Aug 2022 00:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659424628; x=1690960628;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EkQEdaF0PKFeFCAcHrRmmKAHg3afrB865tGwaTuNQFw=;
  b=dQIXi92KBkqcm29UFTAfQ68HcMrDyRjG0TVVgruiZKcKPw+1JhrkAxi0
   T07AJDfhDuqDCfuSqxgclnTK5ENIpW2wyUO6jLvzai+VJOSzOha5k2ztr
   8iZxfuACgiuXlSGnsqHOFNxb5kVzIFvB+NRC1cKR09oVBwdLk/ZwmQGf6
   6KaSjVC/5Afbc43JP4SEb/PSTdBE7RPw7b2ITtNb68WLnkZ6H0QuO/ITK
   8jf4Twj7P2qXuPc0tyFup784CIkVDrNYEK+uKukoCxMEuJPbhHTwagC0m
   yK+jcjW4T08RrU7hbX6GVvaft7lpf7JGYkODgFqBEebnce5Cvz9E3zxTL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="269110346"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="269110346"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="744570639"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 02 Aug 2022 00:17:06 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 02 Aug 2022 10:17:05 +0300
Date:   Tue, 2 Aug 2022 10:17:05 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jack Pham <quic_jackp@quicinc.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS
 command completion
Message-ID: <YujPcTrt7wZuM0LF@kuha.fi.intel.com>
References: <1658817949-4632-1-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658817949-4632-1-git-send-email-quic_linyyuan@quicinc.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 02:45:49PM +0800, Linyu Yuan wrote:
> We found PPM will not send any notification after it report error status
> and OPM issue GET_ERROR_STATUS command to read the details about error.
> 
> According UCSI spec, PPM may clear the Error Status Data after the OPM
> has acknowledged the command completion.
> 
> This change add operation to acknowledge the command completion from PPM.
> 
> Fixes: bdc62f2bae8f (usb: typec: ucsi: Simplified registration and I/O API)
> Cc: <stable@vger.kernel.org> # 5.10
> Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/ucsi/ucsi.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> index cbd862f..1aea464 100644
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -76,6 +76,10 @@ static int ucsi_read_error(struct ucsi *ucsi)
>  	if (ret)
>  		return ret;
>  
> +	ret = ucsi_acknowledge_command(ucsi);
> +	if (ret)
> +		return ret;
> +
>  	switch (error) {
>  	case UCSI_ERROR_INCOMPATIBLE_PARTNER:
>  		return -EOPNOTSUPP;

thanks,

-- 
heikki
