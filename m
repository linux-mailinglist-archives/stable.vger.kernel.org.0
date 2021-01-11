Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C112F1C90
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbhAKRg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbhAKRg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:36:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98AD1225AB;
        Mon, 11 Jan 2021 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610386577;
        bh=tBXOzFGfcgE5W7gwwjilZZEczAd+4ukSeSqHBeZ/YT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=trX+YiO6EfekqFN1kEYlUlZmpGA8XsB1Xbtxa3xQzK3vTvnFBAD60ir8d++iH/TMw
         7rJg3LaWPwJMxNVVp16sM+XrdCn5eAQNxJhfoXw5ry6bHDVyw8fvkEabV6iVnkyz1F
         EcuEtpNDamH7oNm3kX0t4QSfa1FIxGHkdgCQh6VOkEmzHL689/7lChdyUoKFi1TcO2
         r+zA+ASzW5AmN6XeapZWTKBJ9uEEaFdhB4h4/lIy23Jn2dkb3vh12uLT/NTbMAXo5O
         SEPdKzHaLSMQeIt965pFLKicFq5l/bsq0s1KErm5GUarIAECqxiIHh7VDwRamjxJ30
         fYCp/Yq0I6EBA==
Date:   Mon, 11 Jan 2021 09:36:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH 5.10 018/145] net: dcb: Validate netlink message in DCB
 handler
Message-ID: <20210111093616.552f84da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111130049.387370344@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
        <20210111130049.387370344@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:00:42 +0100 Greg Kroah-Hartman wrote:
> From: Petr Machata <me@pmachata.org>
> 
> [ Upstream commit 826f328e2b7e8854dd42ea44e6519cd75018e7b1 ]
> 
> DCB uses the same handler function for both RTM_GETDCB and RTM_SETDCB
> messages. dcb_doit() bounces RTM_SETDCB mesasges if the user does not have
> the CAP_NET_ADMIN capability.
> 
> However, the operation to be performed is not decided from the DCB message
> type, but from the DCB command. Thus DCB_CMD_*_GET commands are used for
> reading DCB objects, the corresponding SET and DEL commands are used for
> manipulation.
> 
> The assumption is that set-like commands will be sent via an RTM_SETDCB
> message, and get-like ones via RTM_GETDCB. However, this assumption is not
> enforced.
> 
> It is therefore possible to manipulate DCB objects without CAP_NET_ADMIN
> capability by sending the corresponding command in an RTM_GETDCB message.
> That is a bug. Fix it by validating the type of the request message against
> the type used for the response.
> 
> Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
> Signed-off-by: Petr Machata <me@pmachata.org>
> Link: https://lore.kernel.org/r/a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Unfortunately we need to call backsies on this one.

A fix up was just posted:

https://patchwork.kernel.org/project/netdevbpf/patch/a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org/

I'll resend both in the next submission.
