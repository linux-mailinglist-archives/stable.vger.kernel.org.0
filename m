Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8D21A225
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 16:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGIOag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 10:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgGIOaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 10:30:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353E4206A1;
        Thu,  9 Jul 2020 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594305035;
        bh=gTIRuFInPnZpT8Y7qLXBJtgfp3Hh9ceiMfLybs8juV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASPGdI9if7+kyelDR8NusvWfJqqIegX9jCJo8XRvylYFhB+mnZHYxJxH8gUI8c2xl
         kvI7w0rM4CrZ6Id54jfNzBgEFsUWqe2drKKBPnmjKbRWRGUjHjzdXr1jVsYwvixKYq
         aZ6IyDoObrDi1q9BndiRfaO1R7s+XUBV47QkS7cU=
Date:   Thu, 9 Jul 2020 10:30:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH][STABLE 4.9] irqchip/gic: Atomically update affinity
Message-ID: <20200709143034.GZ2722994@sasha-vm>
References: <20200707153741.1935141-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200707153741.1935141-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 04:37:41PM +0100, Marc Zyngier wrote:
>Commit 005c34ae4b44f085120d7f371121ec7ded677761 upstream.
>
>The GIC driver uses a RMW sequence to update the affinity, and
>relies on the gic_lock_irqsave/gic_unlock_irqrestore sequences
>to update it atomically.
>
>But these sequences only expand into anything meaningful if
>the BL_SWITCHER option is selected, which almost never happens.
>
>It also turns out that using a RMW and locks is just as silly,
>as the GIC distributor supports byte accesses for the GICD_TARGETRn
>registers, which when used make the update atomic by definition.
>
>Drop the terminally broken code and replace it by a byte write.
>
>Fixes: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature")
>Cc: stable@vger.kernel.org
>Signed-off-by: Marc Zyngier <maz@kernel.org>

Queued for 4.9, thanks!

-- 
Thanks,
Sasha
