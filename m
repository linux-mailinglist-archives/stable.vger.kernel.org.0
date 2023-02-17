Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E886369AD38
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQN4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 08:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQN4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 08:56:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01514986
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 05:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB744B82B9E
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 13:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F593C433D2;
        Fri, 17 Feb 2023 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642162;
        bh=8d3fa8qadv+o5BOs3W3qWWG0cDGD9Rhb/C1Z0xFFGWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Owk8MpBdK6JoANM90Qs865NQEqKfKLHIH5qCgCuqYy0jZuVV8qfZhPJ0jxgPMTx3g
         71HWwHX28VXCoNg4CTpdr9Zwtel7/ndBOCV500vkv+/GPK9sflv56LSriJBJ4dkpYZ
         3twGc5mgM97iTJAWnTldUt4lx+Coxq04GvSHPNh4=
Date:   Fri, 17 Feb 2023 14:55:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Sasha Levin <sashal@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        stable@vger.kernel.org, mptcp@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.15] mptcp: do not wait for bare sockets' timeout
Message-ID: <Y++Hb/CF9UNBlJTj@kroah.com>
References: <20230214-upstream-stable-20230214-linux-5-15-94-rc1-mptcp-fixes-v1-1-fc57df3fbda0@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214-upstream-stable-20230214-linux-5-15-94-rc1-mptcp-fixes-v1-1-fc57df3fbda0@tessares.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 02:37:33PM +0100, Matthieu Baerts wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> [ Upstream commit d4e85922e3e7ef2071f91f65e61629b60f3a9cf4 ]
> 
> If the peer closes all the existing subflows for a given
> mptcp socket and later the application closes it, the current
> implementation let it survive until the timewait timeout expires.
> 
> While the above is allowed by the protocol specification it
> consumes resources for almost no reason and additionally
> causes sporadic self-tests failures.
> 
> Let's move the mptcp socket to the TCP_CLOSE state when there are
> no alive subflows at close time, so that the allocated resources
> will be freed immediately.
> 
> Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
> Hi Greg, Sasha,
> 
> Here is one MPTCP patch backport that recently failed to apply to the
> 5.15 stable tree: it clears resources earlier if there is no more
> reasons to keep MPTCP sockets alive.
> 
> I had a simple conflict because in v5.15, the context is a bit different
> when iterating over the different subflows in __mptcp_close() but the
> idea is still the same: in this loop, a counter needs to be incremented.

Now queued up, thanks.

greg k-h
