Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BF0548112
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiFMIBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiFMIAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC21E55B2;
        Mon, 13 Jun 2022 01:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B87DB80D88;
        Mon, 13 Jun 2022 08:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89EEC3411C;
        Mon, 13 Jun 2022 08:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655107233;
        bh=elvnnOZZ+5pJ88iCZ8TUUMHnnNbH59nzjeBrpwy9VpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chyH8RQHqqSfLNpzUnKbg0vjCkNFRzV2w6hJD0AeyilyaPhk3YsTcI0a/lnoSzER0
         Iw9lkOOaBd9jP/4INyFRODPVoF3WSwFGFiB144mLo+h8puFnkfLES3E8ZIpQ0Q9FI/
         QCaAMAtSUxVUAvcYBEr5Ta4Zi1Kdncgrv/re/Xjw=
Date:   Mon, 13 Jun 2022 10:00:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     daniel@iogearbox.net, linux-kernel@vger.kernel.org, pavel@denx.de,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()
Message-ID: <YqbunqapIFiIVqOb@kroah.com>
References: <YqC+WquFukW84W12@kroah.com>
 <20220608160728.272118-1-ytcoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608160728.272118-1-ytcoode@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 12:07:28AM +0800, Yuntao Wang wrote:
> On Wed, 8 Jun 2022 17:20:58 +0200, Greg KH wrote:
> > On Wed, Jun 08, 2022 at 10:25:38PM +0800, Yuntao Wang wrote:
> > > The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
> > > the allocated memory for 'smap' is never used, get rid of it.
> > > 
> > > Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
> > > Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> > > Link: https://lore.kernel.org/bpf/20220407130423.798386-1-ytcoode@gmail.com
> > > ---
> > > This is the modified version for 5.10, the original patch is:
> > > 
> > > [ Upstream commit b45043192b3e481304062938a6561da2ceea46a6 ]
> > > 
> > > It would be better if the new patch can be reviewed by someone else.
> > 
> > What is wrong with the version that we have queued up in the 5.10-stable
> > review queue right now?
> 
> Since the 5.10 branch doesn't have commit 370868107bf6, the upstream version
> is not correct for it, I modified the original patch and wanted to backport
> it to the 5.10 branch.

This does not apply to the 5.10 branch now, can you provide a working
version?

thanks,

greg k-h
