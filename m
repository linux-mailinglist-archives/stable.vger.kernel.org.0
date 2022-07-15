Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DFF5763C1
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiGOOkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiGOOkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3141874DC0
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC9B9B82C15
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 14:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C58C34115;
        Fri, 15 Jul 2022 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657896015;
        bh=cY/SCVp++V7cecD2fwNyuX3UEE2GiPs3W0Lfn03gN0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xX1bVWZqIEutmPKy397khuo+nM5rJjRkyldd690X209qYof8dEcRV7C1MRB2tSFQ/
         D8qPRHQqOsQnS8cqT/BbQ7yuEfdziGxdepq3aswPDzbd7c0fY7C4Z++Llu+HvQJMSQ
         yuj774fnc9/c3MFf/F09HTL1w2cv9nT6sIgTa3QQ=
Date:   Fri, 15 Jul 2022 16:40:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Carl Vanderlip <quic_carlv@quicinc.com>
Cc:     stable@vger.kernel.org, Jeffrey Hugo <quic_jhugo@quicinc.com>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@microsoft.com, decui@microsoft.com,
        lorenzo.pieralisi@arm.com, robh@kernel.org, kw@linux.org,
        bhelgaas@google.com, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 5.18 1/4] PCI: hv: Fix multi-MSI to allow more than one
 MSI vector
Message-ID: <YtF8TJ4zIQykzsb2@kroah.com>
References: <20220713181254.5831-1-quic_carlv@quicinc.com>
 <20220713181254.5831-2-quic_carlv@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713181254.5831-2-quic_carlv@quicinc.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 06:12:51PM +0000, Carl Vanderlip wrote:
> From: Jeffrey Hugo <quic_jhugo@quicinc.com>
> 
> If the allocation of multiple MSI vectors for multi-MSI fails in the core
> PCI framework, the framework will retry the allocation as a single MSI
> vector, assuming that meets the min_vecs specified by the requesting
> driver.
> 
> Hyper-V advertises that multi-MSI is supported, but reuses the VECTOR
> domain to implement that for x86.  The VECTOR domain does not support
> multi-MSI, so the alloc will always fail and fallback to a single MSI
> allocation.
> 
> In short, Hyper-V advertises a capability it does not implement.
> 
> Hyper-V can support multi-MSI because it coordinates with the hypervisor
> to map the MSIs in the IOMMU's interrupt remapper, which is something the
> VECTOR domain does not have.  Therefore the fix is simple - copy what the
> x86 IOMMU drivers (AMD/Intel-IR) do by removing
> X86_IRQ_ALLOC_CONTIGUOUS_VECTORS after calling the VECTOR domain's
> pci_msi_prepare().
> 
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
> Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Link: https://lore.kernel.org/r/1649856981-14649-1-git-send-email-quic_jhugo@quicinc.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
> ---
>  drivers/pci/controller/pci-hyperv.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

You forgot to list the git commit id of this and the other commits here,
or anywhere else.  Please fix that up and resend the series.

thanks,

greg k-h
