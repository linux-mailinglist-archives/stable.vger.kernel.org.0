Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A6580760
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiGYW3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 18:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiGYW3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 18:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688E625C4C
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 15:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E37761375
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 22:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C71C341C8;
        Mon, 25 Jul 2022 22:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658788190;
        bh=Cf8o5Q0CsmckHZeoI8+tJWavBNKyWR+KrnNniuELBBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bReKxi/EtmInFu1ZTPdIdyzCAr1cSd5VdE6iephFXo4m4PcZI2vVocG8XAvWhkQpL
         JK96eBLamrWBEQtzjpeU6iJHXCiPoqCSvTJDSHE8C1LRnukiPZJu3SjE3uRLZytYbB
         lw1o9zi6qiq+/MxGI7LwZ+XSd/etj7jOzS3qTlRQ=
Date:   Mon, 25 Jul 2022 15:29:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Message-Id: <20220725152949.04dc23648a21eded666deb97@linux-foundation.org>
In-Reply-To: <e20f27ab-fb31-4301-0683-3ce51818b6b6@nvidia.com>
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
        <20220725114953.7e53ca4b296e0e753ca7bfda@linux-foundation.org>
        <e20f27ab-fb31-4301-0683-3ce51818b6b6@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jul 2022 12:07:27 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:

> >> to fault in the page.
> > Could we please include here a description of the end-user visible
> > effects of the bug?
> >
> >> Cc: stable@vger.kernel.org
> > Especially when proposing a -stable backport.
> 
> If I add the following, would that be sufficient?
> Should I post a v3?
> 
> For example, if a page is migrated to GPU private
> memory and a RDMA fault capable NIC tries to read the migrated page,
> without this patch it will get an error. With this patch, the page will
> be migrated back to system memory and the NIC will be able to read the
> data.

I added it, thanks.
