Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0314DBB9F
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344556AbiCQAWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 20:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiCQAWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 20:22:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BE61C926
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28046B81DBA
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 00:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F488C340E9;
        Thu, 17 Mar 2022 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647476459;
        bh=RKfQc+84KzmX/BJmxFRxmVAIX2O5Y+i2nELUSWn05Xc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CB80h/PJoP52lXdT+ioOC3RbjLbZuH5/X3gCIWYSAtEokc32G6tPVZh7HxmOzF5/p
         90Q5VUZqNY+U294MNnlLWAiXBHlamSMCMbzTURKovQB7rzEpRglfeTL1dPa5QLe0G8
         +2vifMOrM+svvufx4RXwtciHXkaIYX+ySv4M3rXc=
Date:   Wed, 16 Mar 2022 17:20:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-Id: <20220316172058.c559efb14b1324ea52b708f8@linux-foundation.org>
In-Reply-To: <YjJ8wO4MVwSUMhd/@xz-m1.local>
References: <20220217211602.2769-1-namit@vmware.com>
        <Yg79WMuYLS1sxASL@xz-m1.local>
        <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
        <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
        <3E9C755C-7335-4636-8280-D5CB9735A76A@gmail.com>
        <20220316150553.c7b6f9e0eac620c9ee5963a5@linux-foundation.org>
        <YjJ8wO4MVwSUMhd/@xz-m1.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 08:11:44 +0800 Peter Xu <peterx@redhat.com> wrote:

> Hi, Andrew,
> 
> On Wed, Mar 16, 2022 at 03:05:53PM -0700, Andrew Morton wrote:
> > 
> > As I understand it, this patch (below) is still good to merge upstream,
> > although Peter hasn't acked it (please).
> 
> Thanks for asking.  I didn't ack because I saw that it's queued a long time
> ago into -mm, and also it's in -next for a long time too (my new uffd-wp
> patchset is rebased to this one already).
> 
> I normally assume that means you read and ack that patch already, so if I
> didn't see anything obviously wrong I'll just keep silent. Please let me
> know if that's not the expected behavior..

Acks and reviews are always welcome.  If they come in late, git tree
maintainer might not want to update and rebase, but it's still there in
the archives for people who click on the Link:.

> So here it is..
> 
> Acked-by: Peter Xu <peterx@redhat.com>

Thanks.

> > 
> > And a whole bunch of followup patches are being thought about, but have
> > yet to eventuate.
> 
> Is there a pointer/subject?

The messages in this thread.  Several followup patches were discussed.

> > 
> > Do we feel that this patch warrants the cc:stable?  I'm suspecting
> > "no", as it isn't clear that the use-case is really legitimate at this
> > time?
> 
> Right. Uffd-wp+mprotect usage is IMHO not a major use case for uffd-wp per
> my knowledge. At least I didn't even expect both work together, not until
> Nadav started working on some of the problems..
> 
> Said that, for this specific case it should be literally only changing the
> behavior of anonymous UFFD-WP && !WRITE case but nothing else (please
> correct me otherwise..), then IMHO it's pretty safe to copy stable too
> especially for the cleanly applicable branches.

OK, thanks.
