Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7D8595736
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiHPJzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiHPJzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA8D760D3;
        Tue, 16 Aug 2022 02:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 210F0B81600;
        Tue, 16 Aug 2022 09:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDA8C433C1;
        Tue, 16 Aug 2022 09:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660641352;
        bh=Wdxre7FFhDBD5lnB7uNrwJnK1gXcfMGy4iZmPUWmkpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POa0hku6HzuNL8VJQGSmnMS1A32/ZlsJR0Kw9BwSJZMzHwh51QVTZyYVG0PxvJ3tC
         pfpTxRVAItzgrMTdAa4WlbPkcnOrt/CNeS9NGXKPsQCN1Ah66RU/nSY0wejAae0IUc
         Qtpa3op3cFOMJDYgv409xFqnEB/4hayJI1T9Xyjk=
Date:   Tue, 16 Aug 2022 11:15:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 154/779] netfilter: nf_tables: add rescheduling
 points during loop detection walks
Message-ID: <YvtgRU9pjwNdX8ih@kroah.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180343.899696572@linuxfoundation.org>
 <20220815185822.GA26513@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815185822.GA26513@breakpoint.cc>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 08:58:22PM +0200, Florian Westphal wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > [ Upstream commit 81ea010667417ef3f218dfd99b69769fe66c2b67 ]
> > 
> > Add explicit rescheduling points during ruleset walk.
> 
> NAK.  There is a partial revert pending.
> 
> > @@ -9225,9 +9227,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
> >  				break;
> >  			}
> >  		}
> > +
> > +		cond_resched();
> >  	}
> >  
> >  	list_for_each_entry(set, &ctx->table->sets, list) {
> > +		cond_resched();
> 
> Can't be used here, this can be called from atomic context.

Thanks, now dropped from all branches.

greg k-h
