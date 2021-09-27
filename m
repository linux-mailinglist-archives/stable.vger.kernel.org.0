Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89F041A34B
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhI0Wug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 18:50:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58226 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhI0Wug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 18:50:36 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D81E41FF8A;
        Mon, 27 Sep 2021 22:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632782936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9BjG+Sn73sd4tOZdkYDhYuLZJu6z/TivQoj4hG8giI=;
        b=DK+2Ga2vFlZie8FY+qH37T6OLU0NdjjNPNBXebTveFMun26i2squCYsAURO73mFBaKYON7
        wYeOhxq4wx1OiInXbeistCsC4IjcXWaumyxu4f98UU6jEOuv2/8fRvqHGMIHL5P7EeHJyF
        JlyDDY4nWhh9yHohJtMQS3aA59Q6TEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632782936;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9BjG+Sn73sd4tOZdkYDhYuLZJu6z/TivQoj4hG8giI=;
        b=yt/VkniRnOmv9yIBv+IpHGtwCDoYs/3g8ZRopd9eEQr4rn+Zsk9EhbsGG2WIP+q5HjdSnz
        R03kGMrum+QyTaCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C69CB132D4;
        Mon, 27 Sep 2021 22:48:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yJyhMFhKUmGjDwAAMHmgww
        (envelope-from <bp@suse.de>); Mon, 27 Sep 2021 22:48:56 +0000
Date:   Tue, 28 Sep 2021 00:48:56 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     lakshmi.sai.krishna.potthuri@xilinx.com,
        shubhrajyoti.datta@xilinx.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] EDAC/synopsys: Fix wrong value type
 assignment for edac_mode" failed to apply to 4.19-stable tree
Message-ID: <YVJKWHUg8dR8mU/B@zn.tnic>
References: <163274045325350@kroah.com>
 <YVJJ/Zif2OzHB/z8@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVJJ/Zif2OzHB/z8@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 28, 2021 at 12:47:25AM +0200, Borislav Petkov wrote:
> On Mon, Sep 27, 2021 at 01:00:53PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> ---
> From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
> Date: Wed, 18 Aug 2021 12:53:14 +0530
> Subject: [PATCH] EDAC/synopsys: Fix wrong value type assignment for edac_mode
> 
> Upstream commit 5297cfa6bdf93e3889f78f9b482e2a595a376083.
> 
> dimm->edac_mode contains values of type enum edac_type - not the
> corresponding capability flags. Fix that.
> 
> Issue caught by Coverity check "enumerated type mixed with another
> type."
> 
>  [ bp: Rewrite commit message, add tags. ]
> 
> Fixes: ae9b56e3996d ("EDAC, synps: Add EDAC support for zynq ddr ecc controller")
> Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/20210818072315.15149-1-shubhrajyoti.datta@xilinx.com
> ---
>  drivers/edac/synopsys_edac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
> index 0c9c59e2b5a3..ba9de54a701e 100644
> --- a/drivers/edac/synopsys_edac.c
> +++ b/drivers/edac/synopsys_edac.c
> @@ -371,7 +371,7 @@ static int synps_edac_init_csrows(struct mem_ctl_info *mci)
>  
>  		for (j = 0; j < csi->nr_channels; j++) {
>  			dimm            = csi->channels[j]->dimm;
> -			dimm->edac_mode = EDAC_FLAG_SECDED;
> +			dimm->edac_mode = EDAC_SECDED;
>  			dimm->mtype     = synps_edac_get_mtype(priv->baseaddr);
>  			dimm->nr_pages  = (size >> PAGE_SHIFT) / csi->nr_channels;
>  			dimm->grain     = SYNPS_EDAC_ERR_GRAIN;
> -- 

... and you get the idea - just use this one for 4.9.y and 4.14.y - it
should apply cleanly there.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
