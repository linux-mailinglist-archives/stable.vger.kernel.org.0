Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DB108F29
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKYNsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbfKYNsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:48:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750CA207FD;
        Mon, 25 Nov 2019 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574689716;
        bh=uRvo5BM+DfRgvBvAzbmt31Qfcq6CmesipufUT3U8U/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irVjwicxv7KHpzmr0+5QZZCFZTaWEwenVk2A/QTrOtx2sTfozMUVDcmwqaCAxpyY5
         ZZZdsup/BYSdF4BaU9+vhTrkSavG+w5KP49HskQzzL3t5zqb6JXewPKvrhqX8jDbmO
         5B9Lv/HvdqOVXQ1iEZ2R6atxI65LpvPxFElmR8Pc=
Date:   Mon, 25 Nov 2019 08:48:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 8/8] ext4: avoid unnecessary stalls in
 ext4_evict_inode()
Message-ID: <20191125134835.GC5861@sasha-vm>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-8-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122105253.11375-8-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:52:53AM +0000, Lee Jones wrote:
>From: Jan Kara <jack@suse.cz>
>
>[ Upstream commit 3abb1a0fc2871f2db52199e1748a1d48a54a3427 ]
>
>These days inode reclaim calls evict_inode() only when it has no pages
>in the mapping.  In that case it is not necessary to wait for transaction
>commit in ext4_evict_inode() as there can be no pages waiting to be
>committed.  So avoid unnecessary transaction waiting in that case.
>
>We still have to keep the check for the case where ext4_evict_inode()
>gets called from other paths (e.g. umount) where inode still can have
>some page cache pages.

This reads to me like an optimization?

-- 
Thanks,
Sasha
