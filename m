Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE847389216
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354932AbhESO6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 10:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347646AbhESO6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 10:58:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F8A261042;
        Wed, 19 May 2021 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621436217;
        bh=Kao3DiQaVq35Y3aSg53y0lbAxXvl63c1+Rj8pPznmlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqjyB+WGlHcUjjDiEoo4BamIOHofc8ZL4yQw5RWKFTRvNa4csHmOViCF2szg9DPAo
         AhzYpk0gd2BP1fBL9A6uTUl0Ro/u5ZUFKbxIiQGIH96KdDclCbNHi0R2FOEE8t96LB
         r13qOEArOej7qzqB+uIoTqtA88jWMPzaTS/3HSsPsGXJ5CUgqmvyAi+9lL4nw5xqZf
         4gBRNN3jLxzFDQ1Rl+xXH4uRCc9mxTb8j3e6VMbS9P7Nd1nij80DwJU1MbUTg4reDI
         leEix2/3h+g6KgpNweufTX7g/aFckTMxXxa1KOXBBAasKq19QbrQuQLDXaCpAs146d
         O95iN+cJoBkYg==
Date:   Wed, 19 May 2021 10:56:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, snitzer@redhat.com, agk@redhat.com,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH stable] dm ioctl: fix out of bounds array access when no
 devices
Message-ID: <YKUnOBqGgfHPXX5F@sashalap>
References: <20210519074124.49890-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210519074124.49890-1-ardb@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 09:41:24AM +0200, Ard Biesheuvel wrote:
>From: Mikulas Patocka <mpatocka@redhat.com>
>
>commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.
>
>If there are not any dm devices, we need to zero the "dev" argument in
>the first structure dm_name_list. However, this can cause out of
>bounds write, because the "needed" variable is zero and len may be
>less than eight.
>
>Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
>too small to hold the "nl->dev" value.
>
>Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>---
>Please apply to 4.4.y and 4.9.y

We already carry this patch via the backport provided in
https://lore.kernel.org/stable/20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp/


-- 
Thanks,
Sasha
