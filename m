Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C828B624D82
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiKJWKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiKJWKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:10:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2562F01A
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668118166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h38wWhVkSIZtB2RyPJKkf5rNtE65Gqs4wgaNeAIALcc=;
        b=iXWbs2f6EkBl/zy/ngnkuvQFZdKeqJkiSJLig1Zl6mxsOYuEW5zkgnQsWpvLe1r1qZIDsY
        SkRY/cSw1gZ6qK5+R8jjQ3tPuak9clhepX9d05IFz1rZDpqaKD+lcybX5RjWkhIOI25tL1
        q5WZd0EFob4F+PdNNdl6Ubqp6fiH4yQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-ct7P0MBVP7Kmf5zuRt6WhQ-1; Thu, 10 Nov 2022 17:09:25 -0500
X-MC-Unique: ct7P0MBVP7Kmf5zuRt6WhQ-1
Received: by mail-qv1-f71.google.com with SMTP id q17-20020a056214019100b004b1d3c9f3acso2537322qvr.0
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:09:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h38wWhVkSIZtB2RyPJKkf5rNtE65Gqs4wgaNeAIALcc=;
        b=rfdhHTcCzc4yWG69kH8nMX2qcWOnAex4GCOZeJGAhjuPa1yUtXgElN48mvDEyLk5V+
         xAMUflN5vhliatFRamJK18/nyx60l85wlQJTstS51Ja/xN0yJq8MR7wJnh4nIpjS7nSd
         FK6Txfq1ZBGYWskXLtK6wHDMkEV7hMJtvhSDwDgM92DDuyl+qatrN7f8KfSHa7+BtUE3
         nJuM78TNwi1LfjCpUptFR4TUbl6c3rf+f5fdlcG9REKjAJmBIj/eOJQokXFKya+a1Tqk
         Fg2G3OEmFmBf/NgfcdkvkFiWkH+S3W4VXPNjW9pKTAtwje6R/NEV6/ASzCOctc//yUyS
         CBqw==
X-Gm-Message-State: ACrzQf3U2ULJWLngpzPNMj0LfldUDJJRNGqMqvhjM8Jh3QYbbwJzIui9
        SJt7k9Pgu9BJNb1WA7iqgVV2u1Svy2UsNWkECI0utF8NTxdER6GAq7iKIHxLaJKcK8tQkie1/OG
        Xfbm5US2cACX0CQJ8
X-Received: by 2002:a05:6214:418c:b0:4b1:8788:21ff with SMTP id ld12-20020a056214418c00b004b1878821ffmr2170365qvb.16.1668118165057;
        Thu, 10 Nov 2022 14:09:25 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4zT6Kz79MRmDBsfpoBn32M93cP30ai8uShqGW0DU7ZFM+GRq+eHe4ng1aNLorRKZp5T5POkg==
X-Received: by 2002:a05:6214:418c:b0:4b1:8788:21ff with SMTP id ld12-20020a056214418c00b004b1878821ffmr2170352qvb.16.1668118164890;
        Thu, 10 Nov 2022 14:09:24 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id q45-20020a05620a2a6d00b006ee7923c187sm346175qkp.42.2022.11.10.14.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:09:24 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:09:23 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y212k5F+/5xHksW/@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <65FA2E7E-1F12-4919-BD79-11159934CF2C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <65FA2E7E-1F12-4919-BD79-11159934CF2C@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 01:28:31PM -0800, Nadav Amit wrote:
> On Nov 10, 2022, at 12:31 PM, Peter Xu <peterx@redhat.com> wrote:
> 
> > Ives van Hoorne from codesandbox.io reported an issue regarding possible
> > data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> > sympton is some read page got data mismatch from the snapshot child VMs.
> 
> symptom (if you care)

Yes, but,

> 
> Other than that LGTM

this definitely matters more. :)  Thanks for taking a look, Nadav.

-- 
Peter Xu

