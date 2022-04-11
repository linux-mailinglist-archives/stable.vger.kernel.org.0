Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188D94FBCE6
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiDKNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiDKNUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D863DB
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 06:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56531B815E9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AACFC385A3;
        Mon, 11 Apr 2022 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683084;
        bh=7XETpc6pDixDRmh3hgbb7W/MaUQmb9rySQVIjkFYEcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zNWEeA/PlXYzMjhH80N+ZQVGx+75cKzEphUyxZv7ETUYD+SYYON7Bq3oD0LLIQwC+
         JYPq1lY7eoO3SaDy9Hie1dfDXs4ieM/mt1C21HSrSou6PFhCQzQVN7skWz/pxgkkHn
         qjVNKHCu75pG751lo4GtvN6WoLZea0rA+/wfwTiM=
Date:   Mon, 11 Apr 2022 15:18:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, amirtz@nvidia.com
Subject: Re: [PATCH 5.15.y] Revert "net/mlx5: Accept devlink user input after
 driver initialization complete"
Message-ID: <YlQqiWmUTzXZPWtq@kroah.com>
References: <20220407201642.1770157-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407201642.1770157-1-dann.frazier@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 02:16:42PM -0600, dann frazier wrote:
> This reverts commit 9cc25e8529d567e08da98d11f092b21449763144.
> 
> This patch was shown to introduce a regression:
> 
>   # devlink dev param show pci/0000:24:00.0 name flow_steering_mode
>   pci/0000:24:00.0:
>     name flow_steering_mode type driver-specific
>       values:
> 
>   (flow steering mode description is missing beneath "values:")
> 
>   # devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
>   Segmentation fault (core dumped)
> 
>   and also with upstream iproute
>   # ./iproute2/devlink/devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
>   Configuration mode not supported
> 
> Note: Instead of reverting, we could instead also backport commit cf530217408e
> ("devlink: Notify users when objects are accessible"). However, that makes
> changes to core devlink code that I'm not sure are suitable for a stable
> backport.
> 
> Signed-off-by: dann frazier <dann.frazier@canonical.com>

Now queued up, thanks.

greg k-h
