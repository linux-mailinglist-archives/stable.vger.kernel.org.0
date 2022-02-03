Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF04A86F3
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiBCOtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiBCOtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:49:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7FC061714;
        Thu,  3 Feb 2022 06:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 624DC61A59;
        Thu,  3 Feb 2022 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659F7C340E4;
        Thu,  3 Feb 2022 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643899775;
        bh=nBs8x83HOyc90AXXdJAiJ28Z/9QQ+iZ+wHguEiy9lbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gt0ZMon045DzkMA/0uwsOIqFumU1zpGVCqNpCJDGV08lBXSmcxVtvIb6hiCDsP762
         8CdbApLvUb51MvX5JiQFAi7PwBsEi1BrGIhAiNHJomoP+8kZXL5yUo15sMmYIsQ6dB
         rnZdqJC5OUeWIdnxe3PfM1RyzzPQGBQqZIsbp/gM=
Date:   Thu, 3 Feb 2022 15:49:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Joseph Bao <joseph.bao@intel.com>
Subject: Re: [PATCH 5.16 0873/1039] PCI: pciehp: Use
 down_read/write_nested(reset_lock) to fix lockdep errors
Message-ID: <YfvreKic+pYli+YK@kroah.com>
References: <20220124184154.642601971@linuxfoundation.org>
 <20220125122323.GA1597465@bhelgaas>
 <Ye/wPpOrCfmKYCEj@kroah.com>
 <20220202193613.GB18800@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202193613.GB18800@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 08:36:13PM +0100, Lukas Wunner wrote:
> On Tue, Jan 25, 2022 at 01:42:38PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Jan 25, 2022 at 06:23:23AM -0600, Bjorn Helgaas wrote:
> > > On Mon, Jan 24, 2022 at 07:44:22PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Hans de Goede <hdegoede@redhat.com>
> > > > 
> > > > commit 085a9f43433f30cbe8a1ade62d9d7827c3217f4d upstream.
> > > 
> > > I would hold off on backporting the pciehp changes until we resolve
> > > this regression in v5.17-rc1:
> > > 
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=215525
> > 
> > Thanks, I will drop it from all queues now.  If it gets resolved, please
> > email stable@vger and we will be glad to add it back, along with the
> > fix.
> 
> This turned out not to be an actual regression.  According to Bjorn,
> "it was arguably a bug that it *did* work before", see:
> 
> https://lore.kernel.org/linux-pci/20220202164308.GA17822@bhelgaas/
> 
> Also, the culprit was not pciehp, but rather a change to _OSC handling
> for VMD devices in commit 04b12ef163d1.
> 
> Thus, please consider re-adding these upstream commits to the stable queues:
> 
>   085a9f43433f30cbe8a1ade62d9d7827c3217f4d  (5.16, 5.15, 5.10)

Already in the 5.10.94 5.15.17 5.16.3 releases :)

>   23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12  (5.16, 5.15, 5.10, 5.4)

Now queued up, thanks.

greg k-h
