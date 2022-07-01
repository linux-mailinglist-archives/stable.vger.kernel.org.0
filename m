Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2773F562B39
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 08:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiGAGIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 02:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiGAGIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 02:08:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8766D6;
        Thu, 30 Jun 2022 23:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 561C262370;
        Fri,  1 Jul 2022 06:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67621C341C6;
        Fri,  1 Jul 2022 06:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656655720;
        bh=SJY2y+4AHGbGqId/Yqzi0nXIqSZGdVn7bo2Ut5EnTeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/dNTzqzyUMU3teZ+tR94lW9spVA62ptBbJBQGiB897uV6D1jOhdPFtSE0O2o9QDz
         ernkT4vmY7/o+q410nZZq5nKmGWy6ClLyIWzUaAwrzmWc94j/wX/dlf8N3HS4/W8ou
         lbwYZ4/iUg3VAztpgR1s0cDN43lCfqGkPrvaRX9k=
Date:   Fri, 1 Jul 2022 08:08:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jack Pham <quic_jackp@quicinc.com>
Subject: Re: [PATCH v1] usb: typec: add missing uevent when partner support PD
Message-ID: <Yr6PZaWNtHYfRfQf@kroah.com>
References: <1656637315-31229-1-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656637315-31229-1-git-send-email-quic_linyyuan@quicinc.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 09:01:55AM +0800, Linyu Yuan wrote:
> In typec_set_pwr_opmode(), if partner support PD, it need to send uevent.

I do not understand, you need to explain this better.

> Cc: stable@vger.kernel.org

What commit does this fix?

> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
> ---
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

Why is this needed?  Who will recieve this uevent?  What will happen
when the uevent is sent?  What userspace code requires this?

thanks,

greg k-h
