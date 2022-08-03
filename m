Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B158879C
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 08:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiHCG4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 02:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiHCG4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 02:56:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2732F58E;
        Tue,  2 Aug 2022 23:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DB68B821A4;
        Wed,  3 Aug 2022 06:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B70C433D6;
        Wed,  3 Aug 2022 06:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659509767;
        bh=7GTdvcJCr20A98z951Eqp0mRL54/0sIEeI/3bXuhLRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TtJcI9iyujAaO7fSRRvBsA0M2XBkmPtMCPPrePNoGoaK4jxsOYgDXJNHZMsvdmaXe
         z1kG0YpHXt/AKdS2gKfk25Mi82jeyxzIeRK8q3m5KTal0rGJ8zpT6HeeJ1zkztT7K4
         G+L8fdn81CwtMrf8G5O0/0XFbxkU2AxukqDWFNrQ=
Date:   Wed, 3 Aug 2022 08:56:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.18 72/88] mptcp: dont send RST for single subflow
Message-ID: <YuocBYps1u7zCPMf@kroah.com>
References: <20220801114138.041018499@linuxfoundation.org>
 <20220801114141.321741611@linuxfoundation.org>
 <9ff367ab-bd52-3c3a-a62-2ade761b18f@linux.intel.com>
 <YumVQNNn3xS2Hf/C@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YumVQNNn3xS2Hf/C@sashalap>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 02, 2022 at 05:21:04PM -0400, Sasha Levin wrote:
> On Tue, Aug 02, 2022 at 01:52:15PM -0700, Mat Martineau wrote:
> > On Mon, 1 Aug 2022, Greg Kroah-Hartman wrote:
> > 
> > > From: Geliang Tang <geliang.tang@suse.com>
> > > 
> > > [ Upstream commit 1761fed2567807f26fbd53032ff622f55978c7a9 ]
> > > 
> > > When a bad checksum is detected and a single subflow is in use, don't
> > > send RST + MP_FAIL, send data_ack + MP_FAIL instead.
> > > 
> > > So invoke tcp_send_active_reset() only when mptcp_has_another_subflow()
> > > is true.
> > > 
> > > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Hi Greg -
> > 
> > Please drop this patch from the 5.18-stable queue. It was the first of
> > an 8-patch series and doesn't really stand alone.
> > 
> > This commit message lacks the Fixes: tag and the magic commit message
> > words that I've seen the scripts pick up, so I'm curious: was this patch
> > selected by hand?
> 
> Yup, between the commit message and the code itself, it looked like a
> fix for AUTOSEL.

Ok, now dropped, thanks for the review.

greg k-h
