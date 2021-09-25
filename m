Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19554181C2
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 13:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhIYLzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 07:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhIYLzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 07:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F28D61279;
        Sat, 25 Sep 2021 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632570814;
        bh=8PPCNSEHwg0GRnU7I42SpHXomGQuXEXur5VrtiBLaW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klAbZMFwR6d1xTrNFigEaYAh76A22T4sXZIukGtTTJnpu15DAC4KSMxyoP/JLf/bK
         qBXTDyQzCHD7MP9F+9E+0CJeSNpanfLyDuPZ/6Mn5m+PcFXHjbhknXMMQlab5NCfCp
         +G6PsYLzIrqqohVleUqR+h/DFi2FgATY9ZdsSG2Y=
Date:   Sat, 25 Sep 2021 13:53:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 080/100] habanalabs: fix race between soft reset and
 heartbeat
Message-ID: <YU8Nu4UPvbZbAwm7@kroah.com>
References: <20210924124341.214446495@linuxfoundation.org>
 <20210924124344.145361365@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924124344.145361365@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 02:44:29PM +0200, Greg Kroah-Hartman wrote:
> From: Koby Elbaz <kelbaz@habana.ai>
> 
> [ Upstream commit 8bb8b505761238be0d6a83dc41188867d65e5d4c ]
> 
> There is a scenario where an ongoing soft reset would race with an
> ongoing heartbeat routine, eventually causing heartbeat to fail and
> thus to escalate into a hard reset.
> 
> With this fix, soft-reset procedure will disable heartbeat CPU messages
> and flush the (ongoing) current one before continuing with reset code.
> 
> Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
> Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
> Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/habanalabs/common/device.c      | 53 +++++++++++++++-----
>  drivers/misc/habanalabs/common/firmware_if.c | 18 +++++--
>  drivers/misc/habanalabs/common/habanalabs.h  |  4 +-
>  drivers/misc/habanalabs/common/hw_queue.c    | 30 ++++-------
>  4 files changed, 67 insertions(+), 38 deletions(-)
> 

This change adds a build warning so I'm going to drop it from the tree
for now.

thanks,

greg k-h
