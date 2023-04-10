Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1FE6DC6F4
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDJM63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 08:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJM62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 08:58:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8CB211E;
        Mon, 10 Apr 2023 05:58:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q2so9466721pll.7;
        Mon, 10 Apr 2023 05:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681131507;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRqvBThVRAzLt2hvr/N5oQIkVDYEQKa0Fh7bmG/pvF8=;
        b=gBDeDejyzBC9/NDw3EaHAxRATRaL2YSA3mEJVRtsiBsNwuvoypOxxK5PbL4C3/P2Hs
         RaabAWnky0aBX1Mbz4wpwxcANZX7XhXP8+q7BL1lPSLAaOcMRW7BpIbJcGeisbWGoEhw
         zwYhdMiwCDtYe5WOoQEt31KUrw5YaJm8rMOIhH/XpyFFPtY1oMM16A4XEkEliv1gaohu
         lE8cY98AxK9caETCW/YpoIH0ZEOMwnwTPoSNdSrfi1aqlSGK1OLgsccL3WSVvtVzv5q/
         TvBO4881WlzkGm2RId1Aflh0BZcFu4KOXm/7hzFtbPRYbm1jojuMOAiqRxGypUbYoR8A
         9rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681131507;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nRqvBThVRAzLt2hvr/N5oQIkVDYEQKa0Fh7bmG/pvF8=;
        b=4OIVbWPRSYjBWDUqQxdrcwzFiW5Axv2caGq86fxAeH+8VpN6aPq+IFzGnpR/FqF9EA
         Rl7VHC2RzY4swIKF2MTxOVsdYIKibwU3FWwxjxec8KVlQdhksLIKwCsTVBQT8+m2y3fC
         yVx6Tplb7XpqK1pafm6xvSk7OoKAVNWVy7j+FBfFfLPaEa2hdnMXfber1SPk77Jd/FMv
         vuYBgPfa0yzp3Pgj11dYgc7yvLibkIPDB/Yfueq3FzMME/Rgg8CGY3QomoALzfwL42gg
         viK3Vo+m0Y+2/E0tjqevE8qcY8zg3+wjBNZIrA2rB7rbaQXR0Ca3m4dQpoCBCu64uWpD
         HZxw==
X-Gm-Message-State: AAQBX9fN8GD8HmDKB+ZzBZT2AuXQyfWT6xLKp5ojd/BL0JbY+omxYxDh
        +Jou9BTa29+TPBCdg/8afbk=
X-Google-Smtp-Source: AKy350YQX5KiRTfJz9GnSf5BtGpMTUVF8Nli0s8qXztaiy4KzpbLaCG1N8SSJRfD29E5CCScb0ZJ5Q==
X-Received: by 2002:a05:6a20:3423:b0:d9:ecba:b9fc with SMTP id i35-20020a056a20342300b000d9ecbab9fcmr7340695pzd.54.1681131506298;
        Mon, 10 Apr 2023 05:58:26 -0700 (PDT)
Received: from [10.200.10.217] ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id d16-20020aa78690000000b00639c1fc8766sm1153424pfo.212.2023.04.10.05.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 05:58:25 -0700 (PDT)
Message-ID: <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
Date:   Mon, 10 Apr 2023 20:58:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 2/2] maple_tree: Fix a potential memory leak, OOB access,
 or other unpredictable bug
To:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        stable@vger.kernel.org
References: <20230407040718.99064-1-zhangpeng.00@bytedance.com>
 <20230407040718.99064-2-zhangpeng.00@bytedance.com>
 <20230410124331.kijufkik2qlxoxjz@revolver>
From:   Peng Zhang <perlyzhang@gmail.com>
In-Reply-To: <20230410124331.kijufkik2qlxoxjz@revolver>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2023/4/10 20:43, Liam R. Howlett 写道:
> * Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
>> In mas_alloc_nodes(), there is such a piece of code:
>> while (requested) {
>> 	...
>> 	node->node_count = 0;
>> 	...
>> }
> You don't need to quote code in your commit message since it is
> available in the change log or in the file itself.
Ok, I will change it in the next version.
>
>> "node->node_count = 0" means to initialize the node_count field of the
>> new node, but the node may not be a new node. It may be a node that
>> existed before and node_count has a value, setting it to 0 will cause a
>> memory leak. At this time, mas->alloc->total will be greater than the
>> actual number of nodes in the linked list, which may cause many other
>> errors. For example, out-of-bounds access in mas_pop_node(), and
>> mas_pop_node() may return addresses that should not be used.
>> Fix it by initializing node_count only for new nodes.
>>
>> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
>> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   lib/maple_tree.c | 16 ++++------------
>>   1 file changed, 4 insertions(+), 12 deletions(-)
>>
>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>> index 65fd861b30e1..9e25b3215803 100644
>> --- a/lib/maple_tree.c
>> +++ b/lib/maple_tree.c
>> @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>>   	node = mas->alloc;
>>   	node->request_count = 0;
>>   	while (requested) {
>> -		max_req = MAPLE_ALLOC_SLOTS;
>> -		if (node->node_count) {
>> -			unsigned int offset = node->node_count;
>> -
>> -			slots = (void **)&node->slot[offset];
>> -			max_req -= offset;
>> -		} else {
>> -			slots = (void **)&node->slot;
>> -		}
>> -
>> +		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
>> +		slots = (void **)&node->slot[node->node_count];
> Thanks, this is much cleaner.
>
>>   		max_req = min(requested, max_req);
>>   		count = mt_alloc_bulk(gfp, max_req, slots);
>>   		if (!count)
>>   			goto nomem_bulk;
>>   
>> +		if (node->node_count == 0)
>> +			node->slot[0]->node_count = 0;
>>   		node->node_count += count;
>>   		allocated += count;
>>   		node = node->slot[0];
>> -		node->node_count = 0;
>> -		node->request_count = 0;
> Why are we not clearing request_count anymore?
Because the node pointed to by the variable "node"
must not be the head node of the linked list at
this time, we only need to maintain the information
of the head node.
>
>>   		requested -= count;
>>   	}
>>   	mas->alloc->total = allocated;
>> -- 
>> 2.20.1
>>
