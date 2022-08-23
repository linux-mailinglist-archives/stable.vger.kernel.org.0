Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB70959E46F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiHWM4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiHWMzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:55:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE9123C84
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 03:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661248824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fSKjEkPwBNECJWm8x7JSs95bpa+IJORUywN0gdEUTNA=;
        b=KsHWUwgUtv7A1dFGT69JK/3kw9qYRxEgXNArpK9f+G4vvXQLu/kEwfF1U/tMTkth7nW62D
        2xE3UBvk+B2ja9U2IIz9/HpzPuxQ9AcF8/Ai9TIeAwa9KZ1U6IoC4dT+83zU944w3R7GD5
        z3DwJMXHxq26WuQf/jg0Q6BPp4+V6Dg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-OJwysFzpPuicEiN_cP8fhA-1; Tue, 23 Aug 2022 06:00:22 -0400
X-MC-Unique: OJwysFzpPuicEiN_cP8fhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 798023C0D854;
        Tue, 23 Aug 2022 10:00:22 +0000 (UTC)
Received: from fedora (unknown [10.40.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8920F40D2830;
        Tue, 23 Aug 2022 10:00:21 +0000 (UTC)
Date:   Tue, 23 Aug 2022 12:00:19 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Salvatore Bonaccorso <carnil@debian.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix check for block being out of directory size
Message-ID: <20220823100019.wukhx7a6bul4isjl@fedora>
References: <20220822114832.1482-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822114832.1482-1-jack@suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 01:48:32PM +0200, Jan Kara wrote:
> The check in __ext4_read_dirblock() for block being outside of directory
> size was wrong because it compared block number against directory size
> in bytes. Fix it.

Good catch, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
> CVE: CVE-2022-1184
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3a31b662f661..bc2e0612ec32 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
>  	struct ext4_dir_entry *dirent;
>  	int is_dx_block = 0;
>  
> -	if (block >= inode->i_size) {
> +	if (block >= inode->i_size >> inode->i_blkbits) {
>  		ext4_error_inode(inode, func, line, block,
>  		       "Attempting to read directory block (%u) that is past i_size (%llu)",
>  		       block, inode->i_size);
> -- 
> 2.35.3
> 

