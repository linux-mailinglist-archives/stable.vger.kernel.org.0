Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC7C6D8F6B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbjDFG3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbjDFG3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:29:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F2B9011;
        Wed,  5 Apr 2023 23:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A3E461A36;
        Thu,  6 Apr 2023 06:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A39C433EF;
        Thu,  6 Apr 2023 06:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680762582;
        bh=x5miUEFRGRABKM7T3QNdRkXo6e+VmkF7ljbww95aenQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y4MgTOyGXuhsEQW43AlnaqF/y/RA9p1Hj7DYxgAoI/i7vCf9E8kTOvwxWsCNTtDqC
         mFyK2A9thYRrECZAoAyl9jUN0AxGE3js8EZn1Lgdthf4H4lNV/5ikTCaFyxgOQ1Ldn
         MqfgKhHfrdvd6IpcWNwJcsoxbFnkuU1lT8kFKQJw=
Date:   Thu, 6 Apr 2023 08:29:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
Message-ID: <ZC5m0onNYztT4Zbl@kroah.com>
References: <20230406061905.2460827-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406061905.2460827-1-badhri@google.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 06:19:04AM +0000, Badhri Jagan Sridharan wrote:
> usb_udc_connect_control does not check to see if the udc
> has already been started. This causes gadget->ops->pullup
> to be called through usb_gadget_connect when invoked
> from usb_udc_vbus_handler even before usb_gadget_udc_start
> is called. Guard this by checking for udc->started in
> usb_udc_connect_control before invoking usb_gadget_connect.
> 
> Guarding udc_connect_control, udc->started and udc->vbus
> with its own mutex as usb_udc_connect_control_locked
> can be simulataneously invoked from different code paths.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")
> ---
>  drivers/usb/gadget/udc/core.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Why resend v1 when it's been reviewed already?

confused,

greg k-h
