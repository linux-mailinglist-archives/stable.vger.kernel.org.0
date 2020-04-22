Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62D61B340C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDVAi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgDVAi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:38:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B424E206D5;
        Wed, 22 Apr 2020 00:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587515939;
        bh=bEQPpRIwTiejsf1Dg4ib5cW4vtvh1rPzbqOurabySMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1dNJ0mlxCUNRdbrlD7pmcKRsBUaM/P9MTXL63KhOu3D44bSSrwiY4AaaMCnRFpPrU
         HScCDkncP4KeMR887LF1QUoNvxGSCjn0tKghJb0adCJSb/qnTOOr1Tn29MzxtK1t+H
         kDTairg12KPR3SooIWiQcygt8f7ciII5wgOQUTg0=
Date:   Tue, 21 Apr 2020 20:38:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Hyper-V: Trigger crash enlightenment
 only once during" failed to apply to 4.19-stable tree
Message-ID: <20200422003857.GR1809@sasha-vm>
References: <1587489123120108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1587489123120108@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:12:03PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 73f26e526f19afb3a06b76b970a76bcac2cafd05 Mon Sep 17 00:00:00 2001
>From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Date: Mon, 6 Apr 2020 08:53:28 -0700
>Subject: [PATCH] x86/Hyper-V: Trigger crash enlightenment only once during
> system crash.
>
>When a guest VM panics, Hyper-V should be notified only once via the
>crash synthetic MSRs.  Current Linux code might write these crash MSRs
>twice during a system panic:
>1) hyperv_panic/die_event() calling hyperv_report_panic()
>2) hv_kmsg_dump() calling hyperv_report_panic_msg()
>
>Fix this by not calling hyperv_report_panic() if a kmsg dump has been
>successfully registered.  The notification will happen later via
>hyperv_report_panic_msg().
>
>Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Link: https://lore.kernel.org/r/20200406155331.2105-4-Tianyu.Lan@microsoft.com
>Signed-off-by: Wei Liu <wei.liu@kernel.org>

This patch builds on 74347a99e73a ("x86/Hyper-V: Unload vmbus channel in
hv panic callback") which previously failed to apply. Once that issue
was resolved we can grab this patch too.

-- 
Thanks,
Sasha
