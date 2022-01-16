Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42B148FA2F
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 02:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiAPBmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 20:42:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234061AbiAPBmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 20:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642297354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h/3f7kB2h8aV7nsC2ViXyD2eXCxEUw2KZV4uopXk2LE=;
        b=QfLEGcK9vRz9GQeaxop29c8d6dVz9KSiHlGjPg0AvQdlqJ9mPZ92E3mxn+WMOXX99qtDGT
        sHY0AShE+pfpPpMd7qgnwrK41leo3iBm4tKwmwkl8QJQUQLsnHww4dLif41FZJtPMTRQ+X
        yYBV0nSJUUbCFi0kgdU3iimGQ2HWrKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-OabrKOB1NOaFzXgSIUEmRQ-1; Sat, 15 Jan 2022 20:42:30 -0500
X-MC-Unique: OabrKOB1NOaFzXgSIUEmRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D43511898291;
        Sun, 16 Jan 2022 01:42:29 +0000 (UTC)
Received: from [10.22.16.16] (unknown [10.22.16.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37BF45DF21;
        Sun, 16 Jan 2022 01:42:29 +0000 (UTC)
Message-ID: <988fd9b5-8e89-03ae-3858-85320382792e@redhat.com>
Date:   Sat, 15 Jan 2022 20:42:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/7] rwsem enhancement patches for 5.10
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@google.com>, stable@vger.kernel.org
Cc:     timmurray@google.com, peterz@infradead.org
References: <20220115005945.2125174-1-jaegeuk@google.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 19:59, Jaegeuk Kim wrote:
> Per discussion [1], can we merge these patches in 5.10 first?
>
> [1] https://lore.kernel.org/linux-f2fs-devel/CAEe=Sx=6FCvrp_6x2Bqp3YTzep2s=aWdCmP29g7+sGCWkpNvkg@mail.gmail.com/T/#t
>
> Peter Zijlstra (3):
>    locking/rwsem: Better collate rwsem_read_trylock()
>    locking/rwsem: Introduce rwsem_write_trylock()
>    locking/rwsem: Fold __down_{read,write}*()
>
> Waiman Long (4):
>    locking/rwsem: Pass the current atomic count to
>      rwsem_down_read_slowpath()
>    locking/rwsem: Prevent potential lock starvation
>    locking/rwsem: Enable reader optimistic lock stealing
>    locking/rwsem: Remove reader optimistic spinning
>
>   kernel/locking/lock_events_list.h |   6 +-
>   kernel/locking/rwsem.c            | 359 +++++++++---------------------
>   2 files changed, 106 insertions(+), 259 deletions(-)

Have you actually tested it in your testing environment to verify that 
these patches can address the problem? I suspect they will help, but it 
will be nice if you also include your test results.

Cheers,
Longman

