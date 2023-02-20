Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0108A69D581
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 22:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjBTVGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 16:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBTVGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 16:06:49 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8861BAD7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:06:48 -0800 (PST)
Received: by soltyk.jannau.net (Postfix, from userid 1000)
        id BC9B426F7BD; Mon, 20 Feb 2023 22:06:46 +0100 (CET)
Date:   Mon, 20 Feb 2023 22:06:46 +0100
From:   Janne Grunau <j@jannau.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     hch@lst.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nvme-apple: reset controller during
 shutdown" failed to apply to 6.1-stable tree
Message-ID: <20230220210646.GB24656@jannau.net>
References: <1676893225104207@kroah.com>
 <20230220164559.GA24656@jannau.net>
 <Y/O3UtHiz4//9o6E@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/O3UtHiz4//9o6E@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-02-20 19:09:22 +0100, Greg KH wrote:
> On Mon, Feb 20, 2023 at 05:45:59PM +0100, Janne Grunau wrote:
> > Hej,
> > 
> > On 2023-02-20 12:40:25 +0100, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 6.1-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Why was this patch even considered for the 6.1-stable tree? Its "Fixes:" 
> > tag references a commit which only appeared in v6.2-rc1.
> > 
> > There is no need to backport this to any stable tree.
> > 
> > The message suggest that ignoring this would have been fine but it seems 
> > worthwhile to report a potential bug or ommission in the stable backport 
> > tooling.
> > 
> > > Possible dependencies:
> > > 
> > > c06ba7b892a5 ("nvme-apple: reset controller during shutdown")
> > 
> > certainly doesn't depend on itself
> > 
> > ...
> > 
> > > c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")
> 
> This is the commit that is now in the 6.1-stable queue, which is why I
> sent the "FAILED" email for the commit that said this was a fix.

I didn't think of that, I wouldn't have considered c76b8308e4c9 as a 
candidate for stable. At best it would have avoided some unnecessary 
work. Did it get queued for stanble due to the "fix" in the commit 
message?

> > commit from "Fixes:"
> > 
> > ...
> > 
> > If this is intended since "Fixes:" tags are in general not relieable 
> > enough to decide to which trees regression fixes have to be applied to 
> > that's acceptable
> 
> Should I just drop c76b8308e4c9 ("nvme-apple: fix controller shutdown in
> apple_nvme_disable") instead?

yes, I think dropping c76b8308e4c9 ("nvme-apple: fix controller shutdown 
apple_nvme_disable") from stable is the best solution.

c06ba7b892a5 ("nvme-apple: reset controller during shutdown") was 
functionally a revert. It wasn't a clean revert since 285b6e9b5717 
("nvme: merge nvme_shutdown_ctrl into nvme_disable_ctrl") modified the 
same lines substantially.

thanks

Janne
