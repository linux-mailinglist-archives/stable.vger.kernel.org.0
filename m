Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8979994
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbfG2TZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388281AbfG2TZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:25:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1B920C01;
        Mon, 29 Jul 2019 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428320;
        bh=Tu2SmrOsQqUe9ACAyBEFF/lSAeSN+5gPhxezGHmRkwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlyfkWeStX+XCQuHAenWfRWAXcKIc9lltneRO5Ai8XGaWSD6byFIfarKqGGmYXkwH
         P9wWTJ5n0gJwYqSp5mXpc7pc7cU4LhXXjfn4/44kwXxzxGpcNHw7BLQU8cpETtciV6
         ufpiesH9HBj9PT8Whi/4zAngSG7chTganyeYIbUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/293] RAS/CEC: Fix pfn insertion
Date:   Mon, 29 Jul 2019 21:18:49 +0200
Message-Id: <20190729190825.269610232@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index c7205cdcc11a..97cf40a522be 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -373,7 +373,9 @@ static int pfn_set(void *data, u64 val)
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



