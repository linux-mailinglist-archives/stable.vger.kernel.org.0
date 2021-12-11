Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E793A470F58
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbhLKAXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345411AbhLKAXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:23:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA77C061714;
        Fri, 10 Dec 2021 16:19:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 675F9B82A17;
        Sat, 11 Dec 2021 00:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBF9C00446;
        Sat, 11 Dec 2021 00:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639181980;
        bh=u5f6XFphIusdApSN346ZP2B5r9dJZ8MvqtKQyd6Kn8I=;
        h=From:To:Cc:Subject:Date:From;
        b=E4Idw+/Fne9A8BvAfoGbqjhdDHg6PoW6pzYebxunv1oqc12V8qhurNcS0w72VjWSG
         pgkD1ef4qOBh4WjN5cvOLc07cVsPVjRkmeYyubc2kkep7SEobP1N6Mb6t3h4edlz0H
         ntPM9oGv7MYqhKc7DcoTCYCZOIhEgtxizgJiUJQhSnTeAWse1909lI+cc+4p6oUPSt
         LNUzy/AMrcYS9uSuN67IB/rf6T5WvfA2y8ydjAUQxJgRuocaDIra3ch6BgTgJXcQkD
         lf/9SPwaQQpI1bUQYYx38/Vw21/mRcGcu84TLKwgS5eAMTipSI/bA5c1eH8mEENLaJ
         fBTKy3ScosfIA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 v2 0/3] POLLFREE fix for 4.14
Date:   Fri, 10 Dec 2021 16:19:23 -0800
Message-Id: <20211211001926.100856-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This kernel version doesn't have aio poll, but the fix for POLLFREE with
exclusive waiters is still applicable to it.  This series resolves
conflicts in all three patches, mostly due to POLLHUP having been
renamed to EPOLLHUP in more recent kernels.

v2: fix build break

Eric Biggers (3):
  wait: add wake_up_pollfree()
  binder: use wake_up_pollfree()
  signalfd: use wake_up_pollfree()

 drivers/android/binder.c | 21 +++++++++------------
 fs/signalfd.c            | 12 +-----------
 include/linux/wait.h     | 26 ++++++++++++++++++++++++++
 kernel/sched/wait.c      |  8 ++++++++
 4 files changed, 44 insertions(+), 23 deletions(-)

-- 
2.34.1

