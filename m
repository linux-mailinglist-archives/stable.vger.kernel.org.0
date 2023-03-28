Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF16CCAFA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjC1T4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 15:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjC1T4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 15:56:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006B61FC3
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA30EB81E4A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 19:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A505C433D2;
        Tue, 28 Mar 2023 19:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680033359;
        bh=CTUYWxXd+yObk4y3y8I0yB5B0x34p6sstzdIplNE/MY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ndgJDNC99FdKm17ufZ4sHC9DW142inlGKABvkR2/faxej3EvezmIbbnMz02mMTG/i
         iNj9OBiK9MoLyDMHEEOAPe0jJ09f47P8aHm6FiR+R8e7LBGG5GhkcHXWEvV/lUQlKB
         h07VpFTLIbI6IUEVVaMEDGdKaixmxr2SWHvBQYt4=
Date:   Tue, 28 Mar 2023 12:55:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        Ralph Campbell <rcampbell@nvidia.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Take a page reference when removing device
 exclusive entries
Message-Id: <20230328125558.90cf40060e238b24add51d23@linux-foundation.org>
In-Reply-To: <538f85fc-3cc7-de5c-131e-ba776d5f35b5@nvidia.com>
References: <20230328021434.292971-1-apopple@nvidia.com>
        <538f85fc-3cc7-de5c-131e-ba776d5f35b5@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Mar 2023 23:25:49 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> On the patch process, I see that this applies to linux-stable's 6.1.y
> branch. I'd suggest two things:
> 
> 1) Normally, what I've seen done is to post against either the current
> top of tree linux.git, or else against one of the mm-stable branches.
> And then after it's accepted, create a version for -stable. 

Yup.  I had to jiggle the patch a bit because
mmu_notifier_range_init_owner()'s arguments have changed.  Once this
hits mainline, the -stable maintainers will probably ask for a version
which suits the relevant kernel version(s).

