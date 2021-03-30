Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B445034EE8E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 18:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhC3Q5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 12:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhC3Q4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 12:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3BE761994;
        Tue, 30 Mar 2021 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617123402;
        bh=SqqV9Bgqaz1IcMK50Tp9FkcI1MYclQXsKQMXB24rokY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EMNBgQOcR3vHAcfYWlbr0ptXkTjwn+v0LOvQBFeYs7gBMuW3kM8jvkVByKmsnxSVA
         g2Yx193YUJUbBW99D/rozfk/v23ErvgC6JhNL9q5cgaa13u5Q6NcNZj/v3Cb/CJ9A2
         e87c95zyMSgvRRu4wbKUzMc/cpQh6YwdX74hmFxMIKskTfjmS81pBQqdPdpOa8l95W
         90kHvqHP17wW5QzDtGfwYRNIkZ+Cs/s4SfB9uHuX+NB4H6AehatUclRvXLroRc4nYT
         Eqdb3lcg1hHcU44vUiIJ9H2xOCnjQ2eWHIKDmHWLzqByBlVxjaup/pvfTZoUIyxWk9
         oZnSHfWMLv1SA==
Date:   Tue, 30 Mar 2021 12:56:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     stable@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        zeil@yandex-team.ru, dmtrmonakhov@yandex-team.ru,
        olegsenin@yandex-team.ru
Subject: Re: [PATCH 4.19] tcp: relookup sock for RST+ACK packets handled by
 obsolete req sock
Message-ID: <YGNYSaHYUI8YmbNW@sashalap>
References: <20210329175541.150651-1-ovov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210329175541.150651-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 08:55:41PM +0300, Alexander Ovechkin wrote:
>commit 7233da86697efef41288f8b713c10c2499cffe85 upstream.
>
>Currently tcp_check_req can be called with obsolete req socket for which big
>socket have been already created (because of CPU race or early demux
>assigning req socket to multiple packets in gro batch).
>
>Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
>is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
>But if client sends RST+ACK immediatly after connection being
>established (it is performing healthcheck, for example) retry does not
>occur. In that case tcp_check_req tries to close req socket,
>leaving big socket active.
>
>Fixes: e0f9759f530b ("tcp: try to keep packet if SYN_RCV race is lost")
>Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
>Reported-by: Oleg Senin <olegsenin@yandex-team.ru>

Queued up, thanks!

-- 
Thanks,
Sasha
