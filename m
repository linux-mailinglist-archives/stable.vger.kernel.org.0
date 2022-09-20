Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B775BEAC4
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiITQGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiITQGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:06:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CE53DF1E
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:06:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id y11so3557200pjv.4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=mVXjEkchDteCE1zCDTUzpbpt8ACeKtrTbNbxuuk9ZdA=;
        b=WhArmtdqs/KKDWTWMCosIdRxKr5Uet/gXZ+ddafXZpICoDfqgBCpm+m0BrBuw5VioO
         N01TiT3dRBp4xqgudzkm/sAl1qlY6gQRp0RC6rRz6Go7V8X64Hkj64kZuiRacglKXcCE
         L0xB0mvUGlbtRw3Byz1SGuCNldmz/jpLsQRM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mVXjEkchDteCE1zCDTUzpbpt8ACeKtrTbNbxuuk9ZdA=;
        b=zLzQ1iQ3vJMnBtcuaLkGJNzCzA+j+B75z1vkfB/C5yqEsunO9FlxJ/jNhH4N4U9A9W
         PMS71eZVnxNdbp5lYmRGmtqjshH8daoihregjR7GxCibRvsIB3sveOgTamtl7swp+u3K
         UctsQX9BniyZ3q+zsFghMJFgUkdnuGmuldwo3/bNNGCV2AxOQ1HZZldBugdQc3djGpdt
         yKLWf7/9+X3IVzNlo7qLxyjR3qL92vlKprO6Ihf2LvtxtIddxbpBJLvWdE47mw+Yiqyp
         PUtNJkSvtVDtiQrSXE7cm3vvRc1KnjGVVvQp4TLA9POsNbDCqBhAeTzX5hf8GdISKp70
         yOOA==
X-Gm-Message-State: ACrzQf3XBaNlBvQZSz5lbAWNQHkpmLEGyKu4cBa4igw6imuMNCOVsKvf
        Rso8kGBe5ic9gI4p2lB4t9EGkV38P/HD+1Fz
X-Google-Smtp-Source: AMsMyM4CDISk3X5hd2+0a+iB0Ji58ldPnFUwavVGxhVfv8jmCnDVTEmhu9onCz743+5jWuUglxommQ==
X-Received: by 2002:a17:903:32c4:b0:178:5206:b396 with SMTP id i4-20020a17090332c400b001785206b396mr365485plr.99.1663689968516;
        Tue, 20 Sep 2022 09:06:08 -0700 (PDT)
Received: from medusa.lab.kspace.sh (c-98-207-191-243.hsd1.ca.comcast.net. [98.207.191.243])
        by smtp.googlemail.com with ESMTPSA id l2-20020a170902f68200b001730a1af0fbsm102688plg.23.2022.09.20.09.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 09:06:07 -0700 (PDT)
Date:   Tue, 20 Sep 2022 09:06:06 -0700
From:   Mohamed Khalfella <mkhalfella@purestorage.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     stable@vger.kernel.org, Eric Badger <ebadger@purestorage.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tao Chiu <taochiu@synology.com>,
        Leon Chien <leonchien@synology.com>,
        Cody Wong <codywong@synology.com>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvme-pci: Make sure to ring doorbell when last request
 is short-circuited
Message-ID: <20220920160606.GB3444537@medusa>
References: <20220918054816.936669-1-mkhalfella@purestorage.com>
 <YyioTUV/Td+yf0Z6@kbusch-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyioTUV/Td+yf0Z6@kbusch-mbp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-19 11:35:09 -0600, Keith Busch wrote:
> > Fixes: d4060d2be1132 ("nvme-pci: fix controller reset hang when racing with nvme_timeout")
> 
> I revisted that commit, and it doesn't sound correct. Specifically this part:
> 
>     5) reset_work() continues to setup_io_queues() as it observes no error
>        in init_identify(). However, the admin queue has already been
>        quiesced in dev_disable(). Thus, any following commands would be
>        blocked forever in blk_execute_rq().
> 
> When a timeout occurs in the CONNECTING state, the timeout handler unquiesces
> the queue specifically to flush out any blocked requests. Is that commit really
> necessary? I'd rather just revert it to save the extra per-IO checks if not.

I can not speak with certainty whether 4060d2be1132 need to be reverted or not.
I will need to carefully inspect reset code path and do more experiments. If this
commit gets reverted we still need to add `nvme_commit_rqs` to `nvme_mq_admin_ops`.
