Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C1E3BDA5
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 22:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389429AbfFJUlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 16:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389342AbfFJUlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 16:41:51 -0400
Received: from localhost (unknown [131.107.159.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D06D206E0;
        Mon, 10 Jun 2019 20:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560199310;
        bh=vco3alXsyEZ3Pf5L4IM4jawZgEBKBnLdOEd0A2F9uNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oyQLbBoHoiAnjleVvS98BsHm+66HpWwU0Upke5n6n6KCGMh+9x9AKoW1vHUlxMgx5
         aR94ZzbummD7T6nuRKrSX5ILuhMCqYd8b0Fq8XNUnYjTIS8L5IGjdPvKzNcHKTeA7l
         f5+Y7f4UfBGFkzilVhFUUvce4QJlpASJLh7+gL+c=
Date:   Mon, 10 Jun 2019 16:41:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.0+ 2/3] nvme-tcp: fix possible null deref on a
 timed out io queue connect
Message-ID: <20190610204150.GA1655@sasha-vm>
References: <20190610045826.13176-1-sagi@grimberg.me>
 <20190610045826.13176-2-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190610045826.13176-2-sagi@grimberg.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 09:58:25PM -0700, Sagi Grimberg wrote:
>Upstream commit: Fixes: d10325e5a9ca ("nvme-tcp: fix possible null deref
>on a timed out io queue connect"

Upstream commit here is f34e25898a608 :)

--
Thanks,
Sasha

>If I/O queue connect times out, we might have freed the queue socket
>already, so check for that on the error path in nvme_tcp_start_queue.
>
>Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/nvme/host/tcp.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
>index 2405bb9c63cc..2b107a1d152b 100644
>--- a/drivers/nvme/host/tcp.c
>+++ b/drivers/nvme/host/tcp.c
>@@ -1423,7 +1423,8 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
> 	if (!ret) {
> 		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
> 	} else {
>-		__nvme_tcp_stop_queue(&ctrl->queues[idx]);
>+		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
>+			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
> 		dev_err(nctrl->device,
> 			"failed to connect queue: %d ret=%d\n", idx, ret);
> 	}
>-- 
>2.17.1
>
