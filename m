Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B603F64E884
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 10:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiLPJOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 04:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiLPJN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 04:13:58 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A933540447
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 01:13:51 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id q6so2498015lfm.10
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 01:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+C9KQuE+R0TNgeqhyRteMhPhVfgAuZdXYjuNY9w0Tg=;
        b=I+tdbpPxB/xvcyDKQWbXrSlBwJFiggn5RH93nh7LJC69E9VRg3TN79aUmK64w7HytB
         7DKddM8IOSyd+AvBcVNpV0fVZCMYAvNKjD8HDaJXeThGtQ/M/+f7zmgQW5tKg0ezOhen
         4FY7A2WsN+OfnsHPB4Dd6L/KgHIgezVbQC9Lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+C9KQuE+R0TNgeqhyRteMhPhVfgAuZdXYjuNY9w0Tg=;
        b=ltqVvVQRU4NyqM2vCYa6V77a821YDUlCquRiJr7BpFjSvO831GJWFHGdWpGDvILVOO
         AMLUsOSPJJQBhYJrKzB3HZWHytZsu2bbyX2kdjjMzHOgO2EY7EN/zDZnahoNmdioY2Cy
         qVEOq/egVN+OvGWzeqANf/QXGBJWMv30mWiEcHWjSx/QKlkslSQIZlfUr4bkZOsUs4BD
         3/RTkIEqo3f10mNEfzOwji7jMinzYHbDDU1icoLdnB75PJb7qcRk5n2P8K0QXlAatq9G
         6TDM8Hlcmv/ZNca/wGLhPPYK6106T1cR6HyGkJ/d2638mrc55JvXRC1LKx3PdX5wFGtD
         k57Q==
X-Gm-Message-State: AFqh2kpoRp3J8KAWyPTzMOn5OKqkz3TAf10s930uMGpKHUC4AAGOkBOH
        kDGULZo8WSZiQow/XjyT/ezQuw==
X-Google-Smtp-Source: AMrXdXuRZZig3Xer3I8P5A83jMcDJtsPri5m5838O/2KQ/DItsAc0ECL1f5FuDXjzkqXh9VzhdWPGA==
X-Received: by 2002:a05:6512:3d2a:b0:4ba:555f:4795 with SMTP id d42-20020a0565123d2a00b004ba555f4795mr3668103lfv.25.1671182030017;
        Fri, 16 Dec 2022 01:13:50 -0800 (PST)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a23-20020a056512201700b004b094730074sm164709lfb.267.2022.12.16.01.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 01:13:49 -0800 (PST)
Message-ID: <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>
Date:   Fri, 16 Dec 2022 10:13:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 11/14] net: fec: dont reset irq coalesce settings to
 defaults on "ip link up"
Content-Language: en-US, da
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20221215172906.338769943@linuxfoundation.org>
 <20221215172907.210669704@linuxfoundation.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <20221215172907.210669704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/12/2022 19.10, Greg Kroah-Hartman wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]

You should not take this unless you at the same time also take

commit 7e6303567ce3ca506e4a2704e4baa86f1d8bde02
Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Mon Dec 5 21:46:04 2022 +0100

    net: fec: properly guard irq coalesce setup

which

    Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to
defaults on "ip link up")

The same of course applies to the 6.0.y series.

I don't know if your scripts already do this and it just somehow failed
here, but it would probably be a good idea to always check if there is
already a Fixes for a commit that gets chosen for -stable.

Rasmus
