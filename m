Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69D4EC4FB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345275AbiC3Mzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244567AbiC3Mz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:55:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4A3B7C43;
        Wed, 30 Mar 2022 05:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4A260DBD;
        Wed, 30 Mar 2022 12:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDD6C340EC;
        Wed, 30 Mar 2022 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648644822;
        bh=9Lzjr4C0o5+FuexRlUqn1UHUEVXyAWYqGNh6uZkxC+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i0VxgskMCgRM4kAySGl45svHARNH1Vsj2v4R1/c+RIJI29ku2csDF2j3rFwiOxL00
         zD2NzTqJ05g61MQJsfxU7IWLVUzO67+jusGwUN7Ec+u/DUUrd4Ju5Dm+kk8RSCBRWA
         faaoHHtIrNOmx3wSdMKj6qn+zcSk448lrazNpC5ZGzKfsUNbAV4vYXJix1bo9o2L3C
         XcOf/yEZedo1xCjlWd/zOjgKFWufBA3obKORa12PHQCz3XG2ooiekq+HITSjrD5deT
         1Qv6/iU6hRN0GHDG8gLS6O2oJcOrPfBquBwY3f7BHTbu7Sx1P0Ahf2oXtpWwenYOt7
         NOGodGQ697QUA==
Date:   Wed, 30 Mar 2022 15:53:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     bharat@chelsio.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, roland@purestorage.com,
        stable@vger.kernel.org, vipul@chelsio.com
Subject: Re: [PATCH] cxgb4: cm: fix a incorrect NULL check on list iterator
Message-ID: <YkRS0sImiTd+mhd3@unreal>
References: <YkCTB/F4jc3DWRo8@unreal>
 <20220330123027.25897-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330123027.25897-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 08:30:27PM +0800, Xiaomeng Tong wrote:
> On Sun, 27 Mar 2022 19:38:31 +0300, Leon Romanovsky wrote:
> > 
> > On Sun, Mar 27, 2022 at 03:35:42PM +0800, Xiaomeng Tong wrote:
> > > The bug is here:
> > > 	if (!pdev) {
> > > 
> > > The list iterator value 'pdev' will *always* be set and non-NULL
> > > by for_each_netdev(), so it is incorrect to assume that the
> > > iterator value will be NULL if the list is empty or no element
> > > found (in this case, the check 'if (!pdev)' can be bypassed as
> > > it always be false unexpectly).
> > > 
> > > To fix the bug, use a new variable 'iter' as the list iterator,
> > > while use the original variable 'pdev' as a dedicated pointer to
> > > point to the found element.
> > 
> > I don't think that the description is correct.
> > We are talking about loopback interface which received packet, the pdev will always exist.
> 
> Do the both conditions impossible?
> 1. the list is empty or
> 2. we can not found a pdev due to this check
> 	if (ipv6_chk_addr(&init_net,
>   			  (struct in6_addr *)peer_ip,
> 			  pdev, 1))
> 			  iter, 1))

Yes, both are impossible.

Thanks

> 
> > Most likely. the check of "if (!pdev)" is to catch impossible situation where IPV6 packet
> > was sent over loopback, but IPV6 is not enabled.
> 
> --
> Xiaomeng Tong
