Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53AB652455
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiLTQK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 11:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiLTQI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 11:08:56 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A641A396
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 08:07:28 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id d13so8486286qvj.8
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 08:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N69AnN/HCGfz6y/pBDE+Dl/UeoUyFu+chnsy6BgVL3w=;
        b=AeRgstx1cCT95ZSqqjbb0GKPXOYVhZE6R9V7VefA0fuOv1IQyjSThAUuHdmwVnnlwI
         J+pHWLQ9/btK/Bbr26xFePa4nNDVhGq1HgL9+ysZsavOpVvcwUAAyzyu4tQCL4RhQcfJ
         tnVIdnTnfnoJDi1BiXApTBA+gc7afeH4jfmOy9uzcXLRI2cnltWkAYFKDLrymTD2cq7J
         F1pDiKQeiRZZ6QXxucTvaql35Jt8YRMXbB/PftvS4tX5KZOg6FGCzbcDR3/Hn42lSqwg
         HqqKhe8YXkk7/2SCbe6UMLVu+MtM8aNoqPN/LdDEWVFG/huTmFGddFVwhFL2ztYZ5/dx
         NNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N69AnN/HCGfz6y/pBDE+Dl/UeoUyFu+chnsy6BgVL3w=;
        b=qcwwh8LbiI2m0SZ5pRPFc/yHIUzqXUxyGMM/N5jVOAc3YcFco9MR4i+SVK2w8sqhz2
         bt7n5xOP9EFBr/+QrURRh+PSx6tqTQnZK17yBnHCGs1eYRxUQCOV1TJIc7JoPZiIDPD0
         1A9koVxQRis0P2Sx+t5ZYJ2xh5sb1u67KquLiiUQiB7e40Cgc+niRO6P8U2H8lscUFOc
         XO22D/Ev0jFGJu7G69yJpNSYsJVA7TGyQ48UmL56/u6xAYREHfprqTTvWvbPwJ3l7P8I
         Bq9i9Ub4sEORQWNM87W35DLEjJmNPZwhU7wg2rQZypLDmk6APA2IFUOjWRUsgc47v9E6
         /NYw==
X-Gm-Message-State: AFqh2kpGJQ9BBj9uKDxRVZIszuceBPO2uvhayvshzcBpRv+tP4MDxUgr
        smfiJcmPgxpWTXRfejX6aHmsa8OfmwE86LvOOi+wzg==
X-Google-Smtp-Source: AMrXdXsBNTd5k7lmnyqqX9fuJ3m71PHVIcvyxLDNEzzwTVKxCrIS5FWKx9DnSYOatAouialVfNPvEhcABgtwbnY2Seo=
X-Received: by 2002:a05:6214:5c83:b0:4f4:65c1:d799 with SMTP id
 lj3-20020a0562145c8300b004f465c1d799mr1004017qvb.81.1671552447953; Tue, 20
 Dec 2022 08:07:27 -0800 (PST)
MIME-Version: 1.0
References: <20221216133125.3159406-1-peternewman@google.com>
In-Reply-To: <20221216133125.3159406-1-peternewman@google.com>
From:   Peter Newman <peternewman@google.com>
Date:   Tue, 20 Dec 2022 17:07:17 +0100
Message-ID: <CALPaoCiQmh-t_Wj8mzr6+_EUo_9x2=xVQOYh0_NSP+sVHGvCtA@mail.gmail.com>
Subject: Re: [PATCH v6] x86/resctrl: Fix task CLOSID/RMID update race
To:     reinette.chatre@intel.com, fenghua.yu@intel.com
Cc:     bp@alien8.de, derkling@google.com, eranian@google.com,
        hpa@zytor.com, james.morse@arm.com, jannh@google.com,
        kpsingh@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 2:31 PM Peter Newman <peternewman@google.com> wrote:
> In a memory bandwidth-metered compute host, malicious jobs could exploit
> this race to remain in a previous CLOSID or RMID in order to dodge a
> class-of-service downgrade imposed by an admin or to steal bandwidth.

After discussing with Reinette some more[1], I think the payoff of
exploiting this is too little for this to concern me, so I'll remove
the paragraph above.

[1] https://lore.kernel.org/lkml/CALPaoCi8hcFzNN9O9fS9Etri_KMdU32UU1tJsfeO1OxR-i1j7g@mail.gmail.com/

Consequently I don't think this fix is critical enough to be needed on
stable, so I'll drop the CC: stable from the update.
