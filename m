Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA885B9380
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 06:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIOEYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 00:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIOEYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 00:24:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E74920F4C;
        Wed, 14 Sep 2022 21:24:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1F43D34234;
        Thu, 15 Sep 2022 04:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663215884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rp2hb7jsVkIpo1uaIkf2AqZV7igkV0nPtVBey4vQ3iA=;
        b=heSGgyWHzuf3rMoxxqD2XF0OwMvMrOesmZZaVvvPtZ3cxmqQQMI3AHyJ65Sk5SdK9iPLka
        zZ2V85Ei9YcD44YLDVhzdz0JN7ixC0FS4ov5fdk8PInEo4rOqZG0SjZZKhuio317HI/Bzh
        ts9TyxzYSVnBjMyvLuvIx7bdIl6QYRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663215884;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rp2hb7jsVkIpo1uaIkf2AqZV7igkV0nPtVBey4vQ3iA=;
        b=V7JIYzWAv7lP7/23sPcdYKdxyOxAIlqEZGrIoKT4zXukt6sMBBsM/mQ1b6xzjCAb7QNopS
        HfxwHUoFtxyIeHAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A248D139C8;
        Thu, 15 Sep 2022 04:24:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HVX4JAupImMkJgAAMHmgww
        (envelope-from <osalvador@suse.de>); Thu, 15 Sep 2022 04:24:43 +0000
Date:   Thu, 15 Sep 2022 06:24:41 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Doug Berger <opendmb@gmail.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Message-ID: <YyKpCSEnv+KCL5Jb@localhost.localdomain>
References: <20220914190917.3517663-1-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914190917.3517663-1-opendmb@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 12:09:17PM -0700, Doug Berger wrote:
> With gigantic pages it may not be true that struct page structures
> are contiguous across the entire gigantic page. The nth_page macro
> is used here in place of direct pointer arithmetic to correct for
> this.
> 
> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
