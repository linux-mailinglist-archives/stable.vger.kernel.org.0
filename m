Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B91AC7A2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgDPO5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441757AbgDPNzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E81720786;
        Thu, 16 Apr 2020 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045347;
        bh=ME4yxp5YGUd5ExSL/7QlLZ37D4gGwITbqrkigSQi8gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AimuwJyWvj94JDYDLwT6bu+TTkqUb/ypDym35s+eeIuMk4WJzIkb7cWRx0oPVUh+w
         acuupU+zB/SW6ZFt0Q6n0JNTUSEqG3DmmiwXQc7jYkQlXeIP6kveTRGu94VBxpJT1y
         E4q9+1zamwy5hx7SzHqB3od8sEmjXJn3sBBd4bb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junyong Sun <sunjunyong@xiaomi.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 057/254] firmware: fix a double abort case with fw_load_sysfs_fallback
Date:   Thu, 16 Apr 2020 15:22:26 +0200
Message-Id: <20200416131333.038671964@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junyong Sun <sunjy516@gmail.com>

[ Upstream commit bcfbd3523f3c6eea51a74d217a8ebc5463bcb7f4 ]

fw_sysfs_wait_timeout may return err with -ENOENT
at fw_load_sysfs_fallback and firmware is already
in abort status, no need to abort again, so skip it.

This issue is caused by concurrent situation like below:
when thread 1# wait firmware loading, thread 2# may write
-1 to abort loading and wakeup thread 1# before it timeout.
so wait_for_completion_killable_timeout of thread 1# would
return remaining time which is != 0 with fw_st->status
FW_STATUS_ABORTED.And the results would be converted into
err -ENOENT in __fw_state_wait_common and transfered to
fw_load_sysfs_fallback in thread 1#.
The -ENOENT means firmware status is already at ABORTED,
so fw_load_sysfs_fallback no need to get mutex to abort again.
-----------------------------
thread 1#,wait for loading
fw_load_sysfs_fallback
 ->fw_sysfs_wait_timeout
    ->__fw_state_wait_common
       ->wait_for_completion_killable_timeout

in __fw_state_wait_common,
...
93    ret = wait_for_completion_killable_timeout(&fw_st->completion, timeout);
94    if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)
95       return -ENOENT;
96    if (!ret)
97	 return -ETIMEDOUT;
98
99    return ret < 0 ? ret : 0;
-----------------------------
thread 2#, write -1 to abort loading
firmware_loading_store
 ->fw_load_abort
   ->__fw_load_abort
     ->fw_state_aborted
       ->__fw_state_set
         ->complete_all

in __fw_state_set,
...
111    if (status == FW_STATUS_DONE || status == FW_STATUS_ABORTED)
112       complete_all(&fw_st->completion);
-------------------------------------------
BTW,the double abort issue would not cause kernel panic or create an issue,
but slow down it sometimes.The change is just a minor optimization.

Signed-off-by: Junyong Sun <sunjunyong@xiaomi.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/1583202968-28792-1-git-send-email-sunjunyong@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 8704e1bae1758..1e9c96e3ed636 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -525,7 +525,7 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
 	}
 
 	retval = fw_sysfs_wait_timeout(fw_priv, timeout);
-	if (retval < 0) {
+	if (retval < 0 && retval != -ENOENT) {
 		mutex_lock(&fw_lock);
 		fw_load_abort(fw_sysfs);
 		mutex_unlock(&fw_lock);
-- 
2.20.1



