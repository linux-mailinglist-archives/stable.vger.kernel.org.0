Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD9F506FE6
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 16:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343985AbiDSOQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 10:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345595AbiDSOQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 10:16:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D8739832;
        Tue, 19 Apr 2022 07:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20E0DCE193F;
        Tue, 19 Apr 2022 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36685C385A7;
        Tue, 19 Apr 2022 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650377597;
        bh=R8KduhrI7fUa5IQmNp8uDxPkJblKt+ZMaeMO9HQtrhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VNbU1PWJaWChwgcG9OFzTXGphfZDbMTNkVYhoD6zaM4M2DhsB8Npu8Ab5haV5DlTz
         bcSQ48oY3NQAlEnYC7oGrwGZYpSVJ8ibzpvb+MG5wxFd9B3iAPDC7vezpTuI4Cb9LZ
         JbEDibxz9mINmpUNS6dGHc8BspxGyAp3iDT/ree6Bp0gdHiwGt8kNHsFjQwiK0jEg+
         UkwNEvYBUCEau3qr6ZmJ3tBSZnlIwcY8fHOwDTO6GJUalFSFBSNh66Zp0idqKdjeTB
         cbdcar9jWnIkXId6+Fdj+IycXmxG3S9AEc/4vIbAviCZJ9vZ7a2/w//aKBeGnp41a+
         98DnQD/sWYgaw==
Date:   Tue, 19 Apr 2022 09:13:15 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Pavel Machek <pavel@denx.de>,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.10 126/599] PCI: pciehp: Clear cmd_busy bit in polling
 mode
Message-ID: <20220419141315.GA1197270@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409081314.GA19452@amd>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 09, 2022 at 10:13:15AM +0200, Pavel Machek wrote:
> > From: Liguang Zhang <zhangliguang@linux.alibaba.com>
> > 
> > commit 92912b175178c7e895f5e5e9f1e30ac30319162b upstream.
> > 
> > Writes to a Downstream Port's Slot Control register are PCIe hotplug
> > "commands."  If the Port supports Command Completed events, software must
> > wait for a command to complete before writing to Slot Control again.
> > 
> > pcie_do_write_cmd() sets ctrl->cmd_busy when it writes to Slot Control.  If
> > software notification is enabled, i.e., PCI_EXP_SLTCTL_HPIE and
> > PCI_EXP_SLTCTL_CCIE are set, ctrl->cmd_busy is cleared by pciehp_isr().
> > 
> > But when software notification is disabled, as it is when pcie_init()
> > powers off an empty slot, pcie_wait_cmd() uses pcie_poll_cmd() to poll for
> > command completion, and it neglects to clear ctrl->cmd_busy, which leads to
> > spurious timeouts:
> 
> I'm pretty sure this fixes the problem, but... it is still not fully
> correct.

Thanks, Pavel.  Liguang, Lukas, any comment?

> > +++ b/drivers/pci/hotplug/pciehp_hpc.c
> > @@ -98,6 +98,8 @@ static int pcie_poll_cmd(struct controll
> >  		if (slot_status & PCI_EXP_SLTSTA_CC) {
> >  			pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
> >  						   PCI_EXP_SLTSTA_CC);
> > +			ctrl->cmd_busy = 0;
> > +			smp_mb();
> >  			return 1;
> >  		}
> 
> Is the memory barrier neccessary? I don't see corresponding memory
> barrier for reading.
> 
> If it is neccessary, should we have WRITE_ONCE at the very least, or
> probably normal atomic operations?
> 
> Best regards,
> 								Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


