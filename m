Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60685470EE8
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345243AbhLJXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbhLJXwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:52:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB461C061746;
        Fri, 10 Dec 2021 15:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE0FCCE2D88;
        Fri, 10 Dec 2021 23:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D0C341C8;
        Fri, 10 Dec 2021 23:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180119;
        bh=GVD9TGo1OE5VtZ17pyC/avupagXhqtAvC4VF7VRRvqE=;
        h=From:To:Cc:Subject:Date:From;
        b=PI7keXy6kkCFDHq5vTinedj59Gas1oBQ/oukE5UcA/pKjOpTrQ1nN+EZDy7l1zhIT
         ll7NT32OpYpeXLWknHZ1axRWVohpI8VfNT8ubEiksmvcmuDNwFBMsQKSRfgupN/uhL
         Mz8j8mOKyXWiqFc//79/xfJsruJMZCTwzIwBD1b8ZxLCG/g703WTVtCbp0VMIJWd4s
         elkFR07+UZ/5Rpiv2Co5RuvO+EW4q6zb9c+XtuuCA9jo49QhKAe9viT4ibywLUCYXw
         SOKvwFBob/XKPdr6x96TMgYIu/B+ItxCZzi43A2rBzjnkdNvv1os0Bbd2iYHTclVdd
         b1IrEcldC77pw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 5.10 0/5] aio poll fixes for 5.10
Date:   Fri, 10 Dec 2021 15:48:00 -0800
Message-Id: <20211210234805.39861-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the aio poll fixes to 5.10.  This resolves a conflict in
aio_poll_wake() in patch 4.  It's a "trivial" conflict, but I'm sending
this to make sure it doesn't get dropped.

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

