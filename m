Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0EB52AEC2
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 01:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiEQXkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiEQXkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 19:40:19 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31552B2D;
        Tue, 17 May 2022 16:40:17 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24HNeBeV025445
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 19:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652830813; bh=yudY1KSzaioCjsKXxnR8HzItY9g7OOThkY3Hy2/pFe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=eHzdX/Uzdhz+PdzyDzyEHGbPDcvSSChiswewBs8UcZJ5PItthvVJN4OMkVn84UKmc
         EI1+A+xLZdGBCr6TGah4/1rnT3V0ONFpNQafThN/OKp7AwWHj2b4ZE/u3Wh27OCh8k
         42p3NgBdPAglq3FDFtzUSyy17MRg7xC+CCDkJDP+ZPOK3J9awEIo2HiAMlWgXTpRYI
         it1YK1upDGf/LXcET0ROkJw94BDCIK+B6uNCMpjr9i0fv5tIj3uc0uNzXHil4OsqCl
         aYECp8MbKb1pwcSJClmmPeqvpMa2ogIyhAr6/vV6Kze9GnuHh9M2TFKwpqAsEccx09
         Fix1wxgm8O3jA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6D25715C3EC0; Tue, 17 May 2022 19:40:11 -0400 (EDT)
Date:   Tue, 17 May 2022 19:40:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: Verify dir block before splitting it
Message-ID: <YoQyW46RmvG7a1kE@mit.edu>
References: <20220428180355.15209-1-jack@suse.cz>
 <20220428183143.5439-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428183143.5439-1-jack@suse.cz>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 08:31:37PM +0200, Jan Kara wrote:
> Before splitting a directory block verify its directory entries are sane
> so that the splitting code does not access memory it should not.

This commit fails to build due to an undefined variable.  It's fixed
with this hunk in the next patch, which needs to be brought back into
this commit:

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5951e9bb348e..7286472e9558 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1278,7 +1278,7 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 			count++;
 			cond_resched();
 		}
-		de = ext4_next_entry(de, blocksize);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return count;
 }

I was thinking about folding in this change and apply the patch with
that change --- and I may yet do that --- but it looks like there's a
bigger problem with this patch series, which is that it's causing a
crash when running ext4/052 due to what appears to be a smashed stack.
More about that in the reply to patch 2/2 of this series....

						- Ted
