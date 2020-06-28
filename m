Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F620CAE4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 00:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgF1WHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 18:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgF1WHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 18:07:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D1032065D;
        Sun, 28 Jun 2020 22:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593382064;
        bh=85flt32GJMvCTFeF4muMQEbnyO934vu6fD7rYmmh0co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqdhNM/xhTnChlhHqTrHd7RGKFDow0nrHFvJUosxE/aMKzn7drTApwTZchUQ7X1hL
         6xTzC0H0nMaR/gk0FVrXNU+BZCQ58EYvID/dusx/oO9PwPwkrBAPZE/YITvehYtpjF
         YzyGFHnME+N1xQz8Jeeo1O+kkAJGCCWpreGnaeMM=
Date:   Sun, 28 Jun 2020 18:07:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     zhangxiaoxu5@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when
 punch hole" failed to apply to 4.19-stable tree
Message-ID: <20200628220743.GO1931@sasha-vm>
References: <159335937922418@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159335937922418@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 28, 2020 at 05:49:39PM +0200, gregkh@linuxfoundation.org wrote:
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
>From acc91c2d8de4ef46ed751c5f9df99ed9a109b100 Mon Sep 17 00:00:00 2001
>From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>Date: Tue, 23 Jun 2020 07:31:53 -0400
>Subject: [PATCH] cifs/smb3: Fix data inconsistent when punch hole
>
>When punch hole success, we also can read old data from file:
>  # strace -e trace=pread64,fallocate xfs_io -f -c "pread 20 40" \
>           -c "fpunch 20 40" -c"pread 20 40" file
>  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40
>  fallocate(3, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 20, 40) = 0
>  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40
>
>CIFS implements the fallocate(FALLOCATE_FL_PUNCH_HOLE) with send SMB
>ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
>remote file to zero, but local page caches not updated, then the
>local page caches inconsistent with server.
>
>Also can be found by xfstests generic/316.
>
>So, we need to remove the page caches before send the SMB
>ioctl(FSCTL_SET_ZERO_DATA) to server.
>
>Fixes: 31742c5a33176 ("enable fallocate punch hole ("fallocate -p") for SMB3")
>Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
>Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>Cc: stable@vger.kernel.org # v3.17
>Signed-off-by: Steve French <stfrench@microsoft.com>

Conflict with capitalization in the debug print. Fixed up and queued for
4.19, 4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
