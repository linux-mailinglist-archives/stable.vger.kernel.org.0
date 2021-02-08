Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39CF313627
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBHPGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhBHPFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:05:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903BEC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:28 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g10so18525188eds.2
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwxE0e9ods3kzlYf6eMuljRX0kmoplvM9T4J3dzs0zk=;
        b=ItxofJRWftcBWyKLLUSiFKaaBK7caRXDDd74ZWc6PU0SI7y2zSoYwSTGayxAONKhcD
         Yc3ufoVvmdRhuG0qld1B9wnazqArawvYtu+KZw6hCpH6dZeWS5XZFXkgcs1yeF6e2rZA
         tcywSQQpYBhosI0pOlEsofdus1x8T2r9Xf6W1UTY0HU+3xSZS8e0FAYNCfIs7uR1hN4r
         Ur2UD1zU8NyY2CL+F9VQ5oUMqm4XKRM6ZVVlcw8wFUgHrJ+eDowNBoipMIzqlfiQ+z3w
         Dy08ObEQf94Mc9YXo8h66Q4qqm4IPFPbH7Witf1mZjzINHBqTLfUBdz9yXM52xhYrCPc
         fzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwxE0e9ods3kzlYf6eMuljRX0kmoplvM9T4J3dzs0zk=;
        b=VsB0pVGJSL/2daUINZ9MzKmzR4oi7Wdv9TtdL3q4KlZA8HM5vmbOWn1uEIbvRQ7HQo
         eCzPhm1h6I/hgl956HvPJgwABPDlkVmjzjuWzgXwOGc4H/FJSVAgnMXi3QrEZ9kQPBKD
         lfPgqWcRZe1WwDHff8DFlxefx7KP05Y/TjXOzJ1ofMoRP/OgD4mF/yIPXnuaP+5sbGNi
         RXeUIp3+IteIu/z7MjNXjGLv001LVsp4oc6psEMiqxyhaoKKnm1aG4RTAkAily29QZup
         sRtrelaNztW6LXlDtsVz5zNTXgRXbOXIFy2EuMFmiLkY7DffhS8QepzEvXPaDllyCAhg
         /K1g==
X-Gm-Message-State: AOAM530CaKTTs+JzCDfudSpwZkWQid+X2gowEAGgmFXkID1rO1/CtQg0
        im7I+bGL/MPdajrgBzHeKkxv8NgKBVtihQ==
X-Google-Smtp-Source: ABdhPJzhsRHiv0SaD9+Mw/lUalxCE+hc31yJ5qm+awwkPpUxCBMtj7LjeHLDVDX65f/CYrVEG/94Bw==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr17515984edt.152.1612796667356;
        Mon, 08 Feb 2021 07:04:27 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:26 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Subject: [stable-4.19 Resend 0/7] block layer bugfix
Date:   Mon,  8 Feb 2021 16:04:19 +0100
Message-Id: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha,

Please consider to include following fixes in to stable tree.
The 6 patches from Ming was fixing a deadlock, they are included around kernel
5.3/4. Would be good to included in 4.19, we hit it during testing, with the fix
we no longer hit the deadlock.

The last one is simple NULL pointer deref fix.

Thanks!
Jack Wang @ IONOS Cloud.


v1: https://lore.kernel.org/stable/20210203132022.92406-1-jinpu.wang@cloud.ionos.com/

Ming Lei (6):
  block: don't hold q->sysfs_lock in elevator_init_mq
  blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue
  block: add helper for checking if queue is registered
  block: split .sysfs_lock into two locks
  block: fix race between switching elevator and removing queues
  block: don't release queue's sysfs lock during switching elevator

zhengbin (1):
  block: fix NULL pointer dereference in register_disk

 block/blk-core.c       |  1 +
 block/blk-mq-sysfs.c   | 12 +++++------
 block/blk-mq.c         |  7 ------
 block/blk-sysfs.c      | 49 +++++++++++++++++++++++++++---------------
 block/blk-wbt.c        |  2 +-
 block/blk.h            |  2 +-
 block/elevator.c       | 44 +++++++++++++++++++++----------------
 block/genhd.c          | 10 +++++----
 include/linux/blkdev.h |  2 ++
 9 files changed, 74 insertions(+), 55 deletions(-)

-- 
2.25.1

