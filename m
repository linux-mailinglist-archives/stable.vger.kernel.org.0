Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454436128A5
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 08:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJ3HWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 03:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJ3HWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 03:22:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD4223B
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 00:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA61A60B21
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 07:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2734C433C1;
        Sun, 30 Oct 2022 07:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667114571;
        bh=yheFsFZ2Ah8Or5SVyiKvAVLscycXQYEEnL6fIMGZb1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYal6bQ1LR2P/3RIn2ysQyobHgMGa86N0KBX1c3yCoAVczWLYeX5y5oNhNO3MAZ3z
         1d47IGZFMGxQC8aqFftblY0pw1DePEVBZvnfLd9oHSUGB//CpLFKIwf9sChsuQo72x
         SnGwy1tBgkUsB6w91XkjTPFNegOSS87Vz42vzYuw=
Date:   Sun, 30 Oct 2022 08:23:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jaak Ristioja <jaak@ristioja.ee>
Cc:     stable@vger.kernel.org
Subject: Re: drivers/platform/x86/amd/pmc.c compile error in 6.0.6
Message-ID: <Y14mgmo+ZEKTR4/v@kroah.com>
References: <d166779c-a845-2483-41c6-4cd7e06c22c3@ristioja.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d166779c-a845-2483-41c6-4cd7e06c22c3@ristioja.ee>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 30, 2022 at 01:51:59AM +0300, Jaak Ristioja wrote:
> Hello,
> 
> The following error popped up when compiling Linux kernel version 6.0.6:
> 
> drivers/platform/x86/amd/pmc.c: In function 'amd_pmc_verify_czn_rtc':
> drivers/platform/x86/amd/pmc.c:640:22: error: implicit declaration of
> function 'amd_pmc_get_smu_version' [-Werror=implicit-function-declaration]
>   640 |                 rc = amd_pmc_get_smu_version(pdev);
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~
> 
> This function call was introduced backported with commit e9847175b266 with
> the subject line "platform/x86/amd: pmc: Read SMU version during suspend on
> Cezanne systems".
> 
> Please note that amd_pmc_get_smu_version() is defined in an #ifdef
> CONFIG_DEBUG_FS block, but the new function call is compiled regardless of
> CONFIG_DEBUG_FS, causing the aforementioned error when building without the
> Debug Filesystem.

Ah, good catch.  Is this issue also there in Linus's tree?  If not, any
hint on what commit fixed it?

thanks,

greg k-h
