Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8464EF4A
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiLPQiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiLPQiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:38:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5F51FF94
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671208648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKpV/VqJnDWZ/oVpmuV6caL/79sgF/1JHTzTx6G1qmI=;
        b=Q8qDUksMC01wGcr8hdCmpnfbvkCYKMXZtAMouiwFkRorX6dwqGUJjuuPhIngIh22lt6uBH
        wzucYuaijhOMXB8gOrn+jTaSwWuzaY4PJqg79LxV8Xnq/ufllG7vyxhilR2sXUI7qB4qeO
        nx2HkbrFbNJY9gh/lM9jFv2bQ2KE0M0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-Qo7iXV-cPAGtCHW3oTe3og-1; Fri, 16 Dec 2022 11:37:26 -0500
X-MC-Unique: Qo7iXV-cPAGtCHW3oTe3og-1
Received: by mail-wm1-f72.google.com with SMTP id 21-20020a05600c021500b003d227b209e1so732810wmi.1
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKpV/VqJnDWZ/oVpmuV6caL/79sgF/1JHTzTx6G1qmI=;
        b=4Vaze/4sMec9i1U5jXvvHFWrzfTKPqlHayx8xl/Rv8e9H7VksyxpSazxrDcMOHAosC
         imD0axV87sDlOWy97+TKKgkKMZs40hk8b3hQna1Zl8iBZQNQnrUuiQE71P427+5lesL/
         KmW/rLOyrGH5AS8DIQ3yq8X94dWBXTS/VsuJAbAY6h12elqUGUiAUwXGaPGWWeP+1mpb
         Y0mI9fTzSDuPmmAJMrqL1AKBBzLMoYPXeUZzgj9eHl7rX9rmNipwa9eezYVl8durSiEi
         MIVVfpxFvWsEmGIISBOLrQKWDtx8NdGG+dhX6TfwLTXpn2YhYQ+STxozUasdutwEc2Id
         cJbA==
X-Gm-Message-State: AFqh2koCOskx9Dp5FXuPNMzzs+y6t6gHhlG5HFf1Y7x+fm3TwCfbQJlL
        X2fuAjFyIfF/1EySPqSMvCHZ0fbXC8CzRo9WFoJRkDE0OhbOe1f6MJOO7mzStUlvq3vHT3EtibL
        2M/vg+UNL/MExJgDO
X-Received: by 2002:a05:600c:1d06:b0:3d3:4aa6:4fe6 with SMTP id l6-20020a05600c1d0600b003d34aa64fe6mr121467wms.3.1671208645697;
        Fri, 16 Dec 2022 08:37:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsWRJhHoFiViQpkEdyT8L9CVxpuBTZfVTyGNx3xoccjDeKiUopQOKgssEF482JY1V6yVJ+q0g==
X-Received: by 2002:a05:600c:1d06:b0:3d3:4aa6:4fe6 with SMTP id l6-20020a05600c1d0600b003d34aa64fe6mr121455wms.3.1671208645494;
        Fri, 16 Dec 2022 08:37:25 -0800 (PST)
Received: from [192.168.3.108] (p4ff23686.dip0.t-ipconnect.de. [79.242.54.134])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b003cf5ec79bf9sm2867736wmd.40.2022.12.16.08.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:37:24 -0800 (PST)
Message-ID: <19b49f1f-9d2d-6cf1-e764-ca4219b22ab9@redhat.com>
Date:   Fri, 16 Dec 2022 17:37:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] mm/uffd: Fix pte marker when fork() without fork
 event
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org
References: <20221214200453.1772655-1-peterx@redhat.com>
 <20221214200453.1772655-2-peterx@redhat.com>
 <618b69be-0e99-e35f-04b3-9c63d78ece50@redhat.com> <Y5yGp6ToQD+eYrv/@x1n>
 <8c36dd0a-90be-91bf-0ded-55b34ee0a770@redhat.com> <Y5ybyFa5U9VzVcwg@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Y5ybyFa5U9VzVcwg@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.12.22 17:24, Peter Xu wrote:
> On Fri, Dec 16, 2022 at 04:57:33PM +0100, David Hildenbrand wrote:
>> I'm more concerned about backports, when one backports #1 but not #2. In
>> theory, patch #2 fixes patch #1, because that introduced IMHO a real
>> regression -- a possible memory corruption when discarding a hwpoison
>> marker. Warnings are not nice but at least indicate that something needs a
>> second look.
> 
> Note that backporting patch 1 only is exactly what I wanted to do here - it
> means his/her tree should not have the swapin error pte markers at all.
> 
> The swapin error pte marker change only existed for a few days in Linus's
> tree, so no one should be backporting patch 2.

Right, and these patches are supposed to land in 6.2 as well. Makes 
sense to me then.

Especially, the other parts in patch #2 are worth being in a separate patch.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

