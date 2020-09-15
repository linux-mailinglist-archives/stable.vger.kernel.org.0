Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39B26A0BC
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 10:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgIOIYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 04:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgIOIQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 04:16:29 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B076EC06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 01:16:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d13so1579814pgl.6
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 01:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCyQLZIomtOO1i6n72+em9VVg13AQuPSjMf53LDYaqM=;
        b=auIoq9oCUFxSo4pwN0sve/6Y70uneeWypGCBG5hiKQEvrs5xsnPny5hFer4eYtvobB
         i1e8/4/NUocwRqRvZU4d3158MMYfZg9uMyBexYuihdiruBMYNWdXKwXZmAO2N378J80N
         eqkHCtMx81ILLcpD+YrJBxPJuBdMEMfiKoVJ9PCflvPIRPoKR3aLmjbC9JpchjGEgL+2
         OAAG2s6uGACAX/l/xxBhnVkglCSTQNyHNAdoPoaq3u4mqUNcVpJM4OnR+IYbo/Jgnt2E
         jYrW4IZZm931VWbRzDf+K2XYOH9XodrcyeKISXf5fabViRfS4vXU4n23bTlmOwPIyfCG
         FM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCyQLZIomtOO1i6n72+em9VVg13AQuPSjMf53LDYaqM=;
        b=BTjKRmR4wVvcqranf7UP0Mld9arD242Fl2LjU7/pqprhlF94aURraCf9k1BWSczBMy
         AGspIO6dvHdxiacb43EP6sdH/a6d/1HycJxrF+VBAfN9MXZcAbgfiVqE6CmheyMTbNGu
         FqchQ/TnIDBM4HYp9hVOBFo7yVkLV/d1vpfh5yeFAzBVXWvMQxXH09MEMwx2NpuGOe7c
         NmT2+sy4Bj7II2IEBq9Z6JfVvaB2hWiAdT/Sny/bI5SJ5pSQg9hk67AadWpy9E2iTKVj
         duxaSp5mXO+l3RAMFqaKCNHKUFOJaGIcDusoL1RHU24GYZlumQ62WM1LMdbeVV+qV54B
         zT0Q==
X-Gm-Message-State: AOAM53241bpK16QQU/hM7i6NaiEwPicCjGai/xGpQvAOgy2+l0lP+SfP
        UXhDLTIqllmm1U5Ub7HeVxvumg==
X-Google-Smtp-Source: ABdhPJz/sjjpFc3hiXj9N7JffKpq8GhR5gx1bxMX6eM7XMcT5j1DHbJd+okuEH1Z85Q1f72+EGOhYg==
X-Received: by 2002:aa7:8249:0:b029:142:2501:39dd with SMTP id e9-20020aa782490000b0290142250139ddmr827130pfn.44.1600157764267;
        Tue, 15 Sep 2020 01:16:04 -0700 (PDT)
Received: from localhost.bytedance.net ([103.136.221.71])
        by smtp.gmail.com with ESMTPSA id x19sm10539429pge.22.2020.09.15.01.16.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 01:16:03 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/3] io_uring: Fix async workqueue is not canceled on some corner case
Date:   Tue, 15 Sep 2020 16:15:48 +0800
Message-Id: <20200915081551.12140-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should make sure that async workqueue is canceled on exit, but on
some corner case, we found that the async workqueue is not canceled
on exit in the linux-5.4. So we started an in-depth investigation.
Fortunately, we finally found the problem. The commit:

  1c4404efcf2c ("io_uring: make sure async workqueue is canceled on exit")

did not completely solve this problem. This patch series to solve this
problem completely. And there's no upstream variant of this commit, so
this patch series is just fix the linux-5.4.y stable branch.

Muchun Song (2):
  io_uring: Fix missing smp_mb() in io_cancel_async_work()
  io_uring: Fix remove irrelevant req from the task_list

Yinyin Zhu (1):
  io_uring: Fix resource leaking when kill the process

 fs/io_uring.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

-- 
2.11.0

