Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96F54D4151
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 07:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiCJGtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 01:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiCJGtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 01:49:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C11C1C88;
        Wed,  9 Mar 2022 22:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9/MWPObrhuNAehUFkhtELAPhI8PUadmLIfcXXSdHpR8=; b=vfKBc687JPz3JbHB+CL8prpzeq
        Ajp7A6oLRwHE3bBhZvHdO8SZHDJOzT63zsieCLdnUMiVaam39hcyjz7wRSuWAQOTw3X+VZzJcxQy3
        GrzOgKJA+6XkZHrpG2On0yxrw8yQUzQo4rnt1DeqHUSfuQ/rKpHOyHtphhWPc0IWQcy6FNLZISVDu
        SpZxjCiZXj2f32cU9ZEjDCTPIgUyt1jFJB6eccuiFmThlfZX+p+PRKd7Miyfoh8LNGjkFOCQOHYoS
        vSeDxS8ZpshUP4XLfky1T9mM7+EwFlaehO38U5HmNED0EnRp6FZa2rS28Np9l+8EvfcgkwULjVfvk
        4cfmL0Lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSCaq-00BeZX-B4; Thu, 10 Mar 2022 06:48:12 +0000
Date:   Wed, 9 Mar 2022 22:48:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        axboe@kernel.dk, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Message-ID: <YimfLJoWLKnnhLfR@infradead.org>
References: <20220309064209.4169303-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309064209.4169303-1-song@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 10:42:09PM -0800, Song Liu wrote:
> RAID arrays check/repair operations benefit a lot from merging requests.
> If we only check the previous entry for merge attempt, many merge will be
> missed. As a result, significant regression is observed for RAID check
> and repair.
> 
> Fix this by checking more than just the previous entry when
> plug->multiple_queues == true.

But this also means really significant CPU overhead for all other
workloads.

> 
> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> 103 MB/s.

What driver uses multiple queues for HDDs?

Can you explain the workload submitted by a md a bit better?  I wonder
if we can easily do the right thing straight in the md driver.
