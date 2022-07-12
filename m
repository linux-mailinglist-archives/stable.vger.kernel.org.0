Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67503571443
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiGLITf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 04:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiGLITf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 04:19:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5156D3193D;
        Tue, 12 Jul 2022 01:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657613974; x=1689149974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3w9g1YdrAGLCvz4wcpaVFr3lu+lvf+86TPAIQcrQIxk=;
  b=GqlDQB4EQCFa+ivfUPJEC8HtnDDiAUm3pFWnvpK6xXU0wkXWdMWt+Tx1
   HvJrmSaZK4s+3nOV5qwwEOi1YK4FtSgOsFVIzdNGSQPjiRoRJevUvXkXQ
   IY8hCIxN0gfd8FcDaDlZoC8IbLckYedrgL9byv+JOgEOrlKljBprymQFf
   4xJq5URknWu5zppOkg6nqocm7iKwhoG366nqmloPYPeB9Jjowjfq9ee25
   ujn4P2/EZZZiwkHv8iwDT+h5JQK6VjFXODiEwi1SMg1W2/dPiZTmUTu3C
   sn8pGKSYAJY2o4wKDdnTjPMzjEnRB6N86lfv38IG44zLC19p4mg9yXOoE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346555441"
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="346555441"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 01:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="737398374"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Jul 2022 01:19:31 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 12 Jul 2022 11:19:30 +0300
Date:   Tue, 12 Jul 2022 11:19:30 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jack Pham <quic_jackp@quicinc.com>
Subject: Re: [PATCH v2] usb: typec: add missing uevent when partner support PD
Message-ID: <Ys0ukvuRy/JM29C2@kuha.fi.intel.com>
References: <1656662934-10226-1-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656662934-10226-1-git-send-email-quic_linyyuan@quicinc.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fri, Jul 01, 2022 at 04:08:54PM +0800, Linyu Yuan kirjoitti:
> System like Android allow user control power role from UI, it is possible
> to implement application base on typec uevent to refresh UI, but found
> there is chance that UI show different state from typec attribute file.
> 
> In typec_set_pwr_opmode(), when partner support PD, there is no uevent
> send to user space which cause the problem.
> 
> Fix it by sending uevent notification when change power mode to PD.
> 
> Fixes: bdecb33af34f ("usb: typec: API for controlling USB Type-C Multiplexers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> v2: (v1 https://lore.kernel.org/linux-usb/1656637315-31229-1-git-send-email-quic_linyyuan@quicinc.com/)
>     fix review comment from Greg,
>     add Fixes tag,
>     improve commit description.
> 
>  drivers/usb/typec/class.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
> index bbc46b1..3da94f712 100644
> --- a/drivers/usb/typec/class.c
> +++ b/drivers/usb/typec/class.c
> @@ -1851,6 +1851,7 @@ void typec_set_pwr_opmode(struct typec_port *port,
>  			partner->usb_pd = 1;
>  			sysfs_notify(&partner_dev->kobj, NULL,
>  				     "supports_usb_power_delivery");
> +			kobject_uevent(&partner_dev->kobj, KOBJ_CHANGE);
>  		}
>  		put_device(partner_dev);
>  	}
> -- 
> 2.7.4

-- 
heikki
