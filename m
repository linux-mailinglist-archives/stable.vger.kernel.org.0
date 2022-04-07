Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7BC4F7984
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbiDGIZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiDGIZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0A6963FE
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 01:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649319792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Ak2L++rWGA7iZB3bqmGGUjd7xVRHy3vUvtqw/fn7ZM=;
        b=jL8rHmXi9ta4KzWQQyQYRmb3eRNFJzsyzpCxUy2IaWCDTmJYGO1v3R0TXGnVzAkrESwvEt
        u0GsPNmCrheOYBdOjgIIOGTAkcrfDODUHmBQrdYvrPBg/q+uvMEWZGfjJ7NVzBIHg2d6bz
        CrtoMx3yRjJJSbLE3iVyiz+3w/e/Wcc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-1pp3Vj4wONGdQyrXMrTkgQ-1; Thu, 07 Apr 2022 04:23:11 -0400
X-MC-Unique: 1pp3Vj4wONGdQyrXMrTkgQ-1
Received: by mail-wm1-f70.google.com with SMTP id r19-20020a7bc093000000b0038e706da7c0so2639880wmh.1
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 01:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=6Ak2L++rWGA7iZB3bqmGGUjd7xVRHy3vUvtqw/fn7ZM=;
        b=8NqoQD1xjMq9F+xMPovccdSs7SPTKq9TlwXNsSV3A0BvRw0RX0rV7GOjS+wmtxJ9KF
         jnSlUeuasWSNBSSHCenCSF7ERjhoIphRsMri34PjEDfg+jQqdTdkwhksn8T92Lj2lrk1
         AmuIzAv8hUkvKGOoLhQTdgjTYYTSLNqnG0LUyefmLLnHK+z2wVs/FAxuFj3EjE2NlbQV
         dao5JzLW0eG1rO1ftml4+adOS4y/4S/258jzUJ5qWydrTkYzNz7asMW8f5h478+Svxoj
         l5vsTulMs2U+rUI+UbtVZ4mCcKz1BQKWUp7/7AuYlGrmp3o+tTsu8UH/T++nnL/Rtwle
         Ek7Q==
X-Gm-Message-State: AOAM533gAkVyqw9pzGtZA0Pyg+oYBotUo5zvRpqy+K5nfVkh+1L4Posa
        ZC+2FSBlg9yBpwf7UcPOkoPx1b5qIepP1OO8zcEq6Ua04vHlWibc9+PqtOZGBFHy8lI6hdIBy2q
        uwG2GzW3N9bC6sXQb
X-Received: by 2002:adf:8046:0:b0:205:db94:4766 with SMTP id 64-20020adf8046000000b00205db944766mr9967288wrk.565.1649319789903;
        Thu, 07 Apr 2022 01:23:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Tu0tp6Y15gnR0aUGERxnoLQ64ptBmMTawYi6J5rkgZz3tkxFuWT9Vp/1zCYi8qjcSciYkA==
X-Received: by 2002:adf:8046:0:b0:205:db94:4766 with SMTP id 64-20020adf8046000000b00205db944766mr9967251wrk.565.1649319789519;
        Thu, 07 Apr 2022 01:23:09 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id k11-20020a5d6d4b000000b0020599079f68sm16415621wri.106.2022.04.07.01.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 01:23:09 -0700 (PDT)
Message-ID: <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>
Date:   Thu, 7 Apr 2022 10:23:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@kernel.org>
References: <20220406133229.15979-1-jgross@suse.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
In-Reply-To: <20220406133229.15979-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.04.22 15:32, Juergen Gross wrote:
> When onlining a new memory page in a guest the Xen balloon driver is
> adding it to the ballooned pages instead making it available to be
> used immediately. This is meant to enable to add a new upper memory
> limit to a guest via hotplugging memory, without having to assign the
> new memory in one go.
> 
> In case the upper memory limit will be raised above 4G, the new memory
> will populate the ZONE_NORMAL memory zone, which wasn't populated
> before. The newly populated zone won't be added to the list of zones
> looked at by the page allocator though, as only zones with available
> memory are being added, and the memory isn't yet available as it is
> ballooned out.

I think we just recently discussed these corner cases on the -mm list.
The issue is having effectively populated zones without manages pages
because everything is inflated in a balloon.

That can theoretically also happen when managing to fully inflate the
balloon in one zone and then, somehow, the zones get rebuilt.

build_zonerefs_node() documents "Add all populated zones of a node to
the zonelist" but checks for managed zones, which is wrong.

See https://lkml.kernel.org/r/20220201070044.zbm3obsoimhz3xd3@master

> 
> This will result in the new memory being assigned to the guest, but
> without the allocator being able to use it.
> 
> When running as a PV guest the situation is even worse: when having
> been started with less memory than allowed, and the upper limit being
> lower than 4G, ballooning up will have the same effect as hotplugging
> new memory. This is due to the usage of the zone device functionality
> since commit 9e2369c06c8a ("xen: add helpers to allocate unpopulated
> memory") for creating mappings of other guest's pages, which as a side
> effect is being used for PV guest ballooning, too.
> 
> Fix this by checking in xen_online_page() whether the new memory page
> will be the first in a new zone. If this is the case, add another page
> to the balloon and use the first memory page of the new chunk as a
> replacement for this now ballooned out page. This will result in the
> newly populated zone containing one page being available for the page
> allocator, which in turn will lead to the zone being added to the
> allocator.

This somehow feels like a hack for something that should be handled in
the core instead :/


-- 
Thanks,

David / dhildenb

