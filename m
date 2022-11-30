Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C986B63E2E1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 22:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiK3VoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 16:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3VoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 16:44:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDB31ED9;
        Wed, 30 Nov 2022 13:44:02 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id j4so28987804lfk.0;
        Wed, 30 Nov 2022 13:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoweguhVdE9rkHNrrE2YnwSJZtPETT6uz4SqPHeAVg8=;
        b=IB9l1JuueX9k7YvnYxgtAXfq1Y4yF0UbKLjtpuxrqZRmtpkYLkm5pndlEj0U31dfxz
         IhuGO+OvT35+dXY/iQOfGYso+sP5TLLqHlwAWesH6mzVHf/8dUvvK3WZxJ90zbZ1d0Sa
         Abg6Zz/UCTYW63icUCyTyjEuWoE3gwAO0hrxmKCTCZGKl+veLeX5MuYsmy2JVioaF4df
         kOlMrN1xJ/WnhO8YLRdD4Cj0tgfyEQDogfUfe+sszj5GBL0mZNw4LKCkLvdRi2JQRkAq
         WsPcoSlRD0eHDBIlvhrMGB6496NLHe/9um3DhTN/qa4VW4lFbbaNLLV9K33PvHKli6bq
         plNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SoweguhVdE9rkHNrrE2YnwSJZtPETT6uz4SqPHeAVg8=;
        b=7n+O75Rfl+xZ+TnVJmTULXfInuIS/q2+nAcpibxzQ5fSH8DZJ1wU2UvtTXfw+k0SAn
         AadmCLthq8CMEBWsMknORKjYlemWut/tVGiUtOYdt4iruQGN8bQV6t5WTugFp96VKG4Z
         u74IOsLIFPfEdD/4H8A+bMdVMzwFQZ8bcXTMJFJGGdL+Hbfae5/fx2Cre8sJB4iJOz3i
         0Wkm6YeV30QFmVY4l3cplvVrR7srWtCP+cgXjK+8qAGlokC4Il+zWZ2KJjZBsFX3NLcX
         YBEfjWlGUCtxj5FDyFltPnEW63UtKtUCAI9WqLzvEzXEL3UVxhRZsdDbY0LG6NxDjHl0
         9HGA==
X-Gm-Message-State: ANoB5plr85vj4wAcSXrpW4xtvmTSUJvYLts6pGRkk2hq2/ixtudYB/dq
        QOSBepHxzIP/GPF55eTY/KY=
X-Google-Smtp-Source: AA0mqf4B/6E4EQ88UDDyZW5P57Lh2mzUsmkSKC70YBsSuWrNqFNuyHK2zVlIRbnYwst1Z4zgXiklpA==
X-Received: by 2002:ac2:47ea:0:b0:4a2:2f4b:2f30 with SMTP id b10-20020ac247ea000000b004a22f4b2f30mr23696915lfp.357.1669844640254;
        Wed, 30 Nov 2022 13:44:00 -0800 (PST)
Received: from grain.localdomain ([5.18.253.97])
        by smtp.gmail.com with ESMTPSA id a19-20020ac25e73000000b0049110ba325asm385891lfr.158.2022.11.30.13.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 13:43:59 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
        id B77925A0020; Thu,  1 Dec 2022 00:43:58 +0300 (MSK)
Date:   Thu, 1 Dec 2022 00:43:58 +0300
From:   Cyrill Gorcunov <gorcunov@gmail.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, kernel@collabora.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: set the vma flags dirty before testing if it is
 mergeable
Message-ID: <Y4fOnsav2CK5lcA7@grain>
References: <20221122115007.2787017-1-usama.anjum@collabora.com>
 <Y4W0axw0ZgORtfkt@grain>
 <ecef5201-04d5-3618-a667-2e7c4770b908@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecef5201-04d5-3618-a667-2e7c4770b908@collabora.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 06:49:53PM +0500, Muhammad Usama Anjum wrote:
> > ioctl might be an option indeed
> Thank you for supporting this. I'll track down the issue caused by
> remapping and mprotect mentioned here:
> https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/
> and we can proceed with this.
> 
> > 
> >>
> >> [1] https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
> >> [2] https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/

Hi Muhammad! Hopefully I'll find some time soon to read all these conversation,
so for now my replies might be simply out of context. Initially the vma softdirty
was needed to catch a case where memory remapped inplace and what is worse it might
have _same_ ptes dirty after clear_refs call. IOW, the process allocated vma and
write some data into. Then we (page tracker process) come in, read pagemap and clear
softdirty bits, and page traker process terminates. While we're not watching the program
unmaps vma, maps new one with same size and what is worse it writes data to the same pages
as we saw at last scan time. So without VM_SOFTDIRTY we won't be able to find that this
VMA is actually carrying new pages which were not yet dumped.

And similar scenario can be for merging: say former vma has been 4 pages, we scan it
and clear dirty pages at low and hight address. Then process splits this VMA to two with
gap inbetween and then map new area which merge them all into one vma, and process can
write again pages to same address so we have to mark this new VMA as softdirty. If only
I rememeber correctly about the initial idea :)
