Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D7694E97
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 19:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBMSBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 13:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjBMSBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 13:01:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1411E166C8;
        Mon, 13 Feb 2023 10:01:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B91881FF43;
        Mon, 13 Feb 2023 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676311288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zjmWiLidv9s5VZwExclp2S1zJJLTj2i1cwRC3vTy34U=;
        b=gBIrqG/bt3Nka1Yav+85md6pjlNt2iAp2IiC1h/jKet9euwQOLtfKlokNzNmJHWkH6rN/I
        cbrMb2TtBfZdvd+Cn7I/4vX6J2Sc1ULVEmlvfeTUZkshkVS4I4eYCOC4UYwUsIb6uRTxaQ
        6/JmoJCN/cMS3HjGgnSRPjSvwrjP15I=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9765C1391B;
        Mon, 13 Feb 2023 18:01:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZvI6Ivh66mNgcAAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 13 Feb 2023 18:01:28 +0000
Date:   Mon, 13 Feb 2023 19:01:28 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y+p6+AKN7jY2jzJN@dhcp22.suse.cz>
References: <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
 <Y9g/70m15SwxkLfc@monkey>
 <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
 <Y9rUHw2kuSwg2ntI@monkey>
 <Y90O5+UVYaaN1U3y@dhcp22.suse.cz>
 <Y91rhP+gT6me67M8@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y91rhP+gT6me67M8@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 03-02-23 12:16:04, Mike Kravetz wrote:
[...]
> Unless someone thinks we should move forward, I will not push the code
> for this approach now.  It will also be interesting to see if this is
> impacted at all by the outcome of discussions to perhaps redesign
> mapcount.

Yes, I do agree. We might want to extend page_mapcount documentation a
bit though. The comment is explicit about the order-0 pages but a note
about hugetlb and pmd sharing wouldn't hurt. WDYT?
-- 
Michal Hocko
SUSE Labs
