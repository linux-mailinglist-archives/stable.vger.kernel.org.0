Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110B56EBE9E
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjDWKaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 06:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDWKaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 06:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8DE10F6
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 03:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39BF360BD3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 10:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F121C433EF;
        Sun, 23 Apr 2023 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682245822;
        bh=1txpGolm4A54/iSm+AjAiLizXcqfN8ZpH027fGeT7o4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xb/Sseo0mm6quihuwSUtRp8Rfh92PwljkOouMFfEFrt5lyHTjAbAnCIb5BYev4Psz
         A+ZaTe5u7Gx+pbwgqzBwI+ipyQ9w3mXsOUr00ekmRS/xj+naAcxfSG3vS2tKhtkYII
         3APCJ9MEXaXfAyKQ7b3+XW4buDlSxC8iB9CkCZjU=
Date:   Sun, 23 Apr 2023 12:30:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Hasemeyer <markhas@chromium.org>
Cc:     stable@vger.kernel.org, bhelgaas@google.com,
        kai.heng.feng@canonical.com
Subject: Re: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
Message-ID: <2023042354-enjoyment-promoter-9d54@gregkh>
References: <20230421184230.1468609-1-markhas@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421184230.1468609-1-markhas@chromium.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 12:42:30PM -0600, Mark Hasemeyer wrote:
> commit 08d0cc5f34265d1a1e3031f319f594bd1970976c upstream.
> 
> This change is desired because without it, it has been observed that
> re-applying aspm settings can cause the system to crash with certain pci
> devices (ie. Genesys GL9755).
> 
> Tested by issuing 100 suspend/resume cycles on a symptomatic system running
> 5.15.107.
> 
> L1 settings looked identical before and after:
> ```
> localhost ~ # lspci -vvv -d 0x17a0: | grep L1Sub
>                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
>                 L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
>                 L1SubCtl2: T_PwrOn=3100us
> ```
> 
> Cc: <stable@vger.kernel.org> # 5.15.y

Odd, it does not apply cleanly, so how was this tested?  Can you please
send the tested backport that you have so we know to get it correct?

thanks,

greg k-h
