Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D440303B7C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392344AbhAZLW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392296AbhAZLVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:21:40 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25537C061573
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:00 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a14so7976852edu.7
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IMyqYTXqTzTLWfe8vrd6x/7omUr8iT404e7c2RUFYk=;
        b=qITcifFsH1smekPiWNQHWANIPHCwtS8vFkZoH+RLD7G6bDdDawjhf/umkMf4WwOVXW
         QtYf3nEEiL1NyIKGgg6NCVkwla5l60tmqcObYO/eF1Kg3+CiTGtVGsyEqpe1AFw6flei
         Q+cUlxEfMqt6j5o3pVtBYJzWtCt7tQfX/n0plaQjlh8sLL+NWxgNhIt9t1Ek1moVU3l4
         ydOUvQQ1/OT4FEC9ugeIG7RCrjddWGejhtVEtpFmmhGzzeuiEgiJ+NTcDAK55PdHKdzg
         eqgeyIVbyBEwHxv/GDvVw7ws3v49+aQ2kdL9aL1FM/cNMltt9qQW3mfwmo7vPtAWOZnq
         MGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IMyqYTXqTzTLWfe8vrd6x/7omUr8iT404e7c2RUFYk=;
        b=ZRcCYZTXgJ7NgAQmt0wa97jeQzg7cIgAYhhjj10wr6ed5c4qDrpXJZaIv4STjgnpiT
         52IKYHMkufJ39GKxjusWMqx7+j2zHQ2JbyxzSJrJ1LPvvwbtVSvA6DFAUw/PXoL9ww/P
         ALoej4Dej4PLktu93AdeGEFp3YHyoYh+DHgum2Yi84K/6RgCAO4GHgC7szVTrBibhpeO
         Tn8XQO4DTw3ttbqjhT5uQ1QPm6oygPJi6bBjXTUFUS9xUkzbxiYXMaLeBF5SsRrTXdCK
         aSPQrV5vHSBwAeUo1/r+l1kFOBQLUHdYp0c1ojorKOa+yjiQWZ5xLweGZVaLAW+rswsz
         +Pag==
X-Gm-Message-State: AOAM531PvmmVvyb8Qa9iVXOsIcRf/RxQjaFFDTeGqWVeKzS+iUltBTUW
        sX7dUEIKvvE9Tnc1yQ/qUgks0kVJ41OWMw==
X-Google-Smtp-Source: ABdhPJw3t6r8IVjjacJhqcwGbSY+bU8WtCM0OnfyiYq398XmBkL3ZXxwXC1Waak5Kp4ygE40KZKy3Q==
X-Received: by 2002:aa7:c459:: with SMTP id n25mr4066674edr.214.1611660058746;
        Tue, 26 Jan 2021 03:20:58 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:20:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 00/11] io_uring for-stable
Date:   Tue, 26 Jan 2021 11:16:59 +0000
Message-Id: <cover.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rebased on linux-5.10.y, stable tags added. The first was dropped
before, most of others make it right.

Pavel Begunkov (11):
  kernel/io_uring: cancel io_uring before task works
  io_uring: inline io_uring_attempt_task_drop()
  io_uring: add warn_once for io_uring_flush()
  io_uring: stop SQPOLL submit on creator's death
  io_uring: fix null-deref in io_disable_sqo_submit
  io_uring: do sqo disable on install_fd error
  io_uring: fix false positive sqo warning on flush
  io_uring: fix uring_flush in exit_files() warning
  io_uring: fix skipping disabling sqo on exec
  io_uring: dont kill fasync under completion_lock
  io_uring: fix sleeping under spin in __io_clean_op

 fs/file.c     |   2 -
 fs/io_uring.c | 119 +++++++++++++++++++++++++++++++++++---------------
 kernel/exit.c |   2 +
 3 files changed, 86 insertions(+), 37 deletions(-)

-- 
2.24.0

