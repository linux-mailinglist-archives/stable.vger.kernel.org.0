Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1286D6C20
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbjDDScJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbjDDSbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEE52D7F
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 11:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11B4D63557
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 18:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3274C433EF;
        Tue,  4 Apr 2023 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680632927;
        bh=BxxKJL+9mFS9yoZHZ1LpQC3nM6iq9Y/UD6VyFBiIDoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tk15h++eFvtm+c1Kp2fI0QjVX4ShF3sZIvjyP74dkZhqLe+ZLZGDdKIdAW4x9uHGz
         DlWRXuik9vA/jkHqkjK5s6ZalF+Zw2HNqZyfueri6PEco3/grLqwxe4f8DuS5mSyAc
         SBD7n4zhxcK0Rpetw2ZplDyBS8jaQ4Q+WSUm4Y+c=
Date:   Tue, 4 Apr 2023 20:28:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pascal Ernster <git@hardfalcon.net>,
        Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.1 021/181] blk-mq: move the srcu_struct used for
 quiescing to the tagset
Message-ID: <2023040433-festival-bonehead-3b24@gregkh>
References: <20230403140415.090615502@linuxfoundation.org>
 <20230403140415.825266522@linuxfoundation.org>
 <401a5df3-b13b-fb56-a305-9c82f5f0ca77@0.smtp.remotehost.it>
 <ZCt6vpfpJCk0J451@ovpn-8-16.pek2.redhat.com>
 <2f2bcc75-e46b-6849-734c-2e646d9bb382@0.smtp.remotehost.it>
 <ZCxAAkotxZ+VBHkS@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCxAAkotxZ+VBHkS@sashalap>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 11:19:30AM -0400, Sasha Levin wrote:
> On Tue, Apr 04, 2023 at 07:56:10AM +0200, Pascal Ernster wrote:
> > [2023-04-04 03:17] Ming Lei:
> > > On Mon, Apr 03, 2023 at 11:06:53PM +0200, Pascal Ernster wrote:
> > > > On systems with their (btrfs) root filesystem residing on an LVM volume,
> > > > this patch is reproducibly causing a complete freeze during shutdowns and
> > > > reboots.
> > > > 
> > > > I had previously replied with the same message to patch 022/181 instead of
> > > > this one, but had gotten the subject mixed up actually meant this patch.
> > > 
> > > That is because the dependency patch is missed:
> > > 
> > > commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
> > > 
> > > https://lore.kernel.org/linux-block/Y6qpwYaPOxgsZjp9@T590/
> > 
> > 
> > Thanks a lot Ming, this does indeed fix the issue for me. :)
> 
> Perfect, thanks for the report and the fix.
> 
> I've dropped these two patches from the 6.1 tree for now with plans to
> re-do it along with the missing dependency for the next release.

Thanks for this, I'll go push out a -rc2 for this branch now.

greg k-h
