Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6753667DE90
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjA0HeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjA0HeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E346384C
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 23:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D75C8B81F83
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 07:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B36EC433EF;
        Fri, 27 Jan 2023 07:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804847;
        bh=mO9T1UZxthQyfE75u2Z1Q+F0nPElDuXTfQoedLov9Y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yuiFfhH7yZbKM3pv3mberGM8ehHGqghOQ2sSjU/ek1NWzZGTZSb3mG0Src2br1CDU
         /NnO2LYYToALycCDKzQSpEVpuJRKVTV+sS//yBj3Wf3P99BcHCsb5lJwZL0E/2UWAj
         kDoMIxdUWAj5Wnfgks7jjgofREruJ90LnqvffGPU=
Date:   Fri, 27 Jan 2023 08:34:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.1 1/1] io_uring/msg_ring: fix remote queue to
 disabled ring
Message-ID: <Y9N+bBWLWvXbXF9/@kroah.com>
References: <7912d2195155239ddcc77fa9ec22cf0f503ddf68.1674486170.git.asml.silence@gmail.com>
 <Y86mheG5a2noWIW3@kroah.com>
 <8f5f017b-ba8c-b47c-3812-f61c4ed4151a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f5f017b-ba8c-b47c-3812-f61c4ed4151a@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 03:29:25PM +0000, Pavel Begunkov wrote:
> On 1/23/23 15:23, Greg KH wrote:
> > On Mon, Jan 23, 2023 at 03:03:24PM +0000, Pavel Begunkov wrote:
> > > [ upstream commit 8579538c89e33ce78be2feb41e07489c8cbf8f31 ]
> > > 
> > > IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
> > > it's not always safe to use ->submitter_task. Disallow posting msg_ring
> > > messaged to disabled rings. Also add task NULL check for loosy sync
> > > around testing for IORING_SETUP_R_DISABLED.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
> > 
> > This commit is only in 6.2-rc1, so is it really relevant for this commit
> > to go to 6.1?
> In short, yes.
> 
> 
> The upstream commit fixes a bug in 6.2, that's the Fixes tag, but
> it also adjusts behaviour of the feature, which came in earlier
> kernels. My bad I didn't split the patch in two.
> 
> I also thought Jens added a second Fixes tag but it's not there.
> 
> Fixes: 4f57f06ce2186 ("io_uring: add support for IORING_OP_MSG_RING command")

Great, now queued up, thanks!

greg k-h
