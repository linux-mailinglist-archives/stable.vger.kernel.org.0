Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAD6B54E2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 23:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjCJWyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 17:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjCJWyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 17:54:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E7C5FA46;
        Fri, 10 Mar 2023 14:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB0B5B8242E;
        Fri, 10 Mar 2023 22:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25656C433EF;
        Fri, 10 Mar 2023 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678488801;
        bh=8rw2KDCKekrHmNc8hHv1I2pH/HRctBmo8/l54PCIy2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bhfc0hKMNKyuw2V5FZpRwfs/xZOQNGvate7GE4kfHCmL9nZjLiejBFph1vGWYUzwC
         RRIw7e+Jb22yIwDYnsuAQNCG9yhB46M3d3vut7435FUeCFSOutvKmeTuxcoyjQitkx
         laNHtCV2J6F19e7K4/t01sk5dXalEXq6qL7uGY1P83seaRtQuMlkbkcS2VksCbkWSK
         n2L1QHsoODZzmkcPvgbKS/R2TcvtBqpuQEGi0X33JE81zLv2QYZUg+MS5JT3zzn0E4
         XSrr0yM7yH653naETdFzsarXDsLhsvTvMsi39k8LXndQ5X/oFV1BH+jlVR6QfH4LRY
         Os/Jd8npksCfA==
Date:   Fri, 10 Mar 2023 14:53:19 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Mike Cloaked <mike.cloaked@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Genes Lists <lists@sapience.com>
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Message-ID: <ZAu030xtaPBGFPBS@sol.localdomain>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain>
 <ZAuQOHnfa7xGvzKI@sol.localdomain>
 <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
 <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 04:08:21PM -0500, Genes Lists wrote:
> On 3/10/23 15:23, Jens Axboe wrote:
> > On 3/10/23 1:16 PM, Eric Biggers wrote:
> ...
> > But I would revert:
> > 
> > bfe46d2efe46c5c952f982e2ca94fe2ec5e58e2a
> > 57a425badc05c2e87e9f25713e5c3c0298e4202c
> > 
> > in that order from 6.2.3 and see if that helps. Adding Yu.
> > 
> Confirm the 2 Reverts fixed in my tests as well (nvme + sata drives).
> Nasty crash - some needed to be power cycled as they hung on shutdown.
> 
> Thank you!
> 
> gene
> 
> 

Great, thanks.  BTW, 6.1 is also affected.  A simple reproducer is to run:

	dmsetup create dev --table "0 128 zero"
	dmsetup remove dev

The following kconfigs are needed for the bug to be hit:

	CONFIG_BLK_CGROUP=y
	CONFIG_BLK_DEV_THROTTLING=y
	CONFIG_BLK_DEV_THROTTLING_LOW=y

Sasha or Greg, can you please revert the indicated commits from 6.1 and 6.2?

- Eric
