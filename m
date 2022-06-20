Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF1551577
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbiFTKKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiFTKKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868E643B;
        Mon, 20 Jun 2022 03:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5229460EC6;
        Mon, 20 Jun 2022 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D14AC3411B;
        Mon, 20 Jun 2022 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655719817;
        bh=j2gcVScnAnCRh9va+iai+mbgmOG2AkHu0Y3qUq9Hmzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnlL+avNTPoMd9eMBKlGly5Uw4LR38zebf9Eylf5/R0EKbZJGOUQQCGIQgujsdm64
         DJLS5AXzAKE3MtEyPbdrUqcmb8xLNFD2cyp6sAQcfBEi1M+E9E8hp4p5sPLD8Hs8Do
         8Rbg58erSKcgR5szIFetRzmKwmf3qtCn19U40y1U=
Date:   Mon, 20 Jun 2022 12:10:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@denx.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        baijiaju1990@gmail.com, oslab@tsinghua.edu.cn,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <YrBHh5/FOUWXv3ho@kroah.com>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
 <20220618104925.GA3644@duo.ucw.cz>
 <6497730E-D4D2-4FB3-B95B-E1DAB2C2B287@suse.de>
 <20220618113703.GA10888@duo.ucw.cz>
 <186E5519-55D4-48EE-8599-2C863BEC3918@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <186E5519-55D4-48EE-8599-2C863BEC3918@suse.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 18, 2022 at 07:57:01PM +0800, Coly Li wrote:
> 
> 
> > 2022年6月18日 19:37，Pavel Machek <pavel@ucw.cz> 写道：
> > 
> > Hi!
> > 
> >>>>   Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
> >>> ...
> >>> 
> >>>> +++ b/drivers/md/bcache/request.c
> >>>> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
> >>>> bcache_device *d, struct bio *bio,
> >>>>        * which would call closure_get(&dc->disk.cl)
> >>>>        */
> >>>>       ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> >>>> +       if (!ddip) {
> >>>> +               bio->bi_status = BLK_STS_RESOURCE;
> >>>> +               bio->bi_end_io(bio);
> >>>> +               return;
> >>>> +       }
> >>>> +
> >>>>       ddip->d = d;
> >>>>       /* Count on the bcache device */
> >>>>       ddip->orig_bdev = orig_bdev;
> >>>> 
> >>> 
> >>> So... for patch to make any difference, memory allocation has to fail
> >>> and ddip has to be NULL.
> >>> 
> >>> Before the patch, it would oops in "ddip->d = d;". With the patch, you
> >>> do some kind of error handling. Even if it is buggy, it should not do
> >>> more harm than immediate oops.
> >> 
> >> I just receive this single email and don’t have any idea for the context and what the problem is. Where can I see the whole conversation?
> >> 
> > 
> > Discussion happened on stable@vger.kernel.org mailing lists, archives
> > should be easily available. Copy went to lkml, too.
> 
> Hi Pavel and Greg,
> 
> Thanks for the hint, I see the context. I cannot tell the direct reason of the kfence regression, but it is worthy to have this patch in,
> - commit 7d6b902ea0e0 ("bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()”)
> 
> I am not sure whether it is directly related to the kfence issue, it corrects potential unexpected stack state in some condition. Hope it may help a bit.

Added where?

confused,

greg k-h
