Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01A76A9AFE
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCCPrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCCPrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:47:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E072319B7
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 07:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680B861865
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 15:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830C5C433EF;
        Fri,  3 Mar 2023 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677858417;
        bh=SlTOoBa4evxK8eJPDazGkvC0uf62IEH3CLOw2F2kQJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1WmeogCYz0DlNTxXStBXehbWQTjo9L+DsZ/pYUwoCHKpOrKil1CGMx28zEEXP9Oi
         aHLV8VWlHg2Yl/Ha7FhWoOyCx8l2GrrQMuEGlb+5ThesupT0FUEfabxXVr8VRimd2w
         chuTfAYkR28EZ4R+VC2lv6lz49JyCgs/Pj9F8iIQ=
Date:   Fri, 3 Mar 2023 16:46:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefan Ghinea <stefan.ghinea@windriver.com>
Cc:     stable@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH 6.1 1/2] HID: asus: use spinlock to protect concurrent
 accesses
Message-ID: <ZAIWb0R0+wCoxnNd@kroah.com>
References: <20230301223853.28466-1-stefan.ghinea@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301223853.28466-1-stefan.ghinea@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 12:38:52AM +0200, Stefan Ghinea wrote:
> From: Pietro Borrello <borrello@diag.uniroma1.it>
> 
> commit 315c537068a13f0b5681d33dd045a912f4bece6f upstream
> 
> asus driver has a worker that may access data concurrently.
> Proct the accesses using a spinlock.
> 
> Fixes: af22a610bc38 ("HID: asus: support backlight on USB keyboards")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-4-7860c5763c38@diag.uniroma1.it
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>  drivers/hid/hid-asus.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)

What about 6.2.y as well?

Why skip that?

thanks,

greg k-h
