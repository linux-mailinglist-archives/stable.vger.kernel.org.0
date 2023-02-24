Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB096A1B5F
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjBXLZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjBXLY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:24:58 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54D1514F
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 03:24:57 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z42so6110721ljq.13
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 03:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sj8+res0hlMLAha2Od6VzO8IHzQal7RF12YPvzFFXJU=;
        b=OnDelbJjjAWuz026a2MnXCbbnVJuqEOgODWspOiBbFkR7EEkzc1/Gm7gIOyWQ345a7
         I9smoaMOtDs8GxrbY36lLlHZglGCF3LSMOYV1GWCaHWRDj2TZfIGgiuCcuOAu3m6SUck
         /4xV4qbfeIBFyetUiZKl4UV0oHYtjdvOnHVt9Fc4BI5Hksqag7MtVZcvjPtgKQiCoKjh
         7kT6csYXgyAK3Mekj2nCriuoltFNexvD5zBm7Pw42v60mVwTvCMOMS60seaSsEZraaJU
         Dn2p0RJoAq5BGql0R0TQ1fSBOBoPFDFET3irsti20ZMYP9szK2a3jeIKnceaPXetFW+E
         pCwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sj8+res0hlMLAha2Od6VzO8IHzQal7RF12YPvzFFXJU=;
        b=5BNVytfrTwniXHRgrO1/cLQmptQij0xkbqrCufjVZccDZduMZoLWORYAXpyQ9QglEC
         SlUqBv4QyUexHxbF6PgO8L6iZ7v8BO/eGLWvS/eTP59rQaE4FFYeI8ElQx+OMuaUbfm7
         bP3GXcht9r+8IpJDcfpRxKT7nxOwNk3NOCfZtFxA6t+sie9ZtcgndKAivV3S6T0GPUFt
         HHiIkhzqBRtBc305mfEWX1NInZxh3h9j9sVnfMLUoNG5udY+M5unSYP4oG6H0b+cUdMx
         OsDZIG6u2otw4yeBELAWR/IU4UkJRNUaP+MJwc0A/xG2mdcI42cJmNj4i7ptWRhv+c1G
         HDPA==
X-Gm-Message-State: AO0yUKXvSPbuw9s9k6cZJ2JSlgtMcjg6GdmYW0fpYcEetSei37N4uBfB
        fKbuR3hR45iIplhcSFMZV1lzmgJwP1mGPmKeOX8=
X-Google-Smtp-Source: AK7set+4ZXYVHGC43r8l2UCVKtXmPAinJrXm2w6VrvdquwHygkEnAjRH4byt/FMqkASSCJdAGb9G7jrYGPPJytMykUE=
X-Received: by 2002:a2e:aa1c:0:b0:293:4ed3:a404 with SMTP id
 bf28-20020a2eaa1c000000b002934ed3a404mr4705147ljb.2.1677237896065; Fri, 24
 Feb 2023 03:24:56 -0800 (PST)
MIME-Version: 1.0
References: <20230210140609.988022-1-andi.shyti@linux.intel.com>
In-Reply-To: <20230210140609.988022-1-andi.shyti@linux.intel.com>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Fri, 24 Feb 2023 11:24:29 +0000
Message-ID: <CAM0jSHPxwy5Vct80tuF2VqXS=pLDVvQoANaMLPTQOnQa49tS7w@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Make sure that errors are
 propagated through request chains
To:     Andi Shyti <andi.shyti@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Feb 2023 at 14:06, Andi Shyti <andi.shyti@linux.intel.com> wrote:
>
> Currently, for operations like memory clear or copy for big
> chunks of memory, we generate multiple requests executed in a
> chain.
>
> But if one of the requests generated fails we would not know it
> to unless it happens to the last request, because errors are not
> properly propagated.
>
> For this we need to keep propagating the chain of fence
> notification in order to always reach the final fence associated
> to the final request.
>
> This way we would know that the memory operation has failed and
> whether the memory is still invalid.
>
> On copy and clear migration signal fences upon completion.
>
> Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> Reported-by: Matthew Auld <matthew.auld@intel.com>
> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
