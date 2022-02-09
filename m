Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DBF4AFCFB
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiBITMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:12:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiBITMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:12:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED768C014F39;
        Wed,  9 Feb 2022 11:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9gl0k3PijnwzBappKxAOI37Vix6kLRRS+YqO+Vq3rvI=; b=qFAtiO6z0mbXRm+tzfImRHlYJg
        OTEmLv3RZ5U4u0wpUQrFULpv3aIekvg8pPgOqufzZ44EoTEJRYqPSLm3JGr+Hkhb9v5cTOHPaGHt+
        L1ed4WJpmRlqB70lLATDhIrdvbCy9V7Zxz6O7Gd7OaK2wVVeC2qgUjnErZk0WUeFZepkiwT6rvQdE
        8NZyyRdqBDI9s8fqf8jM+8S4NTygZ0SXY80sjtpWI0jW4xrr9WN/nD5/uUjoGEti0DiY0nRVgM/R5
        qpAN95PzKrlZ2wQOoHCBtwZMyAIQpzFoKC8ls0PsakKTGsXuShImt2K9EfxTNU36x3onbKSwsTwsG
        cmiykScg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHsNu-008U5F-Dw; Wed, 09 Feb 2022 19:12:10 +0000
Date:   Wed, 9 Feb 2022 19:12:10 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgQSCoD5j9KbpHsA@casper.infradead.org>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220209150904.GA22025@lst.de>
 <YgPk9HhIeFM43b/a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgPk9HhIeFM43b/a@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 03:59:48PM +0000, Lee Jones wrote:
> On Wed, 09 Feb 2022, Christoph Hellwig wrote:
> 
> > On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> > > 
> > > Reverting since this commit opens a potential avenue for abuse.
> > > 
> > > The C-reproducer and more information can be found at the link below.
> > > 
> > > With this patch applied, I can no longer get the repro to trigger.
> > 
> > Well, maybe you should actually debug and try to understand what is
> > going on before blindly reverting random commits.
> 
> That is not a reasonable suggestion.
> 
> Requesting that someone becomes an area expert on a huge and complex
> subject such as file systems (various) in order to fix your broken
> code is not rational.

Sending a patch to revert a change you don't understand is also
not rational.  If you've bisected it to a single change -- great!
If reverting the patch still fixes the bug -- also great!  But
don't send a patch when you clearly don't understand what the
patch did.

> If you'd like to use the PoC provided as a basis to test your own
> solution, then go right ahead.  However, as it stands this API should
> be considered to contain security risk and should be patched as
> quickly as can be mustered.  Reversion of the offending commit seems
> to be the fastest method to achieve that currently.

This is incoherent.  There is no security risk.
