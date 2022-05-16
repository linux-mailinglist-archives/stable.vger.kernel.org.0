Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6842B528372
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 13:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiEPLpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 07:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiEPLpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 07:45:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E83DFBF;
        Mon, 16 May 2022 04:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BAECB810DF;
        Mon, 16 May 2022 11:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AC9C385AA;
        Mon, 16 May 2022 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652701497;
        bh=1/FDxy2CAaHH3ifNaeWDSyCbylIpRpLLo9WGNNpQnTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBDSx2JnqLxlx+IIVLoBSW/Orox5T3+4msweStgIKmKa9/dCQ+fqGdebr68e9Tucr
         Qew11AIMzT6W5Ftyf4k8GK1JloTqdsNcptkbF/j2UBzL2oVZUoSLmeHawCF02Riw+A
         PWB2pRXWe481WL0pPFN4Eqz0OoT66/Pq9QdZVq2s=
Date:   Mon, 16 May 2022 13:44:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael =?iso-8859-1?Q?Niew=F6hner?= <linux@mniewoehner.de>
Cc:     Alex Hung <alex.hung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86: intel-hid: fix _DSM function index handling
Message-ID: <YoI5NvHiihliSO/g@kroah.com>
References: <50eb664046b0d036a434c4a602087b791b6e796f.camel@mniewoehner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50eb664046b0d036a434c4a602087b791b6e796f.camel@mniewoehner.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 12:23:22PM +0200, Michael Niewöhner wrote:
> intel_hid_dsm_fn_mask is a bit mask containing one bit for each function
> index. Fix the function index check in intel_hid_evaluate_method
> accordingly, which was missed in commit 97ab4516205e ("platform/x86:
> intel-hid: fix _DSM function index handling").
> 
> Signed-off-by: Michael Niewöhner <linux@mniewoehner.de>
> ---
>  drivers/platform/x86/intel/hid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
> index 13f8cf70b9ae..5c39d40a701b 100644
> --- a/drivers/platform/x86/intel/hid.c
> +++ b/drivers/platform/x86/intel/hid.c
> @@ -238,7 +238,7 @@ static bool intel_hid_evaluate_method(acpi_handle handle,
>  
>         method_name = (char *)intel_hid_dsm_fn_to_method[fn_index];
>  
> -       if (!(intel_hid_dsm_fn_mask & fn_index))
> +       if (!(intel_hid_dsm_fn_mask & BIT(fn_index)))
>                 goto skip_dsm_eval;
>  
>         obj = acpi_evaluate_dsm_typed(handle, &intel_dsm_guid,
> -- 
> 2.34.1
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
