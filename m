Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F223C170D02
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 01:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgB0AKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 19:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgB0AKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 19:10:40 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21B3A24650;
        Thu, 27 Feb 2020 00:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582762239;
        bh=s/cLaiU4VlgQYxriNZOA+RQcTKZIoT6S+M3RY5gTRCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2T9XD2vcXMc0oj/Do7fHk+oVnc9Wpy1cN7rSe3Uo5BxvPYKsokW2uK32hE8UpPjl
         7OOs+lqHfoqYJrHq8Hjmfq3T54+Ow1fl+Bso8jkuzvvFGiMPA8IjV2Nbz2Cc1Yk/YG
         KXPYZtRHmTkz1E5EqpSY1J0F/qLchzSmTF8AePRM=
Date:   Wed, 26 Feb 2020 19:10:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     skakit@codeaurora.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tty: serial: qcom_geni_serial: Fix RX
 cancel command failure" failed to apply to 4.19-stable tree
Message-ID: <20200227001037.GD22178@sasha-vm>
References: <1582713437188162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1582713437188162@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 11:37:17AM +0100, gregkh@linuxfoundation.org wrote:
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
>From 679aac5ead2f18d223554a52b543e1195e181811 Mon Sep 17 00:00:00 2001
>From: satya priya <skakit@codeaurora.org>
>Date: Tue, 11 Feb 2020 15:43:02 +0530
>Subject: [PATCH] tty: serial: qcom_geni_serial: Fix RX cancel command failure
>
>RX cancel command fails when BT is switched on and off multiple times.
>
>To handle this, poll for the cancel bit in SE_GENI_S_IRQ_STATUS register
>instead of SE_GENI_S_CMD_CTRL_REG.
>
>As per the HPG update, handle the RX last bit after cancel command
>and flush out the RX FIFO buffer.
>
>Signed-off-by: satya priya <skakit@codeaurora.org>
>Cc: stable <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/1581415982-8793-1-git-send-email-skakit@codeaurora.org
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For 4.19, I took this mix of cleanups and fixes:

bdc05a8a3f82 ("tty: serial: qcom_geni_serial: Remove xfer_mode variable")
9e06d55f7b85 ("tty: serial: qcom_geni_serial: Remove use of *_relaxed() and mb()")
64a428077758 ("tty: serial: qcom_geni_serial: Remove interrupt storm")
a85fb9ce1fab ("tty: serial: qcom_geni_serial: Remove set_rfr_wm() and related variables")
663abb1a7a7f ("tty: serial: qcom_geni_serial: Fix UART hang")

This patch isn't needed on older kernels.

-- 
Thanks,
Sasha
