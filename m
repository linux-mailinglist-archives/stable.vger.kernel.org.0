Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32C6CBE3B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjC1L5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1L5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:57:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0303F83EC;
        Tue, 28 Mar 2023 04:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 907D4B81C1B;
        Tue, 28 Mar 2023 11:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1A5C433EF;
        Tue, 28 Mar 2023 11:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004634;
        bh=LwTBjMUAtQcMZXMxLYmp9A8uaSZhKZEpmFKC/rgoKJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zHay5p5fLqPGgAO5n1RcEFOPfuCuYDn+uTA08vLA2bp7aoZUrhDvbrBsqy9CJ9jBG
         ii1hSMUXI9pZfTIuBMsaEEKZhLT/dig/t7CtB3g2cB9vlxdvVGsMbaJrfBy7tBGisa
         DpdtDbfqV86HWBH3fjiFzDY1oqTHRl+0B3X+s2Bo=
Date:   Tue, 28 Mar 2023 13:57:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        stable@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 5.15] lockd: set file_lock start and end when decoding
 nlm4 testargs
Message-ID: <ZCLWF3hNQxyncHNz@kroah.com>
References: <20230321104628.37323-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321104628.37323-1-amir73il@gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 12:46:28PM +0200, Amir Goldstein wrote:
> From: Jeff Layton <jlayton@kernel.org>
> 
> commit 7ff84910c66c9144cc0de9d9deed9fb84c03aff0 upstream.
> 
> Commit 6930bcbfb6ce dropped the setting of the file_lock range when
> decoding a nlm_lock off the wire. This causes the client side grant
> callback to miss matching blocks and reject the lock, only to rerequest
> it 30s later.
> 
> Add a helper function to set the file_lock range from the start and end
> values that the protocol uses, and have the nlm_lock decoder call that to
> set up the file_lock args properly.
> 
> Fixes: 6930bcbfb6ce ("lockd: detect and reject lock arguments that overflow")
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Tested-by: Amir Goldstein <amir73il@gmail.com>
> Cc: stable@vger.kernel.org #6.0
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Greg,
> 
> The upstream fix applies cleanly to 6.1.y and 6.2.y, so as the
> Cc stable mentions, please apply upstream fix to those trees.
> 
> Alas, the regressing commit was also applied to v5.15.61,
> so please apply this backport to fix 5.15.y.

Now queued up, thanks.

greg k-h
