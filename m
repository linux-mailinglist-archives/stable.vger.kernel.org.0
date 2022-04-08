Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB04FA003
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 01:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiDHXSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 19:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiDHXSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 19:18:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E7B3134F;
        Fri,  8 Apr 2022 16:16:38 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bq8so20037801ejb.10;
        Fri, 08 Apr 2022 16:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A2ZrlgJ+VrtokqXnuamBEtt/J5VIyMuX+6kPQRag0BE=;
        b=N2tlbM5sjWAgO8qyd8xUS+x79WJ0ZseWclBiQ5Uph4APriR9kfGWaNYH2HjeaLpQbH
         UJTVvDMt590jDOrwUeY+B/Xumz4rFwoxMNKI+BRRbmPbBetC1zBSvfMBBv1Eotr4E00p
         roAu4eZNL5KzxxejvkI6WhuQ2ikCAunpCpNjNAu8uDwhxqremovJpTgAS6JsSCFfT3oh
         XTnA/4/mDkG8TrTLjxvngKVHTS6evew0i/L9g+eyUiKwIxFFLEsV9JXidIOfAJA2D32s
         nw8gj46C8yrXz0NA4Gwj7AqCOchIP5jp9nu3yM87aVy/eoDY0cH+6XOUTOTtBAaAr6Ts
         GXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=A2ZrlgJ+VrtokqXnuamBEtt/J5VIyMuX+6kPQRag0BE=;
        b=hqVwTjDaletqoVenZG8i133fCJIOtQbFox7ksOac35bvxRXWGg2gnJjBfWDm7aAf7n
         PofsePFuaBfBSxmVcPPoOe1siJzboUUReBYso0WtTafa+WQU8xo4X4usFYLTaSK299Qj
         JfGuGGPM8UyWYwKGudgLSJARkIv+efCuztr/oLg3LF8iYji20zoegWkpxkbqfTDoFd3c
         DWtQOOw5p7O9qhcfG1lcuR7tpUX+s7m6zq8CtMbcIpUnb/KJqH9UMGb2oqJeDzUp8KnR
         vL9xnmOlN/KB9oMbxgq76Ddq5q0fqC8Q3gjM5IchFdw590Fj17+iP6H2GNQB+apeD9OB
         5/UQ==
X-Gm-Message-State: AOAM531l/Y9awlwMCOoKEk/zPdgSBAsbMGmsnXHcsmtATUo62z5+Nfso
        eWcDCaV+BVrZrl+kq9uczYM=
X-Google-Smtp-Source: ABdhPJxxChRoxlprELOAqhnCawCzlD4GSAcZ0w3f3uVWj3UaU9JZ4tUDBqifGUtDHDOIU2hkiPJliA==
X-Received: by 2002:a17:906:2991:b0:6cf:6b24:e92f with SMTP id x17-20020a170906299100b006cf6b24e92fmr20192204eje.748.1649459797553;
        Fri, 08 Apr 2022 16:16:37 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm9098147eje.173.2022.04.08.16.16.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Apr 2022 16:16:37 -0700 (PDT)
Date:   Fri, 8 Apr 2022 23:16:36 +0000
From:   Wei Yang <richard.weiyang@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Marek Marczykowski-G??recki <marmarek@invisiblethingslab.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
Message-ID: <20220408231636.dz3spgicntflr7wu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20220406133229.15979-1-jgross@suse.com>
 <89ad978d-e95e-d3ea-5c8f-acf4b28f992c@redhat.com>
 <4f1908b5-5674-a772-3cd9-78e4dc40f776@suse.com>
 <f423e210-3e28-73f8-1082-869ef680b9b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f423e210-3e28-73f8-1082-869ef680b9b0@redhat.com>
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

On Thu, Apr 07, 2022 at 11:00:33AM +0200, David Hildenbrand wrote:
>On 07.04.22 10:50, Juergen Gross wrote:
>> On 07.04.22 10:23, David Hildenbrand wrote:
>>> On 06.04.22 15:32, Juergen Gross wrote:
>>>> When onlining a new memory page in a guest the Xen balloon driver is
>>>> adding it to the ballooned pages instead making it available to be
>>>> used immediately. This is meant to enable to add a new upper memory
>>>> limit to a guest via hotplugging memory, without having to assign the
>>>> new memory in one go.
>>>>
>>>> In case the upper memory limit will be raised above 4G, the new memory
>>>> will populate the ZONE_NORMAL memory zone, which wasn't populated
>>>> before. The newly populated zone won't be added to the list of zones
>>>> looked at by the page allocator though, as only zones with available
>>>> memory are being added, and the memory isn't yet available as it is
>>>> ballooned out.
>>>
>>> I think we just recently discussed these corner cases on the -mm list.
>> 
>> Indeed.
>> 
>>> The issue is having effectively populated zones without manages pages
>>> because everything is inflated in a balloon.
>> 
>> Correct.
>> 
>>> That can theoretically also happen when managing to fully inflate the
>>> balloon in one zone and then, somehow, the zones get rebuilt.
>> 
>> I think you are right. I didn't think of that scenario.
>> 
>>> build_zonerefs_node() documents "Add all populated zones of a node to
>>> the zonelist" but checks for managed zones, which is wrong.
>>>
>>> See https://lkml.kernel.org/r/20220201070044.zbm3obsoimhz3xd3@master
>> 
>> I found commit 6aa303defb7454 which introduced this test. I thought
>> it was needed due to the problem this commit tried to solve. Maybe I
>> was wrong and that commit shouldn't have changed the condition when
>> building the zonelist, but just the ones in the allocation paths.
>
>In regard to kswapd, that is currently being worked on via
>
>https://lkml.kernel.org/r/20220329010901.1654-2-richard.weiyang@gmail.com
>

Thanks, David

Do you think it is the right time to repost the original fix?

>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
