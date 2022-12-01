Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D0663E8D9
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 05:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLAEcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 23:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLAEce (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 23:32:34 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49544BF;
        Wed, 30 Nov 2022 20:32:32 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B14WAvh006979
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 23:32:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669869133; bh=+8PpL2oL7G5+ST4DJ/Si97ZADlyYBJEabf3Ac/t18+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=fj9khsibVbgI8YGUkwi54W1u5va0SiCc1X6KDeIy2loRzt9YAv7TZBJtP+lzmJiv9
         7WPj4cMd3eIocR+buxFmSzmLr+koq/VEQ+MIK83aalGRuc1gasLQgBDBNkbA8eXdRd
         QoJNvOkEwhFpwb+lzhXoLWHhsr1DEirSF3EXVK1joxEzm/cOTB6UOKoQ5+ABswc4Gi
         95WldHAtzrzhV1RgvlYQOocrPcKC5AqrkmFqHVnY54zHirts+kcHur24Ym4i2zW0dw
         Xygt7Vjb8EFhfZQtLP6+Ef1CizyJPxz9xTb2VMMzdaObXD+pBYEnlZIZuyTNFKyA+A
         Dwa3c6SaA0EUw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C49BD15C46FB; Wed, 30 Nov 2022 23:32:10 -0500 (EST)
Date:   Wed, 30 Nov 2022 23:32:10 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Message-ID: <Y4guSv6wHI1i+3Cz@mit.edu>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de>
 <Y2cAiLNIIJhm4goP@mit.edu>
 <Y2piZT22QwSjNso9@suse.de>
 <Y4U18wly7K87fX9v@mit.edu>
 <d357e15b-e44a-1e3b-41c3-0b732e4685ed@huawei.com>
 <Y4Zy2HHOmak3k637@mit.edu>
 <a448e298-dffd-e2f5-79b9-3997a4f53c92@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a448e298-dffd-e2f5-79b9-3997a4f53c92@huawei.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 11:20:11AM +0800, Baokun Li wrote:
> > If we can protect against the problem by adding a check that has other
> > value as well (such as making usre that when ext4_iget fetches a
> > special inode, we enforce that i_links_couint must be > 0), maybe
> > that's worth it.
>
> Yes, but some special inodes allow i_links_couint to be zero,
> such as the uninitialized boot load inode.

That's a good point; but the only time when a special inode can
validly have a zero i_links_count is when it has no blocks associated
to it.  Otherwise, when the file system releases the inode using
iput() when the file system is unmounted, all of the blocks will get
released when the inode is evicted.  So we can have ext4_iget() allow
fetching an inode if i_blocks[] is zeros.  But if it has any blocks
and i_links_count is non-zero, something must be terribly wrong with
that inode.

Cheers,

					- Ted
