Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B3677FBA
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjAWP2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjAWP2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:28:41 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C0D298C9
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:28:30 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mp20so31417096ejc.7
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r+FrutqSNuV68lqvrrNh7Sr4U3SUrCUehEehb2FWvBU=;
        b=l/RvdiZx97yPnfnrcXAeZruddl2rIVvJFHwf03yiGon9MAWC7QHtZsBX5x4txGCUcC
         iJXAit7OrRoqwUMki/zYmHZX1JbkO6B8MQWhN7XZCV8x4ePMnAS5AdoFfIaM7VCOK2Wh
         5tskng0CwQi521xCojxGC5z2ZJBKfYCB9Y5ldn6RruKTG2nLZC4P1MY4sdcwr6zXvFfS
         dUsJ6jidO4GZbTyYYlbu4HOs4yHpAbZk3eVotDKXIvRWgGpV/ffKHY3+R/smFnY0vfPp
         A6kdGtd3wfv8R9rbp7QUIkyWWb4KQ9WGM4OWvM9eh5Xn+YhIkthG9mNZsOp/Udx1zOwD
         2Wxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+FrutqSNuV68lqvrrNh7Sr4U3SUrCUehEehb2FWvBU=;
        b=V8Fr5SoQg8YlTud2mL2zw2HeVBnbxIObzHNi+5LH7I7W3bB3z2DQKeTHeg7UAGUwfq
         V5KJgGJR69aoqAhtPCyhHT0v5gUa83VB2fj2w5lot3WgifQFpfcB2IBGw+zq4SSlw8a6
         TFsPa21BZYRpg9/G7VmF9O90YRGSUPeyRh6V652YJsNn+dFFPms//WojfvWUmHmPnvOT
         XaVhQN9jznx6y1axlfLN95io5YPkFDM1g1+KJfF4Q/jMEZXQIiy4VtZwP39Iga4obexK
         hVMaPVqjP7WevTtlc6DPundGrkq0ExtwqHI7L8OzXTD15EFTjLj5LF+L5ltBDuyzNIDM
         TrAA==
X-Gm-Message-State: AFqh2kpjkfPNmJio+qNQgYLhxXSfgHUhp0Fsh+tUHrotLzUOwuOXK61G
        6Xg5d4qVyz5gLdbut5D0X3gki1nueLzneQJI
X-Google-Smtp-Source: AMrXdXtE8yIyzqzPfqZux5hb9Zuy1mHJBY5+v3xKMjawW8t9AV+Y63oW8vo+2pTYKRew04TGdf5cxQ==
X-Received: by 2002:a17:906:7156:b0:86d:f880:5195 with SMTP id z22-20020a170906715600b0086df8805195mr25572874ejj.56.1674487708653;
        Mon, 23 Jan 2023 07:28:28 -0800 (PST)
Received: from marvin.internal.lan (193.92.101.37.dsl.dyn.forthnet.gr. [193.92.101.37])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906301500b007c0985aa6b0sm22274876ejz.191.2023.01.23.07.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:28:28 -0800 (PST)
From:   Nikos Tsironis <ntsironis@arrikto.com>
To:     stable@vger.kernel.org
Cc:     bfields@fieldses.org, chuck.lever@oracle.com,
        ntsironis@arrikto.com, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com
Subject: [PATCH 5.4 0/1] nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted
Date:   Mon, 23 Jan 2023 17:28:21 +0200
Message-Id: <20230123152822.868326-1-ntsironis@arrikto.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug that upstream commit c6c7f2a84da45 ("nfsd: Ensure knfsd shuts
down when the "nfsd" pseudofs is unmounted") fixes in kernel v5.13
exists in kernel v5.4 too.

That is, knfsd threads are left behind once the nfsd pseudofs is
unmounted, e.g. when the container is killed.

I backported the patch to kernel v5.4, and tested it.

Trond Myklebust (1):
  nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted

 fs/nfsd/netns.h     |  6 +++---
 fs/nfsd/nfs4state.c |  8 +-------
 fs/nfsd/nfsctl.c    | 14 ++------------
 fs/nfsd/nfsd.h      |  3 +--
 fs/nfsd/nfssvc.c    | 35 ++++++++++++++++++++++++++++++++++-
 5 files changed, 41 insertions(+), 25 deletions(-)

-- 
2.30.2

