Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD44C0105
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 19:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiBVSNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 13:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiBVSNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 13:13:36 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7B76542F;
        Tue, 22 Feb 2022 10:13:11 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i21so12868609pfd.13;
        Tue, 22 Feb 2022 10:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZB+Gu7YpATSeA5t+N3YCnRgIG2ZtKKuUBwZ11FHjUfE=;
        b=RA5ZZcKVCaJu4k9+anC+SKGCGQerWGqOhKJaggLKQV7bGyHctRS7qpuJKLwzWJx3Wv
         Dey7ap2D5hO5jWRp53MeEF17hEm4V6cizKN1IjBybApavS5+4d3vKAO/eKEsgi5+pAct
         T9nbvEwNjHtHjH9OgbB4FdyB2PvlFDtrjGVHPbwXprRB+8x87LSxY4CLxE6wq0eSWYp0
         kjemJDp8QbuSY3VuODIS7aPNIfSVcqPvUNP1XKdmms7J15ZcFjzqJV529On+vnt42uIg
         ebWKFeYpqqrrqB0/DsXzqj2GtLcqPx0Qv/SuFKNMC/hqf3R+P8HbwUJWy+I5Ua+Q1Qjs
         f7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=ZB+Gu7YpATSeA5t+N3YCnRgIG2ZtKKuUBwZ11FHjUfE=;
        b=q4JNoTOaLpK5GiMd+rmzlOM84EhcpFdvnQUlBsl+elUUal/2+NdQPul83Y7AVSbJis
         HZyCE0iPc+dnzkwR9gQ/cOwNoKt+CeuVxpGSppuO5/rjy0zhOTC2rNg6gsQLnKuxCBaD
         QUuhsZ4AYouM6xNwWBfkdmpNVIVUEV2U2WUE9omBLLU/yCJSXkd09AGc99vKRWw3voTF
         +5kTyAiq1vHsy3YxqgqNEdn5BqXJ7PpyfhLpYdPWmQ5CF/Xz1i/1AGd8augbySK4dJhV
         RTKQ813Yd5xwqXDUF7oXh+BF3x02BpHMyA9b56KjQ60uexR14tQK0ISkW/cKqDb7I9C0
         LGlg==
X-Gm-Message-State: AOAM531M5w6io96BrFPGpOG5CGbcS+xnz/wZDORgN609hbWqUPZkKpox
        SWRsdbNQo/DEN7xKFtn9VW0=
X-Google-Smtp-Source: ABdhPJzdDUApA6XIS5hwgv9MnJix+kY9TnPhiSV/CJIJgcQFGm6rLgPfVPijE68/WRpEhbeg6YIJhQ==
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id c18-20020a056a000ad200b004f12734a3d9mr11379146pfl.61.1645553590865;
        Tue, 22 Feb 2022 10:13:10 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id i17sm21632607pgv.8.2022.02.22.10.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:13:10 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Feb 2022 08:13:09 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>,
        Tabitha Sable <tabitha.c.sable@gmail.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup-v1: Correct privileges check in release_agent
 writes
Message-ID: <YhUntajxL3YrDXXg@slm.duckdns.org>
References: <20220217161128.20291-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220217161128.20291-1-mkoutny@suse.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 05:11:28PM +0100, Michal Koutný wrote:
> The idea is to check: a) the owning user_ns of cgroup_ns, b)
> capabilities in init_user_ns.
> 
> The commit 24f600856418 ("cgroup-v1: Require capabilities to set
> release_agent") got this wrong in the write handler of release_agent
> since it checked user_ns of the opener (may be different from the owning
> user_ns of cgroup_ns).
> Secondly, to avoid possibly confused deputy, the capability of the
> opener must be checked.
> 
> Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agent")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/stable/20220216121142.GB30035@blackbody.suse.cz/
> Signed-off-by: Michal Koutný <mkoutny@suse.com>

Applied to cgroup/for-5.17-fixes.

Thanks.

-- 
tejun
