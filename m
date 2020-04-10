Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DAE1A3FB4
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgDJDuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbgDJDuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:50:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2545121841;
        Fri, 10 Apr 2020 03:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490635;
        bh=ZcpYVsCP/XLAJuphgVNQRaUYJF/lasso5Ft3WcK6x/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDzq4+GD9r5JgmiEeSqJBkQLRYksw7ByL1v+AjddmFuIGrbBgFtmNTvi1doXCOcNr
         ASa2/DhVESFhWil0kPTbQTmIai7ooLEYPVM3tfp96vYh/49trTnK1VRxKwVZXjiXc+
         vGE0mHePOLH+HeSPZMhRM+M5Xv+g7kfvSw7tNVuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junyong Sun <sunjy516@gmail.com>,
        Junyong Sun <sunjunyong@xiaomi.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 26/32] firmware: fix a double abort case with fw_load_sysfs_fallback
Date:   Thu,  9 Apr 2020 23:49:59 -0400
Message-Id: <20200410035005.9371-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410035005.9371-1-sashal@kernel.org>
References: <20200410035005.9371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 818d8c37d70a9..3b7b748c4d4f2 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -572,7 +572,7 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
 	}
 
 	retval = fw_sysfs_wait_timeout(fw_priv, timeout);
-	if (retval < 0) {
+	if (retval < 0 && retval != -ENOENT) {
 		mutex_lock(&fw_lock);
 		fw_load_abort(fw_sysfs);
 		mutex_unlock(&fw_lock);
-- 
2.20.1

