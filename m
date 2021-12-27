Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1CF47FCB9
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhL0Mrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:47:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhL0Mrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:47:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC7960F3C
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9493AC36AEA;
        Mon, 27 Dec 2021 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640609258;
        bh=HFdIzjESYjGksRMdPCMq/H4rh/VAi6fyd8GqMvntZN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t00NGq1sdg9WWLUgSE13xXLWwL8FPb8eP3Lha0Rij+JqRJVRX0+qOCKW9cxpeMmuu
         uI8SH6rv0X+rmsLBhWRdsYkAzvk3qP3yK3/XWa1mLd+dj0+KtUxim110QhgIpigd7j
         AD+5DkRE2HwAau1MdyQN6Jcm06vhhocITBtVHHWM=
Date:   Mon, 27 Dec 2021 13:47:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: Re: [RFC/PATCH for 4.4.y] usb: gadget: configfs: Fix use-after-free
 issue with udc_name
Message-ID: <Ycm151MQzlAC0tC3@kroah.com>
References: <20211223052626.1631331-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223052626.1631331-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 02:26:26PM +0900, Nobuhiro Iwamatsu wrote:
> From: Eddie Hung <eddie.hung@mediatek.com>
> 
> commit 64e6bbfff52db4bf6785fab9cffab850b2de6870 upstream.
> 
> There is a use-after-free issue, if access udc_name
> in function gadget_dev_desc_UDC_store after another context
> free udc_name in function unregister_gadget.
> 
> Context 1:
> gadget_dev_desc_UDC_store()->unregister_gadget()->
> free udc_name->set udc_name to NULL
> 
> Context 2:
> gadget_dev_desc_UDC_show()-> access udc_name
> 
> Call trace:
> dump_backtrace+0x0/0x340
> show_stack+0x14/0x1c
> dump_stack+0xe4/0x134
> print_address_description+0x78/0x478
> __kasan_report+0x270/0x2ec
> kasan_report+0x10/0x18
> __asan_report_load1_noabort+0x18/0x20
> string+0xf4/0x138
> vsnprintf+0x428/0x14d0
> sprintf+0xe4/0x12c
> gadget_dev_desc_UDC_show+0x54/0x64
> configfs_read_file+0x210/0x3a0
> __vfs_read+0xf0/0x49c
> vfs_read+0x130/0x2b4
> SyS_read+0x114/0x208
> el0_svc_naked+0x34/0x38
> 
> Add mutex_lock to protect this kind of scenario.
> 
> Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Peter Chen <peter.chen@nxp.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/1609239215-21819-1-git-send-email-macpaul.lin@mediatek.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [Reference: CVE-2021-39648]
> [iwamatsu: struct usb_gadget_driver does not have udc_name variable.
>            Change struct gadget_info's udc_name.]
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/usb/gadget/configfs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
