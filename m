Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35EE470F09
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhLJX52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhLJX52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:57:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CD4C061746;
        Fri, 10 Dec 2021 15:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28913B810CC;
        Fri, 10 Dec 2021 23:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB764C00446;
        Fri, 10 Dec 2021 23:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180429;
        bh=GhO/sFzXCebzBLx1WtjkV1rIPOeuSKA/DzfKOBNPwqo=;
        h=From:To:Cc:Subject:Date:From;
        b=cETmIBQP4LfMZq/24Tkv4BMzAZTFweR1fwOj9nXHPCL7OkZ+p7Mc0XUUWg2RGgHrD
         w85B6ODiz/ibc5mEWe72gBArvgpzG8+7/XDye5FY/x1wPww3DrQ4E0pkhB0u+lyUiJ
         QF1xJn4kYzIVyNyZNHggDomp29ysU9gsjkLLaSsGUIRVYCV+JVKZnXBn5iKQr3yjfd
         WnLIKQoG1Hxfzlhk6WPzPatmuymiIM0eTiztFDV2IwBz8QlIzthwT7agnlfTjuf9Jh
         AQ4ChtQg2CINAev/z+BQichiejHeWX6SfYNF1sspO2i7Ca/MiE+48qtxZIIKUDO4CG
         kxEVeMIrzbQdQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 0/5] aio poll fixes for 4.19
Date:   Fri, 10 Dec 2021 15:53:07 -0800
Message-Id: <20211210235312.40412-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the aio poll fixes to 4.19.  This resolves conflicts in patches
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

