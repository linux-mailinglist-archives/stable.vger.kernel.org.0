Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A420540482
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbiFGRPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345450AbiFGRPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:15:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2CC10277E
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 10:15:34 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y19so36536186ejq.6
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PDWg3UHkCjLROtwQj1Oq7XtgJytN19UuedYPqE55MPM=;
        b=xt3dz4+UZeTfxDm22DYwo949d3Wdc7Me+Q+GFyZ0A17oVos1owEtm2ujMXK2hC381P
         RMyw5i5Loyjt/4jzeJHgfUXwThkDdcEPtpDcPJWdIUitVF5YVaKwTwc3p/WIZ0z0rqXr
         6YnGwX+ZYOQXHgIOaVoepM8HIpT2YiGqLyGPt9IcPf8C+4c/WRX4xdBWlFv9HE3y3Khe
         P2o8KRxXtt41Ma9lVr4YqlNAtQMdoLZlVMNurpmjeSPmqPwpuNI7fexQqf4PiE4uGrFb
         L7PySl3poU0wy4NwgzRpyuHuIl5zXpwB12qHdSRAqJCd2DNYUw1pxZ82jnON5c/pX1N4
         XjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PDWg3UHkCjLROtwQj1Oq7XtgJytN19UuedYPqE55MPM=;
        b=2zkbM6/EJiP0r3r8srOVKslky5330s8dmWqPmB663dm5gqiFStTtKUnm3bh+e18Lka
         WHUHLdMkKyWyuUx/rLUIX4yU3Ob4v6Idm5eL+nDqESri0/VOI7BuC3My1Axk0hbMO9MO
         JkvKQFmnlri+W0NFRM75xOMSzOekcML70nUE8aY+1UT8Eu8ascyn5jki9bPPF9gaY8tR
         qdG8ehQ1vxMxiWX5iVru4Xz8ULGBWJLZV4rTn2Grq4vX8r1VTcW/uLbjcDNEWCDPkDMe
         BuXudM+zZrcSDhOqBzQWMrPoLMOTbYQ36uKLiahuaRQhU/orkZBt8nUP3ie5Yi6bf06N
         YiCQ==
X-Gm-Message-State: AOAM532cvOlNs0pPm9tE4GcSwPXOUSZtU1eO5VL3WI5YZGEHWZU6qaJc
        UsunAExKpcsmI+2c4C0ZL09pzQ==
X-Google-Smtp-Source: ABdhPJz4dSfM8z/+nBrTY8flquXOJXkXaF/FAFA5ReQSH5TvzkKVFABlF9yzovjXVbs28lUqFKcl7g==
X-Received: by 2002:a17:906:53ca:b0:6fe:ae32:e01e with SMTP id p10-20020a17090653ca00b006feae32e01emr27758308ejo.455.1654622133250;
        Tue, 07 Jun 2022 10:15:33 -0700 (PDT)
Received: from [192.168.0.186] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ge16-20020a170907909000b00709e786c7b2sm7023557ejb.213.2022.06.07.10.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 10:15:32 -0700 (PDT)
Message-ID: <83fd531e-9135-37b5-e92a-76b6c949587e@linaro.org>
Date:   Tue, 7 Jun 2022 19:15:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net v3 2/3] nfc: st21nfca: fix memory leaks in
 EVT_TRANSACTION handling
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        martin.faltesek@gmail.com, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, sameo@linux.intel.com, wklin@google.com,
        theflamefire89@gmail.com, stable@vger.kernel.org
References: <20220607025729.1673212-1-mfaltesek@google.com>
 <20220607025729.1673212-3-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220607025729.1673212-3-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/06/2022 04:57, Martin Faltesek wrote:
> Error paths do not free previously allocated memory. Add devm_kfree() to
> those failure paths.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Standard disclaimer:
---------
Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submitting-patches.rst#L540

If a tag was not added on purpose, please state why and what changed.
---------

So you dropped all my review tags?

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof
