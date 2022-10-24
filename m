Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427360B85B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiJXTod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiJXTnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:43:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC3E11D9BA;
        Mon, 24 Oct 2022 11:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A65A6B81031;
        Mon, 24 Oct 2022 18:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154A0C433D6;
        Mon, 24 Oct 2022 18:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666634902;
        bh=qep4w+b92fX6ZpVVv9x9hworbqWybvlfmI8Ce9BMyPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kSrKzAe4o9mq5n1T3MW6qkWtujGrH6lzbPzFj6Ic1HFWt8bJEmMac5k7XYzwZpSi3
         EwGizA7qGtxV8CEDwn1hMjT6PKtTxsto1bWyokEvv63XagbcQMvKbY5FOcYqmdw6MW
         7IgBw+OkWtxhSTSXY+kcS8yxgHIaNYPNC8E4G0CZBvy68v34XCm5/3I1sUeXEPyLrx
         pgqbCSLnkZ451Mc0wOXzFW5i5d4Z8kU+f26//YSy7gBusXbesmuFWa6ZjAwCWgPeBN
         bNnD42wgMbxa0lIYBTZHPDhUrS2v0aRemcyj/J1AX8x6n8FmCeAzrt/WrglozJh9AL
         7vLDWsp8/PK/A==
Date:   Mon, 24 Oct 2022 11:08:20 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 5.10 052/390] f2fs: fix to do sanity check on summary info
Message-ID: <Y1bUlK4aLQ0cZmLW@google.com>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113024.853480982@linuxfoundation.org>
 <20221024173012.GA25198@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024173012.GA25198@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24, Pavel Machek wrote:
> Hi!
> 
> > From: Chao Yu <chao@kernel.org>
> > 
> > commit c6ad7fd16657ebd34a87a97d9588195aae87597d upstream.
> > 
> > As Wenqing Liu reported in bugzilla:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=216456
> > 
> > BUG: KASAN: use-after-free in recover_data+0x63ae/0x6ae0 [f2fs]
> > Read of size 4 at addr ffff8881464dcd80 by task mount/1013
> 
> I believe this is missing put_page on the error path:
> 
> > +++ b/fs/f2fs/gc.c
> > @@ -1003,6 +1003,14 @@ static bool is_alive(struct f2fs_sb_info
> >  		return false;
> >  	}
> >  
> > +	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
> > +						DEF_ADDRS_PER_BLOCK;
> > +	if (ofs_in_node >= max_addrs) {
> > +		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
> > +			ofs_in_node, dni->ino, dni->nid, max_addrs);
> > +		return false;
> > +	}
> > +
> >  	*nofs = ofs_of_node(node_page);
> >  	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
> >  	f2fs_put_page(node_page, 1);
> 
> So something like this is needed. (Feel free to test/adapt/apply).

Urg.. thank you so much for pointing this out. Applied the change to the tree.

https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=a22aeafb3d3569aecf811dca1aceff656695cdb4

> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> Best regards,
> 								Pavel
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 4546e01b2ee0..dab794225cce 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -1110,6 +1110,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
>  	if (ofs_in_node >= max_addrs) {
>  		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
>  			ofs_in_node, dni->ino, dni->nid, max_addrs);
> +		f2fs_put_page(node_page, 1);
>  		return false;
>  	}
>  
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


