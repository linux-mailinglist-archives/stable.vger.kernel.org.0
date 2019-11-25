Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B94108F24
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKYNrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfKYNrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:47:02 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8CCD207FD;
        Mon, 25 Nov 2019 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574689622;
        bh=lMUZda1ivJX7Qdvty4z9vVwl6A7lYcjX1VND1/At+YI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D9JCbT1o8Udg7sBwLtRWRebLzz95h4dxV1kG9QAhCJrTR5Na8YNKeCC58gauZxvuE
         Zjve2guKU+8S3mRjc9hraiVTg/IVvLr3PFUdNCH5tkvSJ9P+WXwyyVdlR7gUhyrpIx
         pv3iQma1i2x0thedqHMDSXh+dsS5Q80EVx7Os5Ro=
Date:   Mon, 25 Nov 2019 08:47:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always
 result in panic
Message-ID: <20191125134700.GA5861@sasha-vm>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122105253.11375-3-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:52:48AM +0000, Lee Jones wrote:
>From: Hari Vyas <hari.vyas@broadcom.com>
>
>[ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]
>
>The bad_mode() handler is called if we encounter an uunknown exception,
>with the expectation that the subsequent call to panic() will halt the
>system. Unfortunately, if the exception calling bad_mode() is taken from
>EL0, then the call to die() can end up killing the current user task and
>calling schedule() instead of falling through to panic().
>
>Remove the die() call altogether, since we really want to bring down the
>machine in this "impossible" case.

Should this be in newer LTS kernels too? I don't see it in 4.14. We
can't take anything into older kernels if it's not in newer ones - we
don't want to break users who update their kernels.

-- 
Thanks,
Sasha
