Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556BC524090
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 01:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbiEKXMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 19:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbiEKXMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 19:12:06 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F3B166D69;
        Wed, 11 May 2022 16:12:04 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d22so3257120plr.9;
        Wed, 11 May 2022 16:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DUv1H+jnNS72Cgs6yWB8Bi4tP13NzB8jjCDndTMF8+I=;
        b=ppRcsj/P3i32cgR8EG+vZChJ1appBXU+gsRrT8INVOuTHoH0T17uZQGgBU8Z7CuFVy
         p+btZOQmIHix89dfdK92O9EHk7kAEXx+PLEIdebzhxotbS4PgpbsFWfuzILzkS18nNBM
         bgaMefBjyKX7nWiEKh2dXhYhlXa+JX3RdaKyt3L/mUtkU96o5weFRYiS2w+O7bjQEJLQ
         rf2oUOkifcQNf9UW55kUV6N3LjZTKN5Ij8rtyv7no05tZKBdHqIpdJgppauwvRBmzWjY
         me07CdCskRiIXSVzpQD174k/w5mwCqOfTllJooXzLWIktu6StDYMkUTW6ZeSPUo1Sz3Y
         upcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DUv1H+jnNS72Cgs6yWB8Bi4tP13NzB8jjCDndTMF8+I=;
        b=mAtZ2YnzzMtnscBOwUVvyyiFUQZopgXQMsG0RHQBaowaU8mIH/ymWuKkSC9UYu3pqq
         9tgcljdnVHffMPkSb/7FRCPqXmMg6rbb908PL1Jhl87EnPG3lL6HV9fmgqmdgLDlduUQ
         Ou2QMfKLkFbOpXUtJv4NHVxOeR58/tf6k8VUAdCdlbAiysPCtBzM2IJQad4icNG1/GaO
         3xY1whFRYXABKOCSgI8NQTFq4ybEAR2kiyR4BLsVqhg833+16THAbFChQPk0pUXGTGEH
         4NV5H94XP3xj15BUBEIZd9+iN3+h/DzomalqyTfkoBP7F3rtbvXPyysSy9hUK8kvEaG/
         9UPw==
X-Gm-Message-State: AOAM530gxLuzcELsULhw241qBqo4Qz85zkPLiKhaDhPvYaGrSDKC1Odr
        gPHIZpFLFYhMSLOdI70/yOVjO4eUpJw=
X-Google-Smtp-Source: ABdhPJzhteElceeuVnZQP9OEuRFPtKDfFPM3glDSUQV0jCZR41svwcddTJF5MNrHenx3XEiEP+5xQA==
X-Received: by 2002:a17:903:1252:b0:154:ca85:59a0 with SMTP id u18-20020a170903125200b00154ca8559a0mr27746614plh.169.1652310723575;
        Wed, 11 May 2022 16:12:03 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:69ef:9c87:7816:4f74])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0015e8d4eb2e3sm2491273plg.301.2022.05.11.16.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:12:03 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 11 May 2022 16:12:01 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <YnxCwefm6a2zuT0G@google.com>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <Ynv53fkx8cG0ixaE@google.com>
 <YnwTfBLn+6vYSe59@sultan-box.localdomain>
 <20220511134322.54c44cb0cdd17a0f7fd9f761@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511134322.54c44cb0cdd17a0f7fd9f761@linux-foundation.org>
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

On Wed, May 11, 2022 at 01:43:22PM -0700, Andrew Morton wrote:
> On Wed, 11 May 2022 12:50:20 -0700 Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> 
> > > Shouldn't the fix be Fixes: 77ff465799c6 ("zsmalloc: zs_page_migrate: skip
> > > unnecessary loops but not return -EBUSY if zspage is not inuse)?
> > > Because we didn't migrate ZS_EMPTY pages before.
> > 
> > Hi,
> > 
> > Yeah, 77ff465799c6 indeed seems like the commit that introduced the bug.
> 
> I updated the changelog, thanks.

Thanhks, Andrew.

Feel free to include my

Acked-by: Minchan Kim <minchan@kernel.org>
