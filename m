Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B5E4DBA12
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 22:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbiCPVa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 17:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354479AbiCPVaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 17:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDF72654F;
        Wed, 16 Mar 2022 14:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBAF61567;
        Wed, 16 Mar 2022 21:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F422EC340F3;
        Wed, 16 Mar 2022 21:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647466147;
        bh=dI8ATJ23yJ3aOXedIMHJSO6iU/obXw2eqnoCJdxikjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wr5GCtT9e8hdgK53WPBSMowNZyqav5DZOjwCi+CegvpI8Ibc/s9bmJivRBw4pYcrJ
         9AFhbhCy9kQGddYprYtD7YUYtlBLeQZnwaaapkymeHZ7MT2Vya1P9sC82KsjYBLaEY
         61JkNVEMhl+Kr6DtHii92ToLM/hJPEy5CAkiXBSk=
Date:   Wed, 16 Mar 2022 14:29:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     Minchan Kim <minchan@kernel.org>, <surenb@google.com>,
        <vbabka@suse.cz>, <rientjes@google.com>, <sfr@canb.auug.org.au>,
        <edgararriaga@google.com>, <nadav.amit@gmail.com>,
        <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-Id: <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
In-Reply-To: <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
        <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
        <YjEaFBWterxc3Nzf@google.com>
        <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
        <YjFAzuLKWw5eadtf@google.com>
        <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
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

On Wed, 16 Mar 2022 19:49:38 +0530 Charan Teja Kalla <quic_charante@quicinc.com> wrote:

> > IMO, it's worth to note in man page.
> > 
> 
> Or the current patch for just ENOMEM is sufficient here and we just have
> to update the man page?

I think the "On success, process_madvise() returns the number of bytes
advised" behaviour sounds useful.  But madvise() doesn't do that.

RETURN VALUE
       On  success, madvise() returns zero.  On error, it returns -1 and errno
       is set to indicate the error.

So why is it desirable in the case of process_madvise()?



And why was process_madvise() designed this way?   Or was it
always simply an error in the manpage?
