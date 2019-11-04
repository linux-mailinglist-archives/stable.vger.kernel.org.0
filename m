Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD01EE1DC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKDOHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfKDOHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 09:07:15 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C03D6218BA;
        Mon,  4 Nov 2019 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572876435;
        bh=plUVQEs0/g0CabIIytxU/ZCRSSlQmRWUcw5LlZZ7TDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=slf9T/+xInl4yGEI6FH8tKtrTxeTHMSmYI4qHP06aBa3VF3pTvDUum6cQcJLRaK5E
         RMKS3mhuYk5pm60FH3S3/LWJ7s2MjFGnwI5R9/rqMP3o2AD0o9e3zB91S4nLxrvf5P
         MtLPIe9A6Wc9QjArLvkKrnOePN1jKaFxf+jwD5Ls=
Date:   Mon, 4 Nov 2019 09:07:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jeffrey.l.hugo@gmail.com, vkoul@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: Fix resource
 leak" failed to apply to 4.14-stable tree
Message-ID: <20191104140713.GE4787@sasha-vm>
References: <15728601263783@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15728601263783@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 10:35:26AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 7667819385457b4aeb5fac94f67f52ab52cc10d5 Mon Sep 17 00:00:00 2001
>From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
>Date: Thu, 17 Oct 2019 08:26:06 -0700
>Subject: [PATCH] dmaengine: qcom: bam_dma: Fix resource leak
>
>bam_dma_terminate_all() will leak resources if any of the transactions are
>committed to the hardware (present in the desc fifo), and not complete.
>Since bam_dma_terminate_all() does not cause the hardware to be updated,
>the hardware will still operate on any previously committed transactions.
>This can cause memory corruption if the memory for the transaction has been
>reassigned, and will cause a sync issue between the BAM and its client(s).
>
>Fix this by properly updating the hardware in bam_dma_terminate_all().
>
>Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
>Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
>Signed-off-by: Vinod Koul <vkoul@kernel.org>

Is the "Fixes:" tag correct here? Is it an issue without 6b4faeac05bc
("dmaengine: qcom-bam: Process multiple pending descriptors")?

-- 
Thanks,
Sasha
