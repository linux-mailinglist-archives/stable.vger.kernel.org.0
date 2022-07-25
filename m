Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77F5580436
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiGYSt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiGYSt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:49:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CB8D4B
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ADBDB810AA
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 18:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B2C341C6;
        Mon, 25 Jul 2022 18:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658774994;
        bh=yy7PhlLUKJkcq1UG9oO0Tr3lq0L1Ce6BUI/PYbQQgRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpLK5ir3x2pygWPzrF3kLbN2nReaDv3uYYmQ6nsUBxFdeFzVQtgrYgiwoW6BsNdrf
         NeRFRqWIi66kG44kByH3ilf/PkuTAIBkFcQxsCIvzyPJYepGv/wdagaSkGgZ1iwpKm
         5stAXvjSfBT/22EGMUvr/Ff/oer0qL3+Z+YEelng=
Date:   Mon, 25 Jul 2022 11:49:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     <linux-mm@kvack.org>, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Message-Id: <20220725114953.7e53ca4b296e0e753ca7bfda@linux-foundation.org>
In-Reply-To: <20220722225632.4101276-1-rcampbell@nvidia.com>
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
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

On Fri, 22 Jul 2022 15:56:32 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:

> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.

Could we please include here a description of the end-user visible
effects of the bug?

> Cc: stable@vger.kernel.org

Especially when proposing a -stable backport.
