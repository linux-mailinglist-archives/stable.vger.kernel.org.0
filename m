Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821EB470F74
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345485AbhLKAc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345462AbhLKAcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:32:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAFAC061714;
        Fri, 10 Dec 2021 16:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EB85CE2D90;
        Sat, 11 Dec 2021 00:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734E1C00446;
        Sat, 11 Dec 2021 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182523;
        bh=jzBMp5xsPD7T+GwkPn09XxHQEaj1INTn73Pbxg5DvoI=;
        h=From:To:Cc:Subject:Date:From;
        b=uyTk/3l+2lH2DLutaHf70/iBnFv8/3liB4/KerGhtTsaoYOmag2l9KQh5mfuHfsSx
         E5lzbe2yzNDsJqRCcxm8UEJM2t8jd9ownUzuJorGfPK6oot79hfO5kDab+zkjVo167
         PUrAuctjTSIkdUY7K8PPsviRBg/SUX/VQa52J4BiFIK3VW5tcDhm8BgnCD3Vg4MKyO
         4Ch3G7Qp8K0lF6Aq4RiAhTRcqCgSBNXPLWxsjzBvzNi5d8Hy6Dexx6NX4yCb/85ADr
         npYdaeGcP2vFlnG8aK+Tj3echntECBI1yaTvLkU5JMsfQJzdu3nT5hhO5+vCz0IBGP
         HyyMwvN9dC8IA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 4.4,4.9 0/3] POLLFREE fix for 4.4 and 4.9
Date:   Fri, 10 Dec 2021 16:28:29 -0800
Message-Id: <20211211002832.153742-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply to 4.4 and 4.9.

These kernel versions don't have aio poll, but the fix for POLLFREE with
exclusive waiters is still applicable to them.  This series resolves
conflicts in all three patches, mostly due to POLLHUP and
wait_queue_head_t having been renamed in more recent kernels.

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

