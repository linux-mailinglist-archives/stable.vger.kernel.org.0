Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7428C68D31B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjBGJnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjBGJnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:43:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E5D1351B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FE3AB8184F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B083CC433D2;
        Tue,  7 Feb 2023 09:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762991;
        bh=moG2PnbjutcO//sgx5Mgms2iCaoPLFyUJDllp1Ytl7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x66Rs4YCSCTze5nluorJilepIa/H81NNcqG4OwD/vXiy8CsKEIt3uKaOzAIkOzORM
         UXuSDRzJ8yF8QSxsSSWYSZexiF8BQmC0h+td2MAghoqll6wGIwiNd8xQlbALYOsYKm
         8FuE6nkHI/XpgEpnx8Tf5U41LzOINpWpKYCo30C8=
Date:   Tue, 7 Feb 2023 10:43:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, zhangxiaoxu5@huawei.com,
        anna.schumaker@netapp.com, trond.myklebust@hammerspace.com,
        chuck.lever@oracle.com, vegard.nossum@oracle.com,
        error27@gmail.com, darren.kenny@oracle.com, sashal@kernel.org
Subject: Re: [PATCH 5.4.y] xprtrdma: Fix regbuf data not freed in
 rpcrdma_req_create()
Message-ID: <Y+IdLBtCs0hfta7t@kroah.com>
References: <20230205090913.1629173-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205090913.1629173-1-harshit.m.mogalapalli@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 01:09:13AM -0800, Harshit Mogalapalli wrote:
> From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> 
> commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 upstream.
> 
> If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
> to free the send buffer, otherwise, the buffer data will be leaked.
> 
> Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> [Harshit: Backport to 5.4.y]
> Also make the same change for 'req->rl_rdmabuf' at the same time as
> this will also have the same memory leak problem as 'req->rl_sendbuf'
> (This is because commit b78de1dca00376aaba7a58bb5fe21c1606524abe is not
> in 5.4.y)
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Conflict resolution: Replace kfree(req->rl_sendbuf) with the correct free
> function rpcrdma_regbuf_free(req->rl_sendbuf) in out4 label.
> 
> Testing: Only compile and boot tested.
> Thanks to Vegard for pointing out the similar problem with
> 'req->rl_rdmabuf'

Now queued up, thanks.

greg k-h
