Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDECE3F61AA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbhHXPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238247AbhHXPbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 11:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB2061181;
        Tue, 24 Aug 2021 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629819071;
        bh=7mtZkzdsuflGyosca9pCGRvanGXDwYbZeM6ERtnWO2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d7JNq3fPVPrkbw+15UVFxHE2xZ6mUuSCDUZQbOFKc+u5GrVTd3Aljy1rHBg7hFQPw
         +TiPtsXi2UxRRyqIL4RPS1IwXYNutltif2K5OOJU2hgn0uKEbT8PVL1s9cNgt3HiIk
         LAdkWEueTlq3b+GQVtmsLuGuoKqZdnjrs46VEdrAEB2yqpSXCZLQQwavJ41Lq5Nec8
         yWK+LLnxvdbm6cCi3s1NuBZ6AmRkUkNhTaDDuo/JeKp7Ra+llxTgigSBkxcwoXvKqi
         Bzm1/M0zNxm8UPVZbtqy5yArtUcXLmFjCArBX8cETOXWqtE34e2H5tk2T+Wg75KCz0
         ixT26DBGrwEqg==
Date:   Tue, 24 Aug 2021 11:31:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 backport] io_uring: only assign io_uring_enter()
 SQPOLL error in actual error case
Message-ID: <YSUQvfIu7ADDHIUY@sashalap>
References: <aa7b8101db24bc8639e3206439c2ff9d9dfba3e3.1629807222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aa7b8101db24bc8639e3206439c2ff9d9dfba3e3.1629807222.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:15:31PM +0100, Pavel Begunkov wrote:
>From: Jens Axboe <axboe@kernel.dk>
>
>[ upstream commit 21f965221e7c42609521342403e8fb91b8b3e76e ]
>
>If an SQPOLL based ring is newly created and an application issues an
>io_uring_enter(2) system call on it, then we can return a spurious
>-EOWNERDEAD error. This happens because there's nothing to submit, and
>if the caller doesn't specify any other action, the initial error
>assignment of -EOWNERDEAD never gets overwritten. This causes us to
>return it directly, even if it isn't valid.
>
>Move the error assignment into the actual failure case instead.
>
>Cc: stable@vger.kernel.org
>Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
>Reported-by: Sherlock Holo sherlockya@gmail.com
>Link: https://github.com/axboe/liburing/issues/413
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Queued up, thanks!

-- 
Thanks,
Sasha
