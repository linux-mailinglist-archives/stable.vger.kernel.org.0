Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9489B51ED7A
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiEHMfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 08:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiEHMfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 08:35:08 -0400
X-Greylist: delayed 19087 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 May 2022 05:31:18 PDT
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85757BF53;
        Sun,  8 May 2022 05:31:18 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 7E21628004991;
        Sun,  8 May 2022 14:31:16 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 72166119437; Sun,  8 May 2022 14:31:16 +0200 (CEST)
Date:   Sun, 8 May 2022 14:31:16 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.10 126/599] PCI: pciehp: Clear cmd_busy bit in polling
 mode
Message-ID: <20220508123116.GA27352@wunner.de>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220405070302.589741179@linuxfoundation.org>
 <20220409081314.GA19452@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409081314.GA19452@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 09, 2022 at 10:13:15AM +0200, Pavel Machek wrote:
> > From: Liguang Zhang <zhangliguang@linux.alibaba.com>
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
> 
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

The cmd_busy flag is set by pcie_do_write_cmd() before writing the
Slot Control register and it is then cleared by pciehp_isr().

The purpose of the memory barriers is to ensure that order.
IOW, we want to avoid a scenario where the write to cmd_busy in
pcie_do_write_cmd() hasn't been committed to memory yet, the Slot Control
write is performed, an interrupt occurs and is handled, the interrupt
handler writes cmd_busy = 0 and only then is the cmd_busy = 1 write
in pcie_do_write_cmd() committed to memory.

That said, you're right that such a scenario is impossible if
cmd_busy is cleared by the synchronous pcie_poll_cmd()
instead of the asynchronous pciehp_isr().

Care to submit a patch to remove the memory barrier in this single
location?

A WRITE_ONCE() (i.e. a mere compiler barrier instead of a proper
cacheline flush) is not sufficient to avoid the above scenario.
An atomic bitop would work, but wouldn't offer advantages compared
to the status quo.

Thanks,

Lukas
