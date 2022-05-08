Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7AE51ED28
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 13:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiEHLEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 07:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiEHLEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 07:04:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C18EDF1B;
        Sun,  8 May 2022 04:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9529B80CF6;
        Sun,  8 May 2022 11:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4182C385AC;
        Sun,  8 May 2022 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652007654;
        bh=EZfKEEIU6fwh+g3DA99Vxb5EFnmexu4Vm1FFiHIGZTY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=caQv8XOk06qog+i2uX6Gcsuf2+7HKtS8azHf0B48MEiK2Es2buQRgcBi4bt9Yq1jB
         ekoxPo8VIkSQrlfQp2ut8Gh24KTTjQ5eG/Cdxz/1f/Kv0Z+2HBGCS64jUiAugx7j3T
         BrGsV9OQsS2phjKMFa0czJlo8t1xb1XZXpcXye3QLFXwOHY1Bz3ZkgDPHa5I7L7e81
         afitPbQuu/bqjN15fPyD2hVXgmVrjQXac5055pHhgBoSoP3SDRz6QeJU7PXuSrRErA
         GgTUDu4qio04xXEeVtAbvTg7H/8+X+r4MuXFV5DDrmAR4Kdy/6SsKgEMglAmgsnEaz
         izn4F0psWe9gQ==
Message-ID: <b106e3661a104a08672cd1b9b97bd1f4bec85740.camel@kernel.org>
Subject: Re: [PATCH] ceph: check folio PG_private bit instead of
 folio->private
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     lhenriques@suse.de, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, stable@vger.kernel.org
Date:   Sun, 08 May 2022 07:00:52 -0400
In-Reply-To: <20220508061543.318394-1-xiubli@redhat.com>
References: <20220508061543.318394-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2022-05-08 at 14:15 +0800, Xiubo Li wrote:
> The pages in the file mapping maybe reclaimed and reused by other
> subsystems and the page->private maybe used as flags field or
> something else, if later that pages are used by page caches again
> the page->private maybe not cleared as expected.
> 
> Here will check the PG_private bit instead of the folio->private.
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

Reviewed-by: Jeff Layton <jlayton@kernel.org>
