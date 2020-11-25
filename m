Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1C52C3F9A
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 13:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgKYMKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 07:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKYMKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 07:10:11 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3390CC0613D4;
        Wed, 25 Nov 2020 04:10:11 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id 142so2008307ljj.10;
        Wed, 25 Nov 2020 04:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JtvEqlP2kM/xfhneQTjDnybMpz+ouPY74TpkVqPdwg0=;
        b=PQYAAtJkKjaS1TxwaJUvBf/VGyfTHk3L5ew5pftTrsgtOGavvV448+bwwpv8yl+0MU
         BTaPjAoOuFQlwyBfi6iTs5r1Blf+nfH3fX/MnZA0t63K95TzqmcB+HRVdyvexvVaEZTF
         ep+/QZ1wnNn8yCgZKM3oSVSFpslH6u3UQPxnGc5M4bkntdgbkVO/tdk7NrI6DugToY/j
         WWuAeKjfDXrcorjq6UEisv04A1NIi0cPDDaF9o9qRWlaHY//saDCL1AIxFaxFCFvaYSE
         HtmDxj5QHDulrziTy+XFRUhq/lKVRpNJXISDsgGzTPDjnb+34mgNlMZ7gRP36KhLmPYS
         /kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JtvEqlP2kM/xfhneQTjDnybMpz+ouPY74TpkVqPdwg0=;
        b=WUJMnIJj6Du8MJCycZBx+9+X2piAvv0ccxuSNkmWmdwk3bHtJZL1u4956hW411H+zi
         kvcabaF/872ZC3rFY0uZ9NGhjCrJn3HpapRr0utbriRUK4MlhwNRmIwUe5Yj8wt3vMY7
         LHhB2HafIrs/dHlL91MXPMJ5zBJsB6XkqTPQJ4AyKn+npkO5DeUo5eUq920G5t1mQIIw
         UNyxX/+K2tQUbQwTqqqvJTgGEs5S6OsGqDDT1LaOiiP5suQYxWuxQC+4+y30asOxgLks
         3qQnyqdhT5601GkGwqbOrCIhjQ+FdQY4Y9RyYyWS5xWsI0anSHoAhvi+TAN2xoua6Rw1
         xKKg==
X-Gm-Message-State: AOAM531f+Y75WmZpExAwBOZNrSd9LOQo0WSvVVDgi5dtDvYKJ4+QN14m
        5ypi+XrYiicE2TUhZwA85BCXrRS5NjcGCg==
X-Google-Smtp-Source: ABdhPJwYanW0E/yCz9bOI5/61jyGaYAqt/+JNu83mKX9tmwY8RcYWlfbtt+BYSpJRKCYNiq0bzuxBg==
X-Received: by 2002:a2e:8011:: with SMTP id j17mr910111ljg.325.1606306209421;
        Wed, 25 Nov 2020 04:10:09 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:46d0:9159:e29e:dcff:ec45:a8c0? ([2a00:1fa0:46d0:9159:e29e:dcff:ec45:a8c0])
        by smtp.gmail.com with ESMTPSA id p19sm208403lfh.82.2020.11.25.04.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 04:10:08 -0800 (PST)
Subject: Re: [PATCH 5/5] memory: renesas-rpc-if: Fix a reference leak in
 rpcif_probe()
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
References: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201124112552.26377-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <27229829-5a21-e0e6-86a7-0bfc6ed646e5@gmail.com>
Date:   Wed, 25 Nov 2020 15:10:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124112552.26377-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/20 2:25 PM, Lad Prabhakar wrote:

> Release the node reference by calling of_node_put(flash) in the probe.

   Sorry about missing this...

> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
