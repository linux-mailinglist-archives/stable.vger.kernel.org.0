Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774C84EB3FB
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 21:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiC2TPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 15:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238969AbiC2TPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 15:15:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338B1EEDC;
        Tue, 29 Mar 2022 12:13:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8631A21A2B;
        Tue, 29 Mar 2022 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648581209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zzux7evVbtH+m7VA+DSlcqgknENtBIaS5EV1mQ6pGsA=;
        b=uQFfaFfHCFQbQq37zmyxuyq31d0Ap5jMuUdXvezuuG9OE/Zyhxrzb6XJQIbQin9a/bABys
        TXfwrvWNtB47YzOJWjEVccoIvq19a4EmQlwln5TRGBIJlBh61eFERcGZyX36qXclNmeKa3
        cDI0Mp6fg/PucyIh5fXcc5tyVx9BKA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648581209;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zzux7evVbtH+m7VA+DSlcqgknENtBIaS5EV1mQ6pGsA=;
        b=rUivqUqMHgCFVcFiGO8lOlw4ogru8KE7msvD3CVxl1qQ5+6B29DwCaWhA7n16Hyu7AmFdJ
        2MHlhHiJKWyaAjBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D17FF13A7E;
        Tue, 29 Mar 2022 19:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NOfnL1haQ2LHVAAAMHmgww
        (envelope-from <osalvador@suse.de>); Tue, 29 Mar 2022 19:13:28 +0000
Date:   Tue, 29 Mar 2022 21:13:27 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Rik van Riel <riel@surriel.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fb.com, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
Message-ID: <YkNaVxe5Vso9DGl+@localhost.localdomain>
References: <20220325161428.5068d97e@imladris.surriel.com>
 <YkF5Jd6fauTRvVVg@localhost.localdomain>
 <47936edb3b0f9c9f04f0d0d2e7f38383a22b6a3d.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47936edb3b0f9c9f04f0d0d2e7f38383a22b6a3d.camel@surriel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 11:49:53AM -0400, Rik van Riel wrote:

> It results in us returning to userspace as if the page
> fault had been handled, resulting in a second fault on
> the same address.
> 
> However, now the page is no longer in the page cache,
> and we can read it in from disk, to a page that is not
> hardware poisoned, and we can then use that second page
> without issues.

Ok, I see, thanks a lot for the explanation Rik.


-- 
Oscar Salvador
SUSE Labs
