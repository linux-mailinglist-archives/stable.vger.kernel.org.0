Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26724D537E
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 22:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343908AbiCJVPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 16:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245511AbiCJVPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 16:15:42 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71DF1587A2
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:14:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n2so6003910plf.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tfG6NA9TljjE9JUfuXGD7jLzBJpRfBuiNXsgSuyR/Ok=;
        b=F4KUSzFWvkikwF0SvA/qDB9X8w9nBp7jy5EUYNotdSB/O1cQAaoC2n7smN/xhKFsVq
         lgRimNXnnzTKQgAh36ozzlolX/oy5+CPtGHsIUTg84w2InqGzLK4Aewua7oqCR5ljjSf
         BZof0xl6VEUrIKuVpByM72uCjVnd8VV3pA00cXVhILzl0ag0zPJEoCkLV8tZtydKA34V
         R+L2NX89mBNmGhMrs2BO6fwlAQxlBJDvHsFhqSmwHZziLvEhypYWJ9qmSeyBDNa+bJsA
         VtYSmUdIqKB+Nn9zeXP2Go85oPJ/3satZnDkEMcgLKXfYwbxJ2IBewpYwktqTmKcv+MX
         4oSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tfG6NA9TljjE9JUfuXGD7jLzBJpRfBuiNXsgSuyR/Ok=;
        b=jiZsmW+zdJq3XYoT8Co2yxz53KioLzby77R3lJG0AZ6IkvZzX1HNf9vlGMyZDMspsd
         1vnhr4+2AVsfXiKBu5q7OGPA0/Ho5SoqY9wbOuTzOrtm39Mux3kVPE6OJngceq01+UKn
         Oe6kpbsV1CP1sqaf1sbNJXete6A4KsP5jUH9WL7ljgZCkN8X60iHIZ8VWaYIw4mYJNwK
         VgVPBkJLdZbRXrFWU1naBLKW83my/s4Hf919XTiaCkdLtdGSa7Kvv2Fe9PSrsFXY10cS
         E5ZR52Q1ydi6xCFE31BpEbGJiJjpf8hmYwiPCp61Fs41q2QFm1Avi2ozpKAOulqB9cmP
         ZeYg==
X-Gm-Message-State: AOAM533rC592g3+Ah1L50UODQniQXkvV9PJf0M47hmeM47BcCmjo+ZvZ
        4MihVtbcpx/sMI0ukLAsKivERw==
X-Google-Smtp-Source: ABdhPJxNTQEa85dZgL83y3cDavoYSwPfMnwV9Ro4rKSYMoqy3OfHuHslGhqQqYFrXZyWOjFBLbBzEQ==
X-Received: by 2002:a17:90b:4ac1:b0:1bf:6d51:1ad9 with SMTP id mh1-20020a17090b4ac100b001bf6d511ad9mr18019630pjb.199.1646946880235;
        Thu, 10 Mar 2022 13:14:40 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004f6ff260c9dsm8453837pfk.154.2022.03.10.13.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 13:14:39 -0800 (PST)
Message-ID: <d49428d1-109e-6778-6da0-3bcdb61d7dc4@linaro.org>
Date:   Thu, 10 Mar 2022 13:14:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
 <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
 <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
 <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org>
 <8fdab42f-171f-53d7-8e0e-b29161c0e3e2@linaro.org>
 <CA+FuTSeAL7TsdW4t7=G91n3JLuYehUCnDGH4_rHS=vjm1-Nv9Q@mail.gmail.com>
 <c7608cf0-fda2-1aa6-b0c1-3d4e0b5cad0e@linaro.org>
 <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 09:32, Willem de Bruijn wrote:
> On Thu, Mar 10, 2022 at 11:06 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>>
>> On 3/10/22 06:39, Willem de Bruijn wrote:
>>> On Wed, Mar 9, 2022 at 4:37 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>>>>
>>>> On 3/8/22 21:01, David Ahern wrote:
>>>>> On 3/8/22 12:46 PM, Tadeusz Struk wrote:
>>>>>> That fails in the same way:
>>>>>>
>>>>>> skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575
>>>>>> head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0
>>>>>> dev:<NULL>
>>>>>> ------------[ cut here ]------------
>>>>>> kernel BUG at net/core/skbuff.c:113!
>>>>>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>>>>>> CPU: 0 PID: 1852 Comm: repro Not tainted
>>>>>> 5.17.0-rc7-00020-gea4424be1688-dirty #19
>>>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
>>>>>> RIP: 0010:skb_panic+0x173/0x175
>>>>>>
>>>>>> I'm not sure how it supposed to help since it doesn't change the
>>>>>> alloclen at all.
>>>>>
>>>>> alloclen is a function of fraglen and fraglen is a function of datalen.
>>>>
>>>> Ok, but in this case it doesn't affect the alloclen and it still fails.
>>>
>>> This is some kind of non-standard packet that is being constructed. Do
>>> we understand how it is different?
>>>
>>> The .syz reproducer is generally a bit more readable than the .c
>>> equivalent. Though not as much as an strace of the binary, if you
>>> can share that.
>>>
>>> r0 = socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
>>> connect$inet6(r0, &(0x7f0000000040)={0xa, 0x0, 0x0, @dev, 0x6}, 0x1c)
>>> setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36,
>>> &(0x7f0000000100)=ANY=[@ANYBLOB="52b3"], 0x5a0)
>>> sendmmsg$inet(r0, &(0x7f00000002c0)=[{{0x0, 0x0,
>>> &(0x7f0000000000)=[{&(0x7f00000000c0)="1d2d", 0xfa5f}], 0x1}}], 0x1,
>>> 0xfe80)
>>
>> Here it is:
>> https://termbin.com/krtr
>> It won't be of much help, I'm afraid, as the offending sendmmsg()
>> call isn't fully printed.
> 
> Thanks. It does offer some hints on the other two syscalls:
> 
> [pid   644] connect(3, {sa_family=AF_INET6, sin6_port=htons(0),
> sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "fe80::", &sin6_addr),
> sin6_scope_id=if_nametoindex("tunl0")}, 28) = 0
> [pid   644] setsockopt(3, SOL_IPV6, IPV6_HOPOPTS,
> "R\263\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 1440) = 0
> 
> IPV6_HOPOPTS is ns_capable CAP_NET_RAW.
> 
> So this adds 1440 bytes to opt_nflen, which is included in
> fragheaderlen, causing that to be exactly mtu. This means that the
> payload can never be sent, as each fragment header eats up the entire
> mtu? This is without any transport headers that would only be part of
> the first fragment (which go into opt_flen).
> 
> If you can maybe catch the error before the skb_put and just return
> EINVAL, we might see whether sendmmsg is relevant or a simple send
> would be equivalent. (not super important, that appears unrelated.)

Do you mean something like this:
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 622345af323e..6d45112322a0 100644
@@ -1656,6 +1649,16 @@ static int __ip6_append_data(struct sock *sk,
                         skb->protocol = htons(ETH_P_IPV6);
                         skb->ip_summed = csummode;
                         skb->csum = 0;
+
+                       /*
+                        *      Check if there is still room for the payload
+                        */
+                       if (fragheaderlen >= mtu) {
+                               err = -EMSGSIZE;
+                               kfree_skb(skb);
+                               goto error;
+                       }
+
                         /* reserve for fragmentation and ipsec header */
                         skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
                                     dst_exthdrlen);


That works as well.
-- 
Thanks,
Tadeusz
