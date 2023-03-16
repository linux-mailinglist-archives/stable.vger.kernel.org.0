Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5066BC70C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCPH2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCPH2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAED019136
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 00:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7848061F46
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64002C433D2;
        Thu, 16 Mar 2023 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678951691;
        bh=G7OT7fCMtljDalZeZojsg64W7lG2Vni4b4UvuGC2MdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGgdX/7FoTF0LEre2lNGfE15xv5QHBeS5wBvxkqTyPX0bimgNW5yNzD3SRFJsz/kG
         gI1LMm3BfZLUVt48A9btviKOtoLkBQ/truzuA019fzwq6RsEqsy/HWmtXtNEIqQh/Q
         qG31l8nmvRTZlSao3UB2ukUPIICdDm+51vEvk+lI=
Date:   Thu, 16 Mar 2023 08:28:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 132/141] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Message-ID: <ZBLFCUqQ8yUv6ZC8@kroah.com>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.996651796@linuxfoundation.org>
 <20230315111104-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315111104-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 11:11:44AM -0400, Michael S. Tsirkin wrote:
> On Wed, Mar 15, 2023 at 01:13:55PM +0100, Greg Kroah-Hartman wrote:
> > From: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > 
> > [ Upstream commit d089d69cc1f824936eeaa4fa172f8fa1a0949eaa ]
> > 
> > This patch fixes a FLR bug on the SNET DPU rev 1 by setting the
> > PCI_DEV_FLAGS_NO_FLR_RESET flag.
> > 
> > As there is a quirk to avoid FLR (quirk_no_flr), I added a new quirk
> > to check the rev ID before calling to quirk_no_flr.
> > 
> > Without this patch, a SNET DPU rev 1 may hang when FLR is applied.
> > 
> > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Message-Id: <20230110165638.123745-3-alvaro.karsz@solid-run.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This is ony needed if the SNET driver is included but
> isn't it all just for 6.3?

Good point, that wasn't very obvious and this looked like "just another
quirk to add" patch.  I'll go drop this from all queues now, thanks.

greg k-h
