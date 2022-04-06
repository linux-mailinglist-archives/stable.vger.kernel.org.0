Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8757A4F62E5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbiDFPQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiDFPQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:16:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18115267AEA;
        Wed,  6 Apr 2022 05:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5629BCE22F5;
        Wed,  6 Apr 2022 12:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4FFC385A1;
        Wed,  6 Apr 2022 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649246947;
        bh=ksBAr8NMYRRobAattf5M1b7e3FecoUcE07XRZT2Dck0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6+BNh3hZkJcNrIACGR//OU57LJSFiyPwSvuX2EPOpUAHfD0lLkCv5GiUSlyfVHmi
         /Ll2oo5Ym9IVrwqyhpexjl4bAu+2SpYCcYzfTjAhripG1XqB8DA4SnvHTN95JtulHa
         npX0tchFxvbu7aph/DjGTUNYI75p5HEY3G6LgjsI=
Date:   Wed, 6 Apr 2022 14:09:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH 5.16 0199/1017] PCI: xgene: Revert "PCI: xgene: Fix IB
 window setup"
Message-ID: <Yk2C4cZDtlVDDWqG@kroah.com>
References: <20220405070354.155796697@linuxfoundation.org>
 <20220405070400.156176848@linuxfoundation.org>
 <YkxjbVp3W2LeVIeL@xps13.dannf>
 <Ykx1o2PbNzGlp1ds@kroah.com>
 <CALdTtnv2w5d0N4ez7JTsxaWMa6v2c5j9-guVjkUq33=UDNFMGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALdTtnv2w5d0N4ez7JTsxaWMa6v2c5j9-guVjkUq33=UDNFMGA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 11:07:53AM -0600, dann frazier wrote:
> On Tue, Apr 5, 2022 at 11:00 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 05, 2022 at 09:42:37AM -0600, dann frazier wrote:
> > > On Tue, Apr 05, 2022 at 09:18:32AM +0200, Greg Kroah-Hartman wrote:
> > > > From: Marc Zyngier <maz@kernel.org>
> > > >
> > > > commit 825da4e9cec68713fbb02dc6f71fe1bf65fe8050 upstream.
> > > >
> > > > Commit c7a75d07827a ("PCI: xgene: Fix IB window setup") tried to
> > > > fix the damages that 6dce5aa59e0b ("PCI: xgene: Use inbound resources
> > > > for setup") caused, but actually didn't improve anything for some
> > > > plarforms (at least Mustang and m400 are still broken).
> > > >
> > > > Given that 6dce5aa59e0b has been reverted, revert this patch as well,
> > > > restoring the PCIe support on XGene to its pre-5.5, working state.
> > > >
> > > > Link: https://lore.kernel.org/r/YjN8pT5e6/8cRohQ@xps13.dannf
> > > > Link: https://lore.kernel.org/r/20220321104843.949645-3-maz@kernel.org
> > > > Fixes: c7a75d07827a ("PCI: xgene: Fix IB window setup")
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Rob Herring <robh@kernel.org>
> > > > Cc: Toan Le <toan@os.amperecomputing.com>
> > > > Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > Cc: Krzysztof Wilczyński <kw@linux.com>
> > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > Cc: Stéphane Graber <stgraber@ubuntu.com>
> > > > Cc: dann frazier <dann.frazier@canonical.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  drivers/pci/controller/pci-xgene.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > Hi Greg,
> > >
> > >   I don't think it makes sense to apply this to 5.10.y, 5.15.y &
> > > 5.16.y w/o also applying a backport of 1874b6d7ab1, because without
> > > that we will regress support for Stéphane's X-Gene2-based systems. The
> > > backport of 1874b6d7ab1 was rejected for these trees because it doesn't
> > > apply cleanly, but I've just submitted new versions that do.
> >
> > Where were those patches sent to?  I don't seem to see them on the
> > stable list, did I miss them?
> 
> These are the message IDs:
> <20220405142505.1268999-1-dann.frazier@canonical.com>
> <20220405153419.1330755-1-dann.frazier@canonical.com>
> 
> I've just bounced them directly to you as well. Thanks Greg!

Got them now, vger was being a bit slow due to the onslaught of patches
I had sent it.

greg k-h
