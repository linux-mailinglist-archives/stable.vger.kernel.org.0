Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2B50DDBF
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiDYKWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiDYKWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:22:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7384338C;
        Mon, 25 Apr 2022 03:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9886B8124E;
        Mon, 25 Apr 2022 10:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9CFC385A4;
        Mon, 25 Apr 2022 10:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650881935;
        bh=zBGvsRPqhpWLS8YHP3rMEZJgIcc0A1DxjtWg5qIlo9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wH0y173E9KeZTUupJGYpeZIR3RO52eGg+sN4/HyEOZk6lXxBVaQ853IJjwuTvT0ub
         xzAOuGDcacoDLCU7ItteurGT4GBX1PnaPpQbY0DlDu1xhL35FQfWgkk8AZrS1AYv00
         bIAnzEn/I04oRU0zr8QGLlMUQk48SaqGYELTYP1o=
Date:   Mon, 25 Apr 2022 12:18:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Zheyu Ma <zheyuma97@gmail.com>, s.shtylyov@omp.ru,
        linux-ide@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ata: pata_marvell: Check the 'bmdma_addr' beforing
 reading
Message-ID: <YmZ1i0QYqlMdgck4@kroah.com>
References: <20220421013920.3503034-1-zheyuma97@gmail.com>
 <e29fd64e-62ea-746e-f0fb-02ce86b4e61e@opensource.wdc.com>
 <39f1ac3d-d8d8-1585-360f-ab534dac2a00@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39f1ac3d-d8d8-1585-360f-ab534dac2a00@opensource.wdc.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 09:38:17AM +0900, Damien Le Moal wrote:
> On 4/22/22 08:47, Damien Le Moal wrote:
> > On 4/21/22 10:39, Zheyu Ma wrote:
> >> Before detecting the cable type on the dma bar, the driver should check
> >> whether the 'bmdma_addr' is zero, which means the adapter does not
> >> support DMA, otherwise we will get the following error:
> >>
> >> [    5.146634] Bad IO access at port 0x1 (return inb(port))
> >> [    5.147206] WARNING: CPU: 2 PID: 303 at lib/iomap.c:44 ioread8+0x4a/0x60
> >> [    5.150856] RIP: 0010:ioread8+0x4a/0x60
> >> [    5.160238] Call Trace:
> >> [    5.160470]  <TASK>
> >> [    5.160674]  marvell_cable_detect+0x6e/0xc0 [pata_marvell]
> >> [    5.161728]  ata_eh_recover+0x3520/0x6cc0
> >> [    5.168075]  ata_do_eh+0x49/0x3c0
> >>
> >> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> >> ---Changes in v2:
> >>      - Delete the useless 'else'
> > 
> > Note for future contributions: The change log should be placed *after* 
> > the "---" that comes before the "diff" line below. Otherwise, the change 
> > log pollutes the commit message.
> > 
> > I fixed that and applied to for-5.18-fixes. Thanks.
> 
> I completely overlooked that this needs a CC stable...
> 
> Greg,
> 
> Could you please pickup this commit for stable ?
> In Linus tree/rc4, it is:
> 
> aafa9f958342 ("ata: pata_marvell: Check the 'bmdma_addr' beforing reading")

Now queued up, thanks.

greg k-h
