Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041E46B5A0D
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 10:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCKJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 04:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCKJcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 04:32:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AE221975;
        Sat, 11 Mar 2023 01:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E284760AB1;
        Sat, 11 Mar 2023 09:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB6AC433D2;
        Sat, 11 Mar 2023 09:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678527150;
        bh=xI1X0O8oS17QYY6z4pOj4CztzzUTWhW9b1MnO3Lz1Yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0jCaPggKywsJZfn3FjxqHQoDUrEHiGzriwdwnGfsMLx1kjQ7a2yrYucErjoA1tzgs
         Qz+4u2mDRGK8ehVJ02e/mgeFEZnvaGIunhNQ9FRGzNbITHdT1DBQGGYE2gC1iZbr4l
         VDr8KVk+h4nhdBxUfDFh30/Upenr8qk8FABOUCGg=
Date:   Sat, 11 Mar 2023 10:32:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Mike Cloaked <mike.cloaked@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Genes Lists <lists@sapience.com>
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Message-ID: <ZAxKq+Czx1dQjl6M@kroah.com>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain>
 <ZAuQOHnfa7xGvzKI@sol.localdomain>
 <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
 <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
 <ZAu030xtaPBGFPBS@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAu030xtaPBGFPBS@sol.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 02:53:19PM -0800, Eric Biggers wrote:
> On Fri, Mar 10, 2023 at 04:08:21PM -0500, Genes Lists wrote:
> > On 3/10/23 15:23, Jens Axboe wrote:
> > > On 3/10/23 1:16 PM, Eric Biggers wrote:
> > ...
> > > But I would revert:
> > > 
> > > bfe46d2efe46c5c952f982e2ca94fe2ec5e58e2a
> > > 57a425badc05c2e87e9f25713e5c3c0298e4202c
> > > 
> > > in that order from 6.2.3 and see if that helps. Adding Yu.
> > > 
> > Confirm the 2 Reverts fixed in my tests as well (nvme + sata drives).
> > Nasty crash - some needed to be power cycled as they hung on shutdown.
> > 
> > Thank you!
> > 
> > gene
> > 
> > 
> 
> Great, thanks.  BTW, 6.1 is also affected.  A simple reproducer is to run:
> 
> 	dmsetup create dev --table "0 128 zero"
> 	dmsetup remove dev
> 
> The following kconfigs are needed for the bug to be hit:
> 
> 	CONFIG_BLK_CGROUP=y
> 	CONFIG_BLK_DEV_THROTTLING=y
> 	CONFIG_BLK_DEV_THROTTLING_LOW=y
> 
> Sasha or Greg, can you please revert the indicated commits from 6.1 and 6.2?

Yes, will go do that right now, thanks for debugging this so quickly!

greg k-h
