Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20574F1651
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 15:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357703AbiDDNq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 09:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356825AbiDDNqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 09:46:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C0930546
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 06:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59ECCB81217
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 13:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F4FC2BBE4;
        Mon,  4 Apr 2022 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649079865;
        bh=O2/vUxU5p8xd22dTZiFvI6fxO1PgFEUwK0EHp+o9sC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXM3jOgwGPVPgXIZKLmvfmakhW0KVtlfyKnloW7agV5H2AdT459SERNYAFL1ItKG1
         wX9w/CuYRXpNMWUUtcUeM4zI5XlRtxhPaKxQSox9w5CqEpOJaFXYe1hdrZUi3pmiNM
         YQoptdyuKvSvPDJjAPDh4/sIp4MNd0N3Vw1/9PzM=
Date:   Mon, 4 Apr 2022 15:44:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc: 5.4: blk-mq.h:62:33: error: field 'kobj' has
 incomplete type
Message-ID: <Ykr2Nrvvo529xFIH@kroah.com>
References: <CA+G9fYty-Vjznwm6=x3fQystvRoYODKaM_kWrJZmjM8vsA6gFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYty-Vjznwm6=x3fQystvRoYODKaM_kWrJZmjM8vsA6gFw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 06:36:01PM +0530, Naresh Kamboju wrote:
> Linux stable-rc 5.4 branch build breaks on all architecture for allnoconfig.
> 
> metadata:
>     git_describe: v5.4.188-369-ga60d79f382c9
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>     git_sha: a60d79f382c91dcb19578178a5032af6ccbf4c89
>     kconfig:allnoconfig
>     kernel_version: 5.4.189-rc1
>     target_arch: x86_64
>     toolchain: gcc-11
> 
> In file included from include/linux/blk-cgroup.h:25,
>                  from include/linux/writeback.h:14,
>                  from include/linux/memcontrol.h:22,
>                  from include/linux/swap.h:9,
>                  from include/linux/suspend.h:5,
>                  from arch/x86/kernel/asm-offsets.c:13:
> include/linux/blk-mq.h:62:33: error: field 'kobj' has incomplete type
>    62 |         struct kobject          kobj;
>       |                                 ^~~~
> include/linux/blk-mq.h: In function 'blk_mq_rq_from_pdu':
> include/linux/blk-mq.h:352:29: error: invalid application of 'sizeof'
> to incomplete type 'struct request'
>   352 |         return pdu - sizeof(struct request);
>       |                             ^~~~~~
> include/linux/blk-mq.h: In function 'blk_mq_rq_to_pdu':
> include/linux/blk-mq.h:356:19: error: invalid use of undefined type
> 'struct request'
>   356 |         return rq + 1;
>       |                   ^
> include/linux/blk-mq.h: In function 'request_to_qc_t':
> include/linux/blk-mq.h:370:15: error: invalid use of undefined type
> 'struct request'
>   370 |         if (rq->tag != -1)
>       |               ^~
> include/linux/blk-mq.h:371:26: error: invalid use of undefined type
> 'struct request'
>   371 |                 return rq->tag | (hctx->queue_num << BLK_QC_T_SHIFT);
>       |                          ^~
> include/linux/blk-mq.h:373:18: error: invalid use of undefined type
> 'struct request'
>   373 |         return rq->internal_tag | (hctx->queue_num << BLK_QC_T_SHIFT) |
>       |                  ^~
> include/linux/blk-mq.h: In function 'blk_mq_cleanup_rq':
> include/linux/blk-mq.h:379:15: error: invalid use of undefined type
> 'struct request'
>   379 |         if (rq->q->mq_ops->cleanup_rq)
>       |               ^~
> include/linux/blk-mq.h:380:19: error: invalid use of undefined type
> 'struct request'
>   380 |                 rq->q->mq_ops->cleanup_rq(rq);
>       |                   ^~
> make[2]: *** [scripts/Makefile.build:99: arch/x86/kernel/asm-offsets.s] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now fixed up, thanks!

greg k-h
