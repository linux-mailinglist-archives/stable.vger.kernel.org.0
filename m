Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7DC154FEC
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGBNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 20:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgBGBNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 20:13:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E7EC20715;
        Fri,  7 Feb 2020 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581038022;
        bh=Tgalsm7tAF/zyu7ZKMWI6zSaZ13xomS6oQRXlGK064o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jAsHJ6u+kqzq1xoF9mx42x8pk7WZL52dZagMXd49Lr7TWOK7s68rLb/RXdJJ2To0e
         Pgv+t7QL5CP874ZrKiuWCTKEN50jJb4di0o8QFZlPKgKLT5aVT5/5416fXjEJr/OiO
         0GMDUoF4ShhBKYtyFhw1iwjzry5NMNy1xiATfvCY=
Date:   Thu, 6 Feb 2020 20:13:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ebiggers@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ubifs: don't trigger assertion on invalid
 no-key filename" failed to apply to 4.14-stable tree
Message-ID: <20200207011341.GR31482@sasha-vm>
References: <158101646257220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158101646257220@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:14:22PM +0100, gregkh@linuxfoundation.org wrote:
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
>From f0d07a98a070bb5e443df19c3aa55693cbca9341 Mon Sep 17 00:00:00 2001
>From: Eric Biggers <ebiggers@google.com>
>Date: Mon, 20 Jan 2020 14:31:59 -0800
>Subject: [PATCH] ubifs: don't trigger assertion on invalid no-key filename
>
>If userspace provides an invalid fscrypt no-key filename which encodes a
>hash value with any of the UBIFS node type bits set (i.e. the high 3
>bits), gracefully report ENOENT rather than triggering ubifs_assert().
>
>Test case with kvm-xfstests shell:
>
>    . fs/ubifs/config
>    . ~/xfstests/common/encrypt
>    dev=$(__blkdev_to_ubi_volume /dev/vdc)
>    ubiupdatevol $dev -t
>    mount $dev /mnt -t ubifs
>    mkdir /mnt/edir
>    xfs_io -c set_encpolicy /mnt/edir
>    rm /mnt/edir/_,,,,,DAAAAAAAAAAAAAAAAAAAAAAAAAA
>
>With the bug, the following assertion fails on the 'rm' command:
>
>    [   19.066048] UBIFS error (ubi0:0 pid 379): ubifs_assert_failed: UBIFS assert failed: !(hash & ~UBIFS_S_KEY_HASH_MASK), in fs/ubifs/key.h:170
>
>Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
>Cc: <stable@vger.kernel.org> # v4.10+
>Link: https://lore.kernel.org/r/20200120223201.241390-5-ebiggers@kernel.org
>Signed-off-by: Eric Biggers <ebiggers@google.com>

Contextual conflicts due to missing 6eb61d587f45 ("ubifs: Pass struct
ubifs_info to ubifs_assert()"). Fixed up and queued up.

-- 
Thanks,
Sasha
