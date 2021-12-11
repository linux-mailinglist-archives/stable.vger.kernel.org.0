Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC9470F20
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhLKAGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhLKAGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:06:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C8C061714;
        Fri, 10 Dec 2021 16:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7099CE23DC;
        Sat, 11 Dec 2021 00:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEECC00446;
        Sat, 11 Dec 2021 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180948;
        bh=3En8TRGK9r1qH3Kzt5Uw807s3JtslZYOfinK8dmovTE=;
        h=From:To:Cc:Subject:Date:From;
        b=VTzqawuz544jCOinRb+i8/cntvr/FRaV9CBWK9B0+DyeYVw+3OymuKDIBUteye2bp
         0xc3ZOjL4T15UCZ/ZgQZqLCzs3KhgppKiVE/oKS+umRpJH1TZl4MnboClbu3aR3W7Z
         zzovul8L8MZL8EWABPcSCKUFkGUVTdxTjOnzQyeRWnJUsp+OjFoRaAux857PrNKLfT
         gPLjUDnq2nbo4tPi8+eEisGtR9EGxK8dcS06vTnA/Baq6hI7GtFqb2N+cn11uewZMN
         SSBTx+QAzCdzBwsrQ4TbVLRAbxTH7X8eF6GzpZOEfOU5T6POiksv7Uy5JmoPAqe9FE
         PR0Iaqft53DOA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 0/3] POLLFREE fix for 4.14
Date:   Fri, 10 Dec 2021 16:02:20 -0800
Message-Id: <20211211000223.50630-1-ebiggers@kernel.org>
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

Eric Biggers (3):
  wait: add wake_up_pollfree()
  binder: use wake_up_pollfree()
  signalfd: use wake_up_pollfree()

 drivers/android/binder.c | 21 +++++++++------------
 fs/signalfd.c            | 12 +-----------
 include/linux/wait.h     | 26 ++++++++++++++++++++++++++
 kernel/sched/wait.c      |  7 +++++++
 4 files changed, 43 insertions(+), 23 deletions(-)

-- 
2.34.1

