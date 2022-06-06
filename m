Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB5D53E6EC
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiFFOsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiFFOsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7212B7037D
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB135614A3
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C8BC385A9;
        Mon,  6 Jun 2022 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654526901;
        bh=kvyD9EeNYuEchz3xqJYAu6fOZAFAB2Tit2UV6Rm1qnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iHm2XRUW5D1dOuttqgOaGqbPz0G9LuMJ6biIsVnnvyQNlHsbP9g08cDWrwj6sgVdL
         HP4K+GHqs57ZuYbdbKD5XzMdml4cyieA3z9Wlbzf2FjvvjUMptoHJy3b9ZANTlSoiR
         4DG8sX/sZGnlHFbYaMJVwRyg0QU6S0qp+fMnPagM=
Date:   Mon, 6 Jun 2022 16:48:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     axboe@kernel.dk, hch@lst.de, yukuai3@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bfq: Split shared queues on move between
 cgroups" failed to apply to 4.19-stable tree
Message-ID: <Yp4TsgtHMR/nTjF5@kroah.com>
References: <16545166495292@kroah.com>
 <20220606130253.h2khtboi3nka7d3c@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606130253.h2khtboi3nka7d3c@quack3.lan>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 03:02:53PM +0200, Jan Kara wrote:
> Hello Greg!
> 
> I've seen this patch failed to apply to 4.19 and 4.14 stable trees but
> you've still merged (some) of the patches following this one from the same
> series. Honestly, I would not consider the result very trustworthy. The
> code involved is rather complex with subtle interactions across subsystems.
> So please remove also upstream commits:
> 
> ea591cd4eb27 ("bfq: Update cgroup information before merging bio")
> fc84e1f941b9 ("bfq: Drop pointless unlock-lock pair")
> 5f550ede5edf ("bfq: Remove pointless bfq_init_rq() calls")
> 09f871868080 ("bfq: Track whether bfq_group is still online")
> 4e54a2493e58 ("bfq: Get rid of __bio_blkcg() usage")
> 075a53b78b81 ("bfq: Make sure bfqg for which we are queueing requests is online")
> 
> from 4.14 and 4.19 stable queues. If someone will need these fixes there,
> he'll need to do proper backport with targetted testing etc... Thanks!

Only 2 ended up applying there, so I've dropped those two now, thanks!

greg k-h
