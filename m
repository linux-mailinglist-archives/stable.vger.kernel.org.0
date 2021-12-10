Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F74470EF9
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243912AbhLJXzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbhLJXzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:55:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E68C0617A1;
        Fri, 10 Dec 2021 15:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22714B82A0F;
        Fri, 10 Dec 2021 23:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE47BC00446;
        Fri, 10 Dec 2021 23:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180303;
        bh=Uky6D3L2BZR49fw/XMQCNxNZEbfAKzlYDE70XDMFpKc=;
        h=From:To:Cc:Subject:Date:From;
        b=OlwiqIkkGZAjJHTzTqL3pEMm34pKrcwSKbkL9AZSWRY9rnTREUGC2eR94+jnkfoE3
         n8FrRVxKW5Ati13IBVXiDGi9MI1ZB0uHMD1tgXt4rSsIKtPyzQdouo+WVq5d2bM53X
         6CtokHPC8BqpAUuZ9fUIDXQPBNQv5hOcJGe8Q0TSIxttjeDoRrcsAYkNN5Vc7U42Cw
         3xhpOCQ7fZrkLzRvejzut7rdhh5IeKvuIGrBq54XTpQwnfJLyFUDNScYNXFF+QK2Ha
         0k8AlbLUhYJ43zLTXrBGxSgaUK8RSqtc8EIhF4rOlFBrxaIFeENtJsPYN3MX/ZPQFa
         Kfn6HFub9azZQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 0/5] aio poll fixes for 5.4
Date:   Fri, 10 Dec 2021 15:50:49 -0800
Message-Id: <20211210235054.40103-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the aio poll fixes to 5.4.  This resolves conflicts in patches
1 and 4.  They are "trivial" conflicts, but I'm sending this to make
sure patches don't get dropped.

Eric Biggers (5):
  wait: add wake_up_pollfree()
  binder: use wake_up_pollfree()
  signalfd: use wake_up_pollfree()
  aio: keep poll requests on waitqueue until completed
  aio: fix use-after-free due to missing POLLFREE handling

 drivers/android/binder.c        |  21 ++--
 fs/aio.c                        | 184 ++++++++++++++++++++++++++------
 fs/signalfd.c                   |  12 +--
 include/linux/wait.h            |  26 +++++
 include/uapi/asm-generic/poll.h |   2 +-
 kernel/sched/wait.c             |   7 ++
 6 files changed, 195 insertions(+), 57 deletions(-)

-- 
2.34.1

