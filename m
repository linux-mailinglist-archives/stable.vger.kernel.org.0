Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD3431EC6
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhJROFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhJROBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D3B6147F;
        Mon, 18 Oct 2021 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564568;
        bh=PWW+rabaX/wNvoiL7AcF8POQE8b0xp3dMVs2LjsWSe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgA1sK0HDgwAuh0lXBPJpTlOmLH86UwHuQwXeefRVXAmA4mKuo4otSd6aw6egxCiH
         fJvcJ9eUt0VuDTlPjydPtk7t1wspndTIMWnSyKGOUrsVkqrseuz/LacAhDWcyLTEZV
         uOyCWVHOO2L/rT1R1yqzpKVUJ60pDu1t6glriI+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 137/151] platform/x86: intel_scu_ipc: Fix busy loop expiry time
Date:   Mon, 18 Oct 2021 15:25:16 +0200
Message-Id: <20211018132345.119870795@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

commit 41512e4dc0b84525495e784295092592adb87f1b upstream.

The macro IPC_TIMEOUT is already in jiffies (it is also used like that
elsewhere in the file when calling wait_for_completion_timeout()). Don’t
convert it using helper functions for the purposes of calculating the
busy loop expiry time.

Fixes: e7b7ab3847c9 (“platform/x86: intel_scu_ipc: Sleeping is fine when polling”)
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20210928101932.2543937-2-pmalani@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel_scu_ipc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -232,7 +232,7 @@ static inline u32 ipc_data_readl(struct
 /* Wait till scu status is busy */
 static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 {
-	unsigned long end = jiffies + msecs_to_jiffies(IPC_TIMEOUT);
+	unsigned long end = jiffies + IPC_TIMEOUT;
 
 	do {
 		u32 status;


