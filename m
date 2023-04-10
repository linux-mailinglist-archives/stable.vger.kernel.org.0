Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E626DC741
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 15:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDJN2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 09:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjDJN2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 09:28:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF9A4C09;
        Mon, 10 Apr 2023 06:28:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h24so4789440plr.1;
        Mon, 10 Apr 2023 06:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681133295;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPdI8YYBvkU0rtwv6q9PYIJ+2TW8RoJU3kOJcZfGvD8=;
        b=dCYCTrkbfniUH5qxoZuUGOd1uSGwAzLSXRrTqGZG4KRFnYfeTw9tIG2rD9fAw2HbXb
         fw2/JoEDOdSqjMEnj6a3sVC+x3ZJmDH/qZraTrAYP5DgEgVMuN/aCn+oEw1AgG4xXqAn
         zucfS0i1P4BqASVh5XZrNbXSua/7mkAun0Mmc9VwMJsDPe0iEtSAtfUl7JODFs7SXQL3
         jVr2htLWRnPplwYvDYw+0tzKUH5bEp0wFEPw9NJkqBsYHsEaC0z19u94BBLXlu1jhlFq
         6NZCvpbiHYIrOOk1MWfb7xGH8FVDJq2CJOu370RdMz4HhdJuGC1/2bTtKhFMojpYWmxD
         XW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681133295;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vPdI8YYBvkU0rtwv6q9PYIJ+2TW8RoJU3kOJcZfGvD8=;
        b=jVojp9MU1xF6li7PFh2orTa9DTVypcTgOZbNcKvwMafcv8ykAEqF6CBtaD6I6CUULq
         yfCp7iSLcpOiuNEEONUjKXjS/+wA0OOtmaZS4j4zP8AR4Zt9NLx3b4JhfM73AXnU34Yr
         SFLPmRBcS8AkDo1CIAYlf24dtfu779hH2utpd0ELlHcdIbHgceP6lFasWJGtnMyfkDIG
         hY13EzyuQwmM9ANM5S+T8OYKVJkI+irpNOzx3FpPH+Y1Bow/pW539gVClWsggLsDSCRJ
         r2AbISFr3Rg3BH+DXn2Pjzae40PFEFrxsEivc7QYB3MtzCAfBALWoj7K17DxSxp7od/O
         tnxw==
X-Gm-Message-State: AAQBX9ffbcLB3A50yYp6yimH2HPjTVwXB2fm+aQzTjOdGiRdiJHAu89m
        0rERpYyL7dr0hN1OAqR2b+o=
X-Google-Smtp-Source: AKy350YlZemfIfaB7aH5HZnQXUj9bbnYBvWCn2tCSEB4gEWt8gAd9iSvKhVCW+/MBPr8yFp13JvjVQ==
X-Received: by 2002:a17:902:c40b:b0:1a1:8fd4:251 with SMTP id k11-20020a170902c40b00b001a18fd40251mr15282780plk.55.1681133295290;
        Mon, 10 Apr 2023 06:28:15 -0700 (PDT)
Received: from [10.200.10.217] ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id m12-20020a1709026bcc00b001a183ade911sm7748976plt.56.2023.04.10.06.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 06:28:14 -0700 (PDT)
Message-ID: <c9a5bcce-7e1b-81cd-b85f-0e9128024d6b@gmail.com>
Date:   Mon, 10 Apr 2023 21:28:10 +0800
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
 <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
 <20230410131258.txkiqa5eudgsrmht@revolver>
From:   Peng Zhang <perlyzhang@gmail.com>
In-Reply-To: <20230410131258.txkiqa5eudgsrmht@revolver>
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


在 2023/4/10 21:12, Liam R. Howlett 写道:
> * Peng Zhang <perlyzhang@gmail.com> [230410 08:58]:
>> 在 2023/4/10 20:43, Liam R. Howlett 写道:
>>> * Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
>>>> In mas_alloc_nodes(), there is such a piece of code:
>>>> while (requested) {
>>>> 	...
>>>> 	node->node_count = 0;
>>>> 	...
>>>> }
>>> You don't need to quote code in your commit message since it is
>>> available in the change log or in the file itself.
>> Ok, I will change it in the next version.
>>>> "node->node_count = 0" means to initialize the node_count field of the
>>>> new node, but the node may not be a new node. It may be a node that
>>>> existed before and node_count has a value, setting it to 0 will cause a
>>>> memory leak. At this time, mas->alloc->total will be greater than the
>>>> actual number of nodes in the linked list, which may cause many other
>>>> errors. For example, out-of-bounds access in mas_pop_node(), and
>>>> mas_pop_node() may return addresses that should not be used.
>>>> Fix it by initializing node_count only for new nodes.
>>>>
>>>> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
>>>> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>>    lib/maple_tree.c | 16 ++++------------
>>>>    1 file changed, 4 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>>>> index 65fd861b30e1..9e25b3215803 100644
>>>> --- a/lib/maple_tree.c
>>>> +++ b/lib/maple_tree.c
>>>> @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>>>>    	node = mas->alloc;
>>>>    	node->request_count = 0;
>>>>    	while (requested) {
>>>> -		max_req = MAPLE_ALLOC_SLOTS;
>>>> -		if (node->node_count) {
>>>> -			unsigned int offset = node->node_count;
>>>> -
>>>> -			slots = (void **)&node->slot[offset];
>>>> -			max_req -= offset;
>>>> -		} else {
>>>> -			slots = (void **)&node->slot;
>>>> -		}
>>>> -
>>>> +		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
>>>> +		slots = (void **)&node->slot[node->node_count];
>>> Thanks, this is much cleaner.
>>>
>>>>    		max_req = min(requested, max_req);
>>>>    		count = mt_alloc_bulk(gfp, max_req, slots);
>>>>    		if (!count)
>>>>    			goto nomem_bulk;
>>>> +		if (node->node_count == 0)
>>>> +			node->slot[0]->node_count = 0;
>>>>    		node->node_count += count;
>>>>    		allocated += count;
>>>>    		node = node->slot[0];
>>>> -		node->node_count = 0;
>>>> -		node->request_count = 0;
>>> Why are we not clearing request_count anymore?
>> Because the node pointed to by the variable "node"
>> must not be the head node of the linked list at
>> this time, we only need to maintain the information
>> of the head node.
> Right, at this time it is not the head node, but could it become the
> head node with invalid data?  I think it can, because we don't
> explicitly set it in mas_pop_node()?
1. Actually in mas_pop_node(), when a node becomes the head node,
    we initialize its total field and request_count field.

2. The total field and request_count field of any non-head node,
    even if we initialize it, cannot be considered a valid value.
    Imagine if the request_count of the head node is changed, then
    we don't actually change the request_count of the non-head nodes,
    so it is an invalid value anyway.

>
> In any case, be sure to mention that you make a change like this in the
> change log, like "Drop setting the resquest_count as it is unnecessary
> because.." in a new paragraph, so that it is not missed.
I thought it was a small change that wasn't written in the changelog.
In the next version and any future patches, I will write down the
details of any changes.

Thanks.

>
>
>>>>    		requested -= count;
>>>>    	}
>>>>    	mas->alloc->total = allocated;
>>>> -- 
>>>> 2.20.1
>>>>
