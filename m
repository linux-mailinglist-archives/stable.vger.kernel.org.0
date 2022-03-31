Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B94EDBE5
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiCaOpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 10:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiCaOpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 10:45:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95612215928;
        Thu, 31 Mar 2022 07:43:13 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22VEh4kl015789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 10:43:05 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8647215C003E; Thu, 31 Mar 2022 10:43:04 -0400 (EDT)
Date:   Thu, 31 Mar 2022 10:43:04 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
Message-ID: <YkW9+AK2d3i8X9rq@mit.edu>
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315215439.269122-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 02:54:39PM -0700, Tadeusz Struk wrote:
> @@ -3967,6 +3968,16 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  		   offset;
>  	}
>  
> +	/*
> +	 * For punch hole the length + offset needs to be at least within
> +	 * one block before last
> +	 */
> +	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
> +	if (offset + length >= max_length) {
> +		ret = -ENOSPC;
> +		goto out_mutex;
> +	}

I wonder if we would be better off just simply capping length to
max_length?  If length is set to some large value, such as LONG_MAX,
it's pretty clear what the intention should be, which is to simply do
the equivalent of truncating the file at offset.  Perhaps we should
just do that?

That being said, we should be consistent with what other file systems
do when they are asked to punch a hole starting at offset and
extending out to LONG_MAX.

Also, if we are going to return an error, I don't think ENOSPC is the
correct error to be returning.

						- Ted
