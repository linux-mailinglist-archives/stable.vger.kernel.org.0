Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC574FA011
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 01:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiDHXXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 19:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDHXXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 19:23:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917BC37A84;
        Fri,  8 Apr 2022 16:21:31 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u15so1443530ejf.11;
        Fri, 08 Apr 2022 16:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VeBo5MNmcNP8GgrnYnuxwD9C21s9NCSI0hQmRgeVZ2c=;
        b=SwUdCASoZsLrVzHwYE9Q2w7j8anHVyABwID7GJeaxGfrbLM5k0Ll9QikJqmhJzldK2
         DEhbbyAiFI6iSlauWF8t+jKysCy4/ituH373bOQYneDjgtlRMT6MU1S3YxRPtJMX4oX1
         xiqUnHmj8t0fgyqR+02CHlzq+jgHtUhjPECIh0Ks3TbRC2E9CvqftD/OWYrUdEqNpZjp
         3glxzcacU6WGhpBVaEXzCQ0oxQ8tSiZTZ4JCiNXATn1QSgRsiUvuhHZik+iIDX+IIXcf
         8J9iJvcV6FOxsjwd8QIAaWSAR31c/r5e3ajAJURaZ6AV3A29bWAbfjYHTsvDoGioJU0U
         luDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VeBo5MNmcNP8GgrnYnuxwD9C21s9NCSI0hQmRgeVZ2c=;
        b=LocO8QQASOg/2MlVENXwqXvko7M0Gyh1Q8rw2t21ZC8WE+asDd5XUA6w5btY24tQOW
         excSungF3YW5SezEbbHfUlM6dqw6vbYNaiJit95QMI42ByKlqkJ7C8ymVpKQ6gfHRIlR
         S2zAW4LCEEnZv18Bl0RHB/q4LiM0YgLjTHt3NlczevGIlJGp2EZdCHn0YFCrJsXIobK0
         NxT9pecLK5WzOQGeNnfrCPp+e2jwe93aL4YVOROaBjkVxxn6YiliQyZLBxuXvUXqona6
         RdoMIhFJVdbG+S+jGdCREHzkolyTWSVYs9HfwvOTn/9IZrUny+LxgJHb6Wtso5NabfoU
         +j4A==
X-Gm-Message-State: AOAM530fAMLsHsPbWJRGFrCsp+sHs7SrKst/uUNw7i/gkXChuGoX8575
        MWblsKqZkcqUZUiSu5cE+c0=
X-Google-Smtp-Source: ABdhPJw0QRTK6Xo+GwWqeZ539WFr3ViLkQZwB5m+GvauaxNMLcPszYUGFgrOGSqHLo80QDJyI0Moiw==
X-Received: by 2002:a17:907:7da8:b0:6e0:5b94:5ed8 with SMTP id oz40-20020a1709077da800b006e05b945ed8mr19652474ejc.312.1649460090158;
        Fri, 08 Apr 2022 16:21:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id v8-20020a50d848000000b0041cb912717asm8936807edj.91.2022.04.08.16.21.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Apr 2022 16:21:29 -0700 (PDT)
Date:   Fri, 8 Apr 2022 23:21:29 +0000
From:   Wei Yang <richard.weiyang@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek Marczykowski-G??recki <marmarek@invisiblethingslab.com>,
        Michal Hocko <mhocko@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <20220408232129.caboqxtw6s4nmgde@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20220407093221.1090-1-jgross@suse.com>
 <1028ca3c-5b6c-d95e-9372-ae64b1fcbc82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1028ca3c-5b6c-d95e-9372-ae64b1fcbc82@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 11:46:13AM +0200, David Hildenbrand wrote:
>On 07.04.22 11:32, Juergen Gross wrote:
>> Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
>> initialization") only zones with free memory are included in a built
>> zonelist. This is problematic when e.g. all memory of a zone has been
>> ballooned out.
>> 
>> Use populated_zone() when building a zonelist as it has been done
>> before that commit.
>> 
>> Cc: stable@vger.kernel.org
>> Fixes: 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist initialization")
>> Reported-by: Marek Marczykowski-G??recki <marmarek@invisiblethingslab.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>  mm/page_alloc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index bdc8f60ae462..3d0662af3289 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6128,7 +6128,7 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
>>  	do {
>>  		zone_type--;
>>  		zone = pgdat->node_zones + zone_type;
>> -		if (managed_zone(zone)) {
>> +		if (populated_zone(zone)) {
>>  			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
>>  			check_highest_zone(zone_type);
>>  		}
>
>Let's see if we have to find another way to properly handle fadump.
>
>Acked-by: David Hildenbrand <david@redhat.com>

Ok, I see the point.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>
>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
