Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8E4DD9FC
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiCRMyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiCRMym (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:54:42 -0400
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E862F3281;
        Fri, 18 Mar 2022 05:53:23 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id o6so11193988ljp.3;
        Fri, 18 Mar 2022 05:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=azzcjd1OIWakEOc8UERpptRP6fFvybBF/IXdEJwOYok=;
        b=eoLQiLfu1TPsEdwzkBZInXc+LkvonGx+mECDutWQrmYDixW+5RkFKB9pQNcgxnL+kn
         VQUtBjhlrwlGnwTkNeVPKQOEFSNWlZ2QvRHv8p+y/tffa7k86+7ogykKSvsKl/4+QEWB
         6YDQ8vq8u0FAxPucG9v2d4oLmFF2tvSOMTtGN4Ci/6A9xlkyIRv1ofYn622BQt+1VAYP
         JEcfnjCka2APuvAXEnhxV0NcoFDCRBo0lLydPa4dq/ZWrLMydQQ1q86L0nbx6767N6vM
         hIgTuMWwvPmKErimryRDIzZ++P/BE+82J16igvg6zBxbeSzyyhcDfXx4aaMot9++Mhk+
         wOcA==
X-Gm-Message-State: AOAM5326n2kXNePtmqRlkDoIAjJaJ2yQIAOL3ct/T+r4bf6wp+U4XDjD
        2vCSx2T20Pfa+Yilk8IzTXzRYbEX9Lk=
X-Google-Smtp-Source: ABdhPJz3hHh22dAgdUP2vOsOvXNZF84TeD+dtedtzAccxko5hO5CfDbqZPj7PZRVU02lw9zujdnxYA==
X-Received: by 2002:a2e:b536:0:b0:247:f015:ad57 with SMTP id z22-20020a2eb536000000b00247f015ad57mr6063675ljm.257.1647608001421;
        Fri, 18 Mar 2022 05:53:21 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id m21-20020a197115000000b0044895f0608asm840021lfc.37.2022.03.18.05.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 05:53:20 -0700 (PDT)
Message-ID: <d0d0c0e1-47c7-0177-1b97-61befe3f1327@kernel.org>
Date:   Fri, 18 Mar 2022 13:53:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] memory: renesas-rpc-if: fix platform-device leak in error
 path
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <20220303180632.3194-1-johan@kernel.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220303180632.3194-1-johan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/03/2022 19:06, Johan Hovold wrote:
> Make sure to free the flash platform device in the event that
> registration fails during probe.
> 
> Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
> Cc: stable@vger.kernel.org      # 5.8
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/memory/renesas-rpc-if.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

It's too late for upcoming cycle, so I will pick it up after the merge
window.


Best regards,
Krzysztof
