Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF152B608
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiERJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 05:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiERJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 05:10:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773BA13FB1;
        Wed, 18 May 2022 02:10:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 27AA81F9AC;
        Wed, 18 May 2022 09:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652865003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78QKorE5u+svpwXHIAIEDwWldZxmwsbY2t3NfKDaoiY=;
        b=wXUuu/MQ0BmIvelPVc2w7EXINzFwhYAYChTD2cp1zh+M3hBoEX6BqX24Y3SY/iLWh2fJ7D
        3jgPgr8vByeX3hwga/zZB4PXc1lFbR0GGVoLHWuIvMP9IigVN3dlAN49FCCSmbMZ+TjdXj
        sIy5Gc61rpxjMZSuY+PGlQMYrIgRYik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652865003;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78QKorE5u+svpwXHIAIEDwWldZxmwsbY2t3NfKDaoiY=;
        b=vDA5kQEzRjjZ1GgU65u7mCyyv0ifSeKPsZ0ac7Fm71VrgCT0a1SpSwxiRIMV86HhecpI8l
        4uTt5Djg1mQ5raAw==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 19B332C141;
        Wed, 18 May 2022 09:10:03 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 53132A062F; Wed, 18 May 2022 11:09:56 +0200 (CEST)
Date:   Wed, 18 May 2022 11:09:56 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: Verify dir block before splitting it
Message-ID: <20220518090956.ttowg7yweyqbshmp@quack3.lan>
References: <20220428180355.15209-1-jack@suse.cz>
 <20220428183143.5439-1-jack@suse.cz>
 <YoQyW46RmvG7a1kE@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoQyW46RmvG7a1kE@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 17-05-22 19:40:11, Theodore Ts'o wrote:
> On Thu, Apr 28, 2022 at 08:31:37PM +0200, Jan Kara wrote:
> > Before splitting a directory block verify its directory entries are sane
> > so that the splitting code does not access memory it should not.
> 
> This commit fails to build due to an undefined variable.  It's fixed
> with this hunk in the next patch, which needs to be brought back into
> this commit:
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5951e9bb348e..7286472e9558 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1278,7 +1278,7 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
>  			count++;
>  			cond_resched();
>  		}
> -		de = ext4_next_entry(de, blocksize);
> +		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
>  	}
>  	return count;
>  }
> 
> I was thinking about folding in this change and apply the patch with
> that change --- and I may yet do that --- but it looks like there's a
> bigger problem with this patch series, which is that it's causing a
> crash when running ext4/052 due to what appears to be a smashed stack.
> More about that in the reply to patch 2/2 of this series....

Yup, I'll fix that. Thanks for catching this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
