Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CB73BFC
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405706AbfGXUDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405699AbfGXUDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47FA214AF;
        Wed, 24 Jul 2019 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998602;
        bh=Ex8sdjT459ZaGTa7Tf/mq4wHaSFlpZiJDjcTXb9NDJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+/0ZhfhalFvFJB0Op35ad+ZqadvSTnJj/OIDfB9y6s9JK+YV1Hew4Z/1gfR+DE0Y
         godQN3EVW7wn9RlYL/PZmnPF5Wktmt/ZvRtsqrD7Oq0yr7dU9ucdX1YK+DmMy1eAqo
         OA80E+aPbbL1LX6It+aT4L24Y7NSwbh03bG/Ca88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/271] RAS/CEC: Fix pfn insertion
Date:   Wed, 24 Jul 2019 21:18:40 +0200
Message-Id: <20190724191659.526723066@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d8e294bf5f0e85c34e8b14b064e2965f53f38b0 ]

When inserting random PFNs for debugging the CEC through
(debugfs)/ras/cec/pfn, depending on the return value of pfn_set(),
multiple values get inserted per a single write.

That is because simple_attr_write() interprets a retval of 0 as
success and claims the whole input. However, pfn_set() returns the
cec_add_elem() value, which, if > 0 and smaller than the whole input
length, makes glibc continue issuing the write syscall until there's
input left:

  pfn_set
  simple_attr_write
  debugfs_attr_write
  full_proxy_write
  vfs_write
  ksys_write
  do_syscall_64
  entry_SYSCALL_64_after_hwframe

leading to those repeated calls.

Return 0 to fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ras/cec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index f85d6b7a1984..5d2b2c02cbbe 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -369,7 +369,9 @@ static int pfn_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
 
-	return cec_add_elem(val);
+	cec_add_elem(val);
+
+	return 0;
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(pfn_ops, u64_get, pfn_set, "0x%llx\n");
-- 
2.20.1



