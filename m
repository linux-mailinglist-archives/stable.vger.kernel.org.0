Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BEE589B35
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiHDLuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiHDLuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 07:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD9EBF5E
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 04:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C96C6172C
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6A6C433D7;
        Thu,  4 Aug 2022 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659613820;
        bh=+TlsyeDqCEJGAdwj6cWeGFMcJHUFJB98YxysM/YpAig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtKr4aUkd+uzyV8Stp2NBxr1tBHSmn6TtGIgG+jLF03DFHSfMNxgulVZWwRJKAhyP
         Ub0hTb+wbzxkoIKZNGmcpzAgH48p852mKToEXCdLPHWMz3sjSc1MBiwZZOqegZN/kJ
         biyUgCpPkyRB0J2hYG2Vs6pPsV+K8X+9NsSrhFYM=
Date:   Thu, 4 Aug 2022 13:50:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chen Jun <chenjun102@huawei.com>
Cc:     stable@vger.kernel.org, deller@gmx.de, geert@linux-m68k.org,
        b.zolnierkie@samsung.com, xuqiang36@huawei.com
Subject: Re: [PATCH stable 4.14 v2 2/3] fbcon: Prevent that screen size is
 smaller than font size
Message-ID: <YuuyebRA0slDJVwx@kroah.com>
References: <20220804111539.96424-1-chenjun102@huawei.com>
 <20220804111539.96424-3-chenjun102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804111539.96424-3-chenjun102@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 11:15:38AM +0000, Chen Jun wrote:
> From: Helge Deller <deller@gmx.de>
> 
> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
> 
> We need to prevent that users configure a screen size which is smaller than the
> currently selected font size. Otherwise rendering chars on the screen will
> access memory outside the graphics memory region.
> 
> This patch adds a new function fbcon_modechange_possible() which
> implements this check and which later may be extended with other checks
> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
> for a too small screen size.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
> [sudip: adjust context]

Who is "sudip" here?

And the Link: line wasn't in the original commit, where did that come
from?

thanks,

greg k-h
