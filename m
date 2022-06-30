Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F32C56195E
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiF3LjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiF3LjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9810523AA
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5296060FC7
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC4CC34115;
        Thu, 30 Jun 2022 11:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656589148;
        bh=HK1HsPOlNeQ2aUwryxEDAxkRyKKvCTY3TnwXCRVXZQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9dD9eZ070FhfWUim8J7fVvEWAmqxjZVFCXEe9MK2Wo8wH8NbgEC0YL9lgWf9BpxK
         DUrlqniK8iygIQ1CfUlw3QrTr50MZpvDj4bbOFAxwnUvn9f1rxy1p3dFRC6ZbhVchX
         FYbFksAJEzi3lSDiBgwRTQqnUGMG1fxlQ+cChD8A=
Date:   Thu, 30 Jun 2022 13:39:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc:     stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Nathaniel Filardo <nwfilardo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH for v5.15+] powerpc: Export mmu_feature_keys[] as non-GPL
Message-ID: <Yr2LWoyFc4Z/iCOz@kroah.com>
References: <20220629093736.268003-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629093736.268003-1-dimitri.ledkov@canonical.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 10:37:36AM +0100, Dimitri John Ledkov wrote:
> From: Kevin Hao <haokexin@gmail.com>
> 
> commit d9e5c3e9e75162f845880535957b7fd0b4637d23 upstream.
> 
> When the mmu_feature_keys[] was introduced in the commit c12e6f24d413
> ("powerpc: Add option to use jump label for mmu_has_feature()"),
> it is unlikely that it would be used either directly or indirectly in
> the out of tree modules. So we exported it as GPL only.
> 
> But with the evolution of the codes, especially the PPC_KUAP support, it
> may be indirectly referenced by some primitive macro or inline functions
> such as get_user() or __copy_from_user_inatomic(), this will make it
> impossible to build many non GPL modules (such as ZFS) on ppc
> architecture. Fix this by exposing the mmu_feature_keys[] to the non-GPL
> modules too.
> 
> Fixes: 7613f5a66bec ("powerpc/64s/kuap: Use mmu_has_feature()")
> Reported-by: Nathaniel Filardo <nwfilardo@gmail.com>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20220329085709.4132729-1-haokexin@gmail.com
> 
> Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> ---
> 
>  Please apply this patch to v5.15+ as it unbreaks zfs-dkms usage on
>  powerpc platforms.

Sorry, but for obvious reasons, I am not allowed to do anything related
to zfs code.  Please feel free to keep this in your distro kernel if you
need it there.

greg k-h
