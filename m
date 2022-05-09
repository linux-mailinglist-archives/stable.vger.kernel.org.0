Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC751F7F6
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiEIJWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiEIJQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:16:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C632E187077;
        Mon,  9 May 2022 02:12:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 58D361F74D;
        Mon,  9 May 2022 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652087559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ORL0sjIv21RXFZv9oa4wRY3ouTS64KfJhQLnQPlf25s=;
        b=d2Jok/Pt6bT3/GWHZNc3EvRZ04DsgCmXwnWmFms5mKw6G+Wke5lrZV5/LiW4+sduYGQy2v
        IOXYLU1jAI88ohZzPx0qroQPJHctEO5H0QGXT4rTA/Crw/DcZKbdC3xNMPKxOC0lLzBTVm
        dFL1msfkcyudRMRgqS8cUqc882UNxIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652087559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ORL0sjIv21RXFZv9oa4wRY3ouTS64KfJhQLnQPlf25s=;
        b=JWMFvMFhbaLyZ5423OYrEuTqyQ6AkpcxYDKUgjGMzcAuXWrwXkVldCeHRk1Pvt7uO3IRLF
        VKAt4hLalWWp1BDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E55E413AA5;
        Mon,  9 May 2022 09:12:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dJkENQbbeGKNWQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 09 May 2022 09:12:38 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 903922d5;
        Mon, 9 May 2022 09:13:11 +0000 (UTC)
Date:   Mon, 9 May 2022 10:13:11 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ceph: check folio PG_private bit instead of
 folio->private
Message-ID: <YnjbJ/2DbPkTAKnI@suse.de>
References: <20220508061543.318394-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220508061543.318394-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 08, 2022 at 02:15:43PM +0800, Xiubo Li wrote:
> The pages in the file mapping maybe reclaimed and reused by other
> subsystems and the page->private maybe used as flags field or
> something else, if later that pages are used by page caches again
> the page->private maybe not cleared as expected.
> 
> Here will check the PG_private bit instead of the folio->private.

I thought that a patch to set ->private to NULL in the folio code (maybe
in folio_end_private_2()) would make sense.  But then... it probably
wouldn't get accepted as we're probably not supposed to assume these
fields are initialised.

Anyway, thanks Xiubo!

Reviewed-by: Luís Henriques <lhenriques@suse.de>

Cheers,
--
Luís

> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/55421
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 63b7430e1ce6..1a108f24e7d9 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>  	if (folio_test_dirty(folio)) {
>  		dout("%p dirty_folio %p idx %lu -- already dirty\n",
>  		     mapping->host, folio, folio->index);
> -		VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
> +		VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
>  		return false;
>  	}
>  
> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>  	 * Reference snap context in folio->private.  Also set
>  	 * PagePrivate so that we get invalidate_folio callback.
>  	 */
> -	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
> +	VM_BUG_ON_FOLIO(folio_test_private(folio), folio);
>  	folio_attach_private(folio, snapc);
>  
>  	return ceph_fscache_dirty_folio(mapping, folio);
> @@ -150,7 +150,7 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
>  	}
>  
>  	WARN_ON(!folio_test_locked(folio));
> -	if (folio_get_private(folio)) {
> +	if (folio_test_private(folio)) {
>  		dout("%p invalidate_folio idx %lu full dirty page\n",
>  		     inode, folio->index);
>  
> -- 
> 2.36.0.rc1
> 
