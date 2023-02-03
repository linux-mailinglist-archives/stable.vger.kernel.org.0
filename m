Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213706892C6
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjBCIyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 03:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBCIya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 03:54:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBBA81B2D;
        Fri,  3 Feb 2023 00:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B145B829B8;
        Fri,  3 Feb 2023 08:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004FC433D2;
        Fri,  3 Feb 2023 08:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675414462;
        bh=0yDJWQOQrDVoHAkzXh1bFCfdWy5BLzDh6Q/DxQqYtJI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JUYZsVb4DY9iyCM6VC7cnMotPN8f8s1wNOKVVJJxHA/iqZdJpqHdHQjv+f3cVKYlS
         S6iRtZG7TQwtks+XOsyMtGzMHwqEcG89+CROhWJeFtmMlecv5Uv1RhvX3exkN5Z6Ph
         dl71+8NJHB/wz5t66sxk7jAzhFElvCbPgLQuSLo4/ZkkZAFn8Acb3JHIEGuYCi4QvK
         YCnhQc54C2kxOm/kcORTEzXeMZP9SzrdvLaSJZHE2QlVSf2RbsJVXGnFq8vPgnX4tn
         xfmoHgczP5bBar0Fk3O9V27b3mHCT3fLXf85JuNyxaCh4C4S3QDp2I6zArWAdHXrRD
         fjew5sHqAShKw==
Message-ID: <4a818d7e-bddd-f44c-d115-a7e81301983a@kernel.org>
Date:   Fri, 3 Feb 2023 16:54:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix cgroup writeback accounting with
 fs-layer encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org
References: <20230203010239.216421-1-ebiggers@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230203010239.216421-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/3 9:02, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), f2fs encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> Fix this by always passing the pagecache page to
> wbc_account_cgroup_owner().
> 
> Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
> Cc: stable@vger.kernel.org
> Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
