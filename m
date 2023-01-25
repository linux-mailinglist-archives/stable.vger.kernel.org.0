Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D92467AF5F
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 11:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjAYKLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 05:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjAYKLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 05:11:20 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C22EC7E
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 02:11:20 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y69so8255748iof.3
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5SeUJhAbfU72yemE0E0j1G7piTXH1F7KntUn7UYBddU=;
        b=n82yTyq60gfB7ZBTcbC47BjG7Tytwup5QkbDjOCyYW+pS+3OfxGwgnZFTABB/LqcGZ
         7tVrStGLiZqVVpfbWnbaTbpvptVnM+Nu8sYeHLTWIVvUMx8Mx0cOWiRicmCtvT22ntQM
         QatXbUnE5o+8UFv2vFRx2/Ug9/Kmo2gKyhABplKcWjhAe+Uq1QnflpzrQzKMiU1JLnB/
         8zYBwHUqvms2mOcaT0U68C5JKkEObDM3xvgkUgwLT5rR+RJ1rm9ymk2g8OI0VEgLCY0O
         u+8uIzx2vAnCFTK5d2N2GWZCPbk5y+LoO273DLxKY517CgTyfXdW6O5D9v5WijsKfc6G
         qesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5SeUJhAbfU72yemE0E0j1G7piTXH1F7KntUn7UYBddU=;
        b=E5tQEvrZDGt0Gc5bY4HXaBQwRm1NZ8nBqsoi6khtOFo+qhKfrhmgIxdquuocZK/wKe
         IREhjmb7GSvDWomsJ7pSCx82iR7FmqlylNFgNh1psC3izCB/wY5Hje8RsZbvDiCthw+D
         SVT1gYtPLevwZuu4PU7iumGOSxw6ps1zvz8dqXlRNXDEaAV/v2ipf+SvYy0sYoegIq65
         WgvwYPruMUkTQQOtvOUYe99tbIk+YXRWVzIgY4febP/Qvhau1Feu3UhHC9MDofQyPWPC
         XGcXPO+wPndsp42rq6B70oZglafyMmRy2bPhtfci7hFZ6nmv3WqMBl0jWGc6OPlZspjl
         oaeQ==
X-Gm-Message-State: AFqh2krXObo/X5EDVDsQ5mNTru+nEj6jC3WLHf5CrB7BCbwMGpMi74st
        J0KpPqWyU9G6XB/O+5l+QAsEP6OudSy9oZ0DOwX2LnJ/W5agdGu0
X-Google-Smtp-Source: AMrXdXtr6x7bYmEm3e0aUlWGo2ZpD49VFa3T/OLaI5NXGvDzxuAP39ygszlGpkz6AcbCjewz+os3jpGlAoIReMKipzo=
X-Received: by 2002:a05:6602:42c7:b0:6e2:f126:6c1f with SMTP id
 ce7-20020a05660242c700b006e2f1266c1fmr2792945iob.1.1674641479393; Wed, 25 Jan
 2023 02:11:19 -0800 (PST)
MIME-Version: 1.0
References: <20230123070414.138052-1-ebiggers@kernel.org> <CAG_fn=VNjkRMozdcQUSMTHvMQ26SG45oisxamJbEVrg2m41ngg@mail.gmail.com>
 <Y87PqGgw1uJVlnrP@gmail.com>
In-Reply-To: <Y87PqGgw1uJVlnrP@gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 25 Jan 2023 11:10:43 +0100
Message-ID: <CAG_fn=VRgtSfN30HK2kpJMRvz3utrzbiXUJ+c1-_D5RX-_UUyg@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix information leak in f2fs_move_inline_dirents()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org
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

> > Out of curiosity, did you add any extra annotations to detect uninit
> > writes to the disk?
>
> No.  This is the report I got:
>
> [  145.280969] =====================================================
> [  145.285368] BUG: KMSAN: uninit-value in virtqueue_add+0x1ba5/0x6ac0

Oh cool, nice to see these are actually working :)
