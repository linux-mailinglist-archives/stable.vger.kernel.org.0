Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A285E1CA5C5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 10:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEHIMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHIMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 04:12:39 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA13C05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 01:12:38 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id i5so344497uaq.1
        for <stable@vger.kernel.org>; Fri, 08 May 2020 01:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWwTq3jHgl0vF+73+HcJrJHO5r6wPiuEt3hWYFmGy1s=;
        b=MFDfKpxPwGsj8xTnETNOiIP+xhjHs/bQFbn69qKF1+HzOOwBZFODhnJN2quiwfekXx
         Kys+dq0GQgoVpit/riusVb0+s/xZ85m5lorNpLqOTdA1PEm/OO0liOG2TUWKIvDWXTry
         V8jXdk7ZZYqJy9G6BaSzPi9rzCcnz2cxUoQDKwLTFL2iIhWIrM1cI3v0yUE5W6pGLwOW
         HZruxyg48j0ztKttfSHufyK/4KcfPsiRFNmOkYU7oK+ui/HkQKZkN0x/zTPQ6HDuFk7+
         +WyMfSYgt4y85fBKqLJ35BFKrNbu3ho2tJcPyeXb/DD0G/Rb7DdG1b09SICIJ/rb13rB
         h7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWwTq3jHgl0vF+73+HcJrJHO5r6wPiuEt3hWYFmGy1s=;
        b=YENSmNNwKh+pR5KPb76MJPfJhp0GVYFLKPvAgoOOOS7TSvBtVvLl3WIMVTtH9/U/i5
         5IDXB9ydxt+BfptyYhz2QZ2ifZMOH1poVDf6mokduLeaB73YILy4qiCgJMdMS2aI+BPB
         yKuG41ZK0STIUzSiaQFgMOENKFl7skXqo5LbZVyjaCR0FJmtPwRVW1iPyjT36XAG3ZMa
         CO/edd/4UakfrCHwDluP9NlzA3w7pgQL+3rZ84xEt6S0aFqC7kJjPHMzk/Wlb2OoYcRc
         cyCxEsg5opjEfBWZdb7g7qk6Em4g17eeiUv0otAmICO4T/HqzbPUB+wklqSbN2IlzKrr
         GphA==
X-Gm-Message-State: AGi0PuY6jVUN306kf5UzMM+MVOPpH8aig39+AOc1521dWk9nTlYm2OwZ
        KX0qOIq4tSlKBmqI2GZ2fkOzyzNHqm7nmhUFDKuyAQ==
X-Google-Smtp-Source: APiQypK1UlkumqiTdJM/8YlLN6wYa3E2QGBvtJ2jz2DQhm09vLS24dPjTwAN95MP173PKwYSE1aF5bp/sM3ZgZd+E8w=
X-Received: by 2002:ab0:5ca:: with SMTP id e68mr886565uae.19.1588925557511;
 Fri, 08 May 2020 01:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org> <1588775643-18037-2-git-send-email-vbadigan@codeaurora.org>
In-Reply-To: <1588775643-18037-2-git-send-email-vbadigan@codeaurora.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 8 May 2020 10:12:01 +0200
Message-ID: <CAPDyKFpon+ojJgj-CZ5rSiPR=EOA-3DBfN=28zkVjNXUVytZzA@mail.gmail.com>
Subject: Re: [PATCH V1 1/2] mmc: core: Check request type before completing
 the request
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Baolin Wang <baolin.wang@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 May 2020 at 16:34, Veerabhadrarao Badiganti
<vbadigan@codeaurora.org> wrote:
>
> In the request completion path with CQE, request type is being checked
> after the request is getting completed. This is resulting in returning
> the wrong request type and leading to the IO hang issue.
>
> ASYNC request type is getting returned for DCMD type requests.
> Because of this mismatch, mq->cqe_busy flag is never getting cleared
> and the driver is not invoking blk_mq_hw_run_queue. So requests are not
> getting dispatched to the LLD from the block layer.
>
> All these eventually leading to IO hang issues.
> So, get the request type before completing the request.
>
> Cc: <stable@vger.kernel.org> # v4.19+
> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

Applied for fixes, and by updating the tags that were provided by
Adrian, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 8499b56..c5367e2 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -1370,6 +1370,7 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
>         struct mmc_request *mrq = &mqrq->brq.mrq;
>         struct request_queue *q = req->q;
>         struct mmc_host *host = mq->card->host;
> +       enum mmc_issue_type issue_type = mmc_issue_type(mq, req);
>         unsigned long flags;
>         bool put_card;
>         int err;
> @@ -1399,7 +1400,7 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
>
>         spin_lock_irqsave(&mq->lock, flags);
>
> -       mq->in_flight[mmc_issue_type(mq, req)] -= 1;
> +       mq->in_flight[issue_type] -= 1;
>
>         put_card = (mmc_tot_in_flight(mq) == 0);
>
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
