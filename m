Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AD9531EFD
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiEWW6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiEWW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:58:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9958AEE0E
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:58:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l14so15278872pjk.2
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wHq+sg+OE/u6XNRtcECxJ1AD+aYhdnsIcvM4tS+oY0A=;
        b=HH9lC4SqxtFMayytf5nJNoi4ila54ZKzSRCTL24yAn7OFNVoa6phG8fDQ9eVmPE+J9
         sSjSrb5luDqAww9yG6enkpIHjWsORVNOeKWYESsgej5xUMMVlaOtQ42w1QpX6SZgB76+
         f48i1aiWOGhAg8hUEB+nnSa9lOIyEHgolz5wZ/hVIDAQD1h8ZLzSQlXXZPSbonXx5pel
         Uy1kP8o6c79hPwhcGwNT+TL2po3DHtqzRUk9nEbqh5r5wWA6Dp/m+4POSgOSxtkAVb48
         SiXaQTFWfJDrSx8wqzELL0y+fb8gQU/uAP6mW5B3Adeo/usrxgXQXeb2j0uJxO/adZb/
         54nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wHq+sg+OE/u6XNRtcECxJ1AD+aYhdnsIcvM4tS+oY0A=;
        b=6ZwSNJJuDT0x6GOMY27KUXw2jqrc2Tr6Nc+Y6mCqwGJRnN5ezvOP/dFRH2/DkWEPWO
         aBMookQhOzR9UDEANRKkojLmJAze/4DPUKpR/iwA7FbGQrranhgW+GO0qCxr9bgdOpFo
         b4YxXKBt+5J56v+VXC84BGE+afPCk1I37GGWSnKGYLfOddz3Ms5CiwvSGsVs9pa7UB7V
         IiM5VSF5Ikh+Uggg0Juf2XiOhTDns/Wkk66PagKLL6WeLbnp8NlR1ScQMMQtFEyJX3AC
         0lt0FxubK7hDe2XcVYqyGaOtzKCscFFfcB2EVLqLOtESGD2xrgKFVBHVQ9eIlhtKfEqk
         +EFA==
X-Gm-Message-State: AOAM530Gcvr3j49DDXn4EyXLsyYfk3eF1L19E0mYe1jRMyHP1cIlRk6K
        dpv1J7P3AY48+w4EohYGzjkMkA==
X-Google-Smtp-Source: ABdhPJyC8aRGUUkFw4ktiNZ/AjvdeMkpEncOwD2eaAk791J5zOV+npFs6nxjPMcxl+jFBkUObiG/XQ==
X-Received: by 2002:a17:90a:e612:b0:1df:4e85:1ad2 with SMTP id j18-20020a17090ae61200b001df4e851ad2mr1321861pjy.242.1653346713120;
        Mon, 23 May 2022 15:58:33 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id jh5-20020a170903328500b00161527e1d9fsm5645340plb.294.2022.05.23.15.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 15:58:32 -0700 (PDT)
Message-ID: <ab35f4fb-b058-8aa7-71f2-fab8d4a5cf26@linaro.org>
Date:   Mon, 23 May 2022 15:58:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <20220517180420.87954-1-tadeusz.struk@linaro.org>
 <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
 <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 15:47, Andrii Nakryiko wrote:
>> Hi Andrii,
>> Do you have any more feedback? Does it look better to you now?
> Hi, this is on my TODO list, but I need a bit more focused time to
> think all this through and I haven't managed to get it in last week.
> I'm worried about the percpu_ref_is_zero(&desc->bpf.refcnt) portion
> and whether it can cause some skew in the calculated array index, I
> need to look at this a bit more in depth. Sorry for the delay.

That's fine. take your time and let me know if there is anything else
to change/improve. FWIW I tested it extensively with the syzbot repro
and the issue doesn't trigger anymore.

-- 
Thanks,
Tadeusz
