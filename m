Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A769366DAB1
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbjAQKP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjAQKPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B4C23C51
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 02:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26BA7B8125C
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 10:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7565FC433D2;
        Tue, 17 Jan 2023 10:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673950551;
        bh=lhx/KUqrh5e3ZOehwPrxoQA/EnH6CB7TxUNOKTl/iE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PfhP5kBvoHRj9gkK8gF/GM9GVVQS3FHUzc34oTv4oZFNH+xIdhP4eNyJvE7pDAwvS
         J40kdignJbvzWrtRvrpBP8+ji6xhbgZIaumIC8nQrkz/4Kj3VPzU96MXq7osKZu2kO
         AJqVgCh1yguL2MY6SfO525B6Jd0+E+pB52UxkNVQ=
Date:   Tue, 17 Jan 2023 09:40:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 097/338] wifi: mac80211: fix memory leak in
 ieee80211_if_add()
Message-ID: <Y8Ze4AARrZEpN2J4@kroah.com>
References: <20230116154820.689115727@linuxfoundation.org>
 <20230116154825.125747074@linuxfoundation.org>
 <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 06:14:35PM +0100, Johannes Berg wrote:
> On Mon, 2023-01-16 at 15:49 +0000, Greg Kroah-Hartman wrote:
> > From: Zhengchao Shao <shaozhengchao@huawei.com>
> > 
> > [ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]
> > 
> > When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
> > isn't released. Fix it.
> > 
> 
> Please drop this wherever you still can - we just reverted it because it
> was actually based on broken analysis.

Thanks, will drop it from 5.4 and older queues.

greg k-h
