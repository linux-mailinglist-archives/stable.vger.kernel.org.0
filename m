Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3474E4E44
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiCWIba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbiCWIbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:31:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4254A765B8;
        Wed, 23 Mar 2022 01:28:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DE5C3210E9;
        Wed, 23 Mar 2022 08:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648024117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CW3R+Yiroys6he2hHa/SHBZUim+4itSeZjujNKPJOmQ=;
        b=tB448LMyefBx5twawDjt8knurabMyegikQW37yhYusJrNOEXKgv24DS1/jaejnVIzzL2kC
        TRwSrtJYxTnLlLapwzTrdxKmv0M0c2o7gdzOXvw4NQNzFLUKjENKzApLxv6UR+TN3zYYdM
        lWYYH57ssNh0s5XojNY4nxboJ1uCwzw=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8E09FA3BA1;
        Wed, 23 Mar 2022 08:28:37 +0000 (UTC)
Date:   Wed, 23 Mar 2022 09:28:37 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        surenb@google.com, stable@vger.kernel.org, sfr@canb.auug.org.au,
        rientjes@google.com, nadav.amit@gmail.com,
        quic_charante@quicinc.com, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjraNQkmtkLiv1yz@dhcp22.suse.cz>
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org>
 <Yjpo2jnp5pkJr+XI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjpo2jnp5pkJr+XI@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 22-03-22 17:24:58, Minchan Kim wrote:
> On Tue, Mar 22, 2022 at 02:46:48PM -0700, Andrew Morton wrote:
> > From: Charan Teja Kalla <quic_charante@quicinc.com>
> > Subject: mm: madvise: skip unmapped vma holes passed to process_madvise
> > 
> > The process_madvise() system call is expected to skip holes in vma passed
> > through 'struct iovec' vector list.  But do_madvise, which
> > process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> > holes, despite the VMA is processed.
> > 
> > Thus process_madvise() should treat ENOMEM as expected and consider the
> > VMA passed to as processed and continue processing other vma's in the
> > vector list.  Returning -ENOMEM to user, despite the VMA is processed,
> > will be unable to figure out where to start the next madvise.
> > 
> > Link: https://lkml.kernel.org/r/4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com
> 
> I thought it was still under discussion and Charan will post next
> version along with previous patch
> "mm: madvise: return correct bytes advised with process_madvise"
> 
> https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/

Yes, I am not even sure the new semantic is sensible[1]. We should discuss
that and see all the consequences. Changing the semantic of an existing
syscall is always tricky going back and forth is even worse.
-- 
Michal Hocko
SUSE Labs
