Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA84F911E
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiDHItx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiDHItw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:49:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05C4334136;
        Fri,  8 Apr 2022 01:47:46 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m16so7323227plx.3;
        Fri, 08 Apr 2022 01:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2mCpxSUdvhWRHyULEeSOrL1ZUQdjKCwtXDlrgtif2uQ=;
        b=LgTeOp4FD8eVXqM+CswH9ILr8GhuBlbxdFrO9xgMuwPT1iVzz+xoztfw3vfgaNglam
         jSK3OIvw2PhR9K2asPw6pYdNnkW5pFGOGPuWRMkPN17DRtG36mLd4iiiHNzjj1swsTK1
         /fF341ISGmVCrZAvxaG/qBeu8x8bZiFAO2/t25WzQ71c1euQgs3jk/QBEKpfs8QPmpxi
         czyDuAx4Xdo0tGk+0O2AO611li/D3MDdIIxPYCUw0OhS//OgquOMnTJZlpquQ0h8mEwa
         s9bFg6QM549uQ5fkzsV89ZPM0132WVZB5i87TQcPIWQKFdUaMy9/c6oBppKds3F+aDic
         C/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2mCpxSUdvhWRHyULEeSOrL1ZUQdjKCwtXDlrgtif2uQ=;
        b=45H6sQkG1BQ4CYHghGQUr+C/6TQFv/sDLbzqyP6ycoqM4Syj8eePXGVzqZE/YY4O5M
         0dCSxGnlRALuRkYzc+dTLPnDUWcblu1O61FULkZsYBmONC3FkGIsQsAEoqMCKzn9GBBL
         +ZKA8+xCBLzplfD4JQ7t4m8jocoXd00LjCf2ULN2yoTjWryNxtesNfWHnBxlUQ6QjOoH
         rdNGjxtVQrRDMCnK54nMe6TnjtROQbjLdSlAyfoA7QpPNjL6h50CFsAGxt7ldoPc6d8e
         P6r1qmfF7DceveWKkqX8sO+fEikpowntA6FLHBwmdRSPqNZG7ecQyKRKAZVsTI52XzoT
         ZXCQ==
X-Gm-Message-State: AOAM533YlE8VhDZJ6zHKdRItRvIJoHS+DJCUJqTw7ZVA22P8d3k/H5uc
        60Ck3S7QDr7HCLrnT/hcektKLcYRJdszcA==
X-Google-Smtp-Source: ABdhPJxAdv6KQYD9wfphtW+GTJk9wFPTNah61Zbm3spGOxbAAQda5BLz4WwGLjSEg19uwWmRxEL8Sg==
X-Received: by 2002:a17:90a:e552:b0:1ca:2d70:79ef with SMTP id ei18-20020a17090ae55200b001ca2d7079efmr20351916pjb.175.1649407666188;
        Fri, 08 Apr 2022 01:47:46 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id fa11-20020a17090af0cb00b001ca6e27a684sm11076426pjb.16.2022.04.08.01.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:47:45 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.com,
        stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] md: fix an incorrect NULL check in md_reload_sb
Date:   Fri,  8 Apr 2022 16:47:40 +0800
Message-Id: <20220408084740.26153-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAPhsuW6AJAo_k1a5-EiUp-Qx9Rp=jkON155AtOMRO2JmhBVFjw@mail.gmail.com>
References: <CAPhsuW6AJAo_k1a5-EiUp-Qx9Rp=jkON155AtOMRO2JmhBVFjw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Apr 2022 17:37:55 -0700, Song Liu wrote:
> On Mon, Mar 28, 2022 at 1:06 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> >
> > The bug is here:
> >         if (!rdev || rdev->desc_nr != nr) {
> >
> > The list iterator value 'rdev' will *always* be set and non-NULL
> > by rdev_for_each_rcu(), so it is incorrect to assume that the
> > iterator value will be NULL if the list is empty or no element
> > found (In fact, it will be a bogus pointer to an invalid struct
> > object containing the HEAD). Otherwise it will bypass the check
> > and lead to invalid memory access passing the check.
> >
> > To fix the bug, use a new variable 'iter' as the list iterator,
> > while using the original variable 'pdev' as a dedicated pointer to
> > point to the found element.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 70bcecdb1534 ("amd-cluster: Improve md_reload_sb to be less error prone")
> 
> s/amd-cluster/md-cluster/

Have fixed it in PATCH v3, please check it. Thank you.

--
Xiaomeng Tong
