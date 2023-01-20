Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7887B674867
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 01:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjATA7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 19:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjATA7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 19:59:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5D6A1028;
        Thu, 19 Jan 2023 16:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O0jjZ5OmxPI6bfuCs0idbFiSez3jFaKnyKag6lKe1K0=; b=Il0ksPuIMLNEnUqapwwrniFIOs
        NsghiibFEhrl4DK0aWija5Yo3kWmNPhTX57hHybQHeS75WdYOlEA52cAEO53vbIDtcbyctXB0Wj6U
        8Rswx63LxU+IcmZB8KMl8h7OsqgeXrhAJRTdrlyM/lrkQ9exCIMoi8CoN9QuSt5hc5NbUjDLpv/b1
        5/e4lroUY67x+YNyWSI7X9m7eYxiWKeqFMRYZxvFjxJpX9jXCXHAmIWlLJpcV8YNc+jZd8189xl/2
        RnQuJppOkC6z4LwiTPWY+0ntxJ2yc1WNWyHngM58IRBgCEqBbXlNWre1yrpsLXbP0HU3de9zycgJd
        h2mCyieg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIfk5-007qLY-43; Fri, 20 Jan 2023 00:58:53 +0000
Date:   Thu, 19 Jan 2023 16:58:53 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
> On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> > Yes, the -EINVAL error is strange. It is returned also in
> > kernel/module/main.c on few locations. But neither of them
> > looks like a good candidate.
> 
> OK I updated to next-20230119 and I don't see the issue now.
> Odd. It could have been an issue with next-20221207 which I was
> on before.
> 
> I'll run some more test and if nothing fails I'll send the fix
> to Linux for rc5.

Jeesh it just occured to me the difference, which I'll have to
test next, for next-20221207 I had enabled module compression
on kdevops with zstd.

You can see the issues on kdevops git log with that... and I finally
disabled it and the kmod test issue is gone. So it could be that
but I just am ending my day so will check tomorrow if that was it.
But if someone else beats me then great.

With kdevops it should be a matter of just enabling zstd as I
just bumped support for next-20230119 and that has module decompression
disabled.

  Luis
