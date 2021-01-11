Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95752F1F88
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbhAKTcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390834AbhAKTcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 14:32:19 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959F4C061795;
        Mon, 11 Jan 2021 11:31:38 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m25so1165931lfc.11;
        Mon, 11 Jan 2021 11:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6U2KagvKGBYbazGvRLBQUQ5ZhQBgacU+6DJEDT+njvQ=;
        b=p4Qmg+C0rj9DA/1P5y2fDZorr6nQSgwQzxxSTH1ZrN8Bov5iXW6/ncgbEEN0JiqngK
         DCegRWzU7mVc3ao9Gqnv5fcseHriELTCB7fbj6GUPLcQqS5OgcNSfKHWxFq/O6SXhlQn
         EtTLOzNfdWXA0UlYT09iEp2Qd7rycPVRr/4gi2YGXJptXUiOp3f05p5dg4tCFYLyPpNg
         kmlTmd7rG2on7Qe2OggkCgbkWwtsAr2D3bMOZBSto9CNAPZxQaRbRooc6k6il/rQAEJj
         Gg0ncR00Ii1pYhSdTrf/5jFuoNbvaOINpIoypHbu3dph6q6b97EwhWP1Yu+Cf1HcfnRc
         neew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6U2KagvKGBYbazGvRLBQUQ5ZhQBgacU+6DJEDT+njvQ=;
        b=MKq9yRlgEAgbT31k1Y6szTPuOjpGgj99Pd3EctDNpb0Hg7my5yGFY3SCJTIT+tED8k
         8SpVDduFeQiA2u8bb9Yb3wV5kmAq2RyS3dKGzffdg7bnh1bxJj1nb3ZKhR+yvEA92G2J
         NuiKHRhwwAya41LhdH0LKUR+Ej8tcFZxZYKxrbI5tVvM/dTpyUPIEmvD9h4LgBfOOWqf
         cfsBco3hmnlK/akiC27dqFEpHOd6EyUJuXC2dl6lCUMSA/nZqNl82ftJLkCZ2sO/3W9A
         qFve7VCS9vfxWWKIibZpgXiy8A6XliSKVo58g6qLe+FEqOGq+vbdoU25NoJpdlbTgrsb
         bN7A==
X-Gm-Message-State: AOAM5318cymqm6NoTn6HPMzMd8JvMYTZg/gQOodJVRVfxb4UAHYY8fAe
        Z3T0mhDfKstlXyPdCpufqrviI1j0UQs=
X-Google-Smtp-Source: ABdhPJy8kJhkgtzdz4lO3IgYKa1z3DaoNi/iax+nK3nQ8xWGe9OrsGQhlxOVlpkvmdq14mmR57dp1Q==
X-Received: by 2002:a05:6512:3f3:: with SMTP id n19mr468250lfq.586.1610393496909;
        Mon, 11 Jan 2021 11:31:36 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id u8sm74067ljj.1.2021.01.11.11.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 11:31:36 -0800 (PST)
Subject: Re: [PATCH v2] i2c: tegra: Wait for config load atomically while in
 ISR
To:     Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com, wsa@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210111160832.3669873-1-mperttunen@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <a3b6944a-7c1e-54bf-664d-0ee6a6de4deb@gmail.com>
Date:   Mon, 11 Jan 2021 22:31:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20210111160832.3669873-1-mperttunen@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.01.2021 19:08, Mikko Perttunen пишет:
> Upon a communication error, the interrupt handler can call
> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
> unless the current transaction was marked atomic. Fix this by
> making the poll happen atomically if we are in an IRQ.
> 
> This matches the behavior prior to the patch mentioned
> in the Fixes tag.
> 
> Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> v2:
> * Use in_irq() instead of passing a flag from the ISR.
>   Thanks to Dmitry for the suggestion.
> * Update commit message.
> ---
>  drivers/i2c/busses/i2c-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 6f08c0c3238d..0727383f4940 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -533,7 +533,7 @@ static int tegra_i2c_poll_register(struct tegra_i2c_dev *i2c_dev,
>  	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
>  	u32 val;
>  
> -	if (!i2c_dev->atomic_mode)
> +	if (!i2c_dev->atomic_mode && !in_irq())
>  		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
>  						  delay_us, timeout_us);
>  
> 

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
