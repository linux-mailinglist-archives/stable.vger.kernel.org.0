Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C565F7E53
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 21:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJGTwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 15:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJGTwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 15:52:18 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A92108DC9
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 12:52:18 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id a23so5498202pgi.10
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 12:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBuQNx3REr4Ay95QCbgoTuyX4KaRiOz58JSf635GjMM=;
        b=MmuI46n4UX+DpOOW+5QRDzLMdoeRo6FRJesioDmIbrk4K4+xtXZ2qB5iHRW7cStWiZ
         EHvjngUvSOvRQZ/omimSfB+OWOvOZYeqmouk4T2deNuAiBa9k4IUcps828FELfEAiMKl
         nKvmQYpJ0J7x008GV/zBrOqyS5pSTuLujiLBMJ0FtOUsDNEV1rfmFZVvmNii4909Ma1r
         6OtKOh2dg24vnFrylIHPsq+ZuTA9KOriTKUC1Yz+NmAPvyobRvdf/fTjdCMGZj7lHAps
         Kd2LU9vXjc/wzl5PC/t4Z84OnO08qE5Tk8/vpr3+y+U0hbhC1wXG8XYo9LMupN36Q5Ux
         ZrFA==
X-Gm-Message-State: ACrzQf2XF6ui+AMC7klOBc+WV0buVULZKpxQO4GHQT4pjniU9vhYFaUT
        uEDosGAGKgFKdFMinykaKnE=
X-Google-Smtp-Source: AMsMyM49CKArtngA3pH1P8WBPLpPMunKN3OFCbIqHU4FvM1eUPL/r15/5ZEvFKEX/1RIug7woKR03Q==
X-Received: by 2002:aa7:9614:0:b0:562:b07b:ad62 with SMTP id q20-20020aa79614000000b00562b07bad62mr6079354pfg.79.1665172337533;
        Fri, 07 Oct 2022 12:52:17 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b72:b06c:f943:31d5? ([2620:15c:211:201:b72:b06c:f943:31d5])
        by smtp.gmail.com with ESMTPSA id y4-20020aa79424000000b00560cdb3784bsm1986755pfo.60.2022.10.07.12.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 12:52:16 -0700 (PDT)
Message-ID: <e387f65b-da09-cd0b-fa0d-bc7221243c68@acm.org>
Date:   Fri, 7 Oct 2022 12:52:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] compiler_attributes.h: move __compiletime_{error|warning}
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>
References: <20221007193436.906-1-bvanassche@acm.org>
 <Y0CBzgaKnW7SYzem@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y0CBzgaKnW7SYzem@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/22 12:45, Greg KH wrote:
> On Fri, Oct 07, 2022 at 12:34:36PM -0700, Bart Van Assche wrote:
>> From: Nick Desaulniers <ndesaulniers@google.com>
>>
>> commit b83a908498d68fafca931e1276e145b339cac5fb upstream.
> 
> This is already in 5.15, what stable kernel tree(s) is this a backport
> for?

This is for the linux-5.10.y branch.

Thanks,

Bart.
