Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F2225E81
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGTM1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbgGTM1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 08:27:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3907920684;
        Mon, 20 Jul 2020 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595248035;
        bh=A7gxILitgLHX3aWBdzmsdLYsLfst797hmKf9H1sJ5VQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1Ew0PmZ+yOmZQPp9ra3qSeFpeaeAMtNxfykgh4I5dnxV+EpUc1uUdls8nvEePVJj
         feNDl+RRpdP2+mrq0ChsJrZ1J+jQlG0Q3ATF1CNCrl1P2cw1JRlT6d5dY0gtnYCjL4
         NC/Zqo3+UcstkLiCqyP3MCMSGREOeF9Lvqajavg4=
Date:   Mon, 20 Jul 2020 14:27:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH][STABLE 4.9] irqchip/gic: Atomically update affinity
Message-ID: <20200720122725.GB3147730@kroah.com>
References: <20200707153741.1935141-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707153741.1935141-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 04:37:41PM +0100, Marc Zyngier wrote:
> Commit 005c34ae4b44f085120d7f371121ec7ded677761 upstream.
> 
> The GIC driver uses a RMW sequence to update the affinity, and
> relies on the gic_lock_irqsave/gic_unlock_irqrestore sequences
> to update it atomically.
> 
> But these sequences only expand into anything meaningful if
> the BL_SWITCHER option is selected, which almost never happens.
> 
> It also turns out that using a RMW and locks is just as silly,
> as the GIC distributor supports byte accesses for the GICD_TARGETRn
> registers, which when used make the update atomic by definition.
> 
> Drop the terminally broken code and replace it by a byte write.
> 
> Fixes: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Thanks for the backport, now queued up.

greg k-h
