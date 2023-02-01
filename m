Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773EB6869FA
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 16:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjBAPVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 10:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjBAPVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 10:21:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE4CC34;
        Wed,  1 Feb 2023 07:21:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14F9617F2;
        Wed,  1 Feb 2023 15:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1997C4339B;
        Wed,  1 Feb 2023 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675264875;
        bh=PkANlXBc7sReU5iRFn4yb7QGnOdMq/TjAGL4DKThOAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GUpSskTAsEV2wje8PR7p3h1sE9QFt5Z+buWHP6qbT9UpmbGVvvmzXiyy5mNZzKEfA
         +ZK3IvmTEyTQDSJiPb914185tlMkZumgFSeIzyjb9pSlDGeKAU3mTIs8WlHhOco1JU
         lFOY0Inudu8zhB1C3XZP/C3IcRujVXpzlFOfz6o9WfPvT11ZwnjBiWhW11qnU7C5az
         gf92brkrPl57rQOFwD3SssGkiOGlrsxmblfqbIqZ76btpHOyUDrXgH69R1avCHUYEr
         gQPbFXeKdccRJ1oa3xnNXOkF3j8AaGFzfb7rfUEWuhAL38kPQfoNhtC/P/sNlAyIwg
         rlhfWNu/OH+5A==
Date:   Wed, 1 Feb 2023 10:21:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 15/35] btrfs: stop using write_one_page in
 btrfs_scratch_superblock
Message-ID: <Y9qDacTWGdANiOJ7@sashalap>
References: <20230124134131.637036-1-sashal@kernel.org>
 <20230124134131.637036-15-sashal@kernel.org>
 <20230124165716.GS11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230124165716.GS11562@twin.jikos.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 05:57:16PM +0100, David Sterba wrote:
>On Tue, Jan 24, 2023 at 08:41:11AM -0500, Sasha Levin wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> [ Upstream commit 26ecf243e407be54807ad67210f7e83b9fad71ea ]
>>
>> write_one_page is an awkward interface that expects the page locked and
>> ->writepage to be implemented.  Replace that by zeroing the signature
>> bytes and synchronize the block device page using the proper bdev
>> helpers.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> [ update changelog ]
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this patch and "btrfs: factor out scratching of one regular
>super block" from all stable queues. It's not a fix, only preparatory
>work to allow removing write_one_page from MM code.
>
>Commit ids: 0e0078f72be81bbb and 26ecf243e407be54

Ack, dropped.

-- 
Thanks,
Sasha
