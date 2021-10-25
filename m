Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3E43A318
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhJYT4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238798AbhJYTxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFAE6120A;
        Mon, 25 Oct 2021 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191074;
        bh=ChXNWeczelwUzM07pjU2vWpuvopvMV4am2bogYTA/W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxttRxSSHDLpsacvYFnb7unytczcWFt+fejrcw+TejAW2oLl5nz7U+5HNYOJT/n4y
         dbacofOrlnY8kp6zugoJeWCxy/qAhgbYFQJ8Qza/yOUUB1Sw+j1YSyOvSnf0QjKzTC
         8pvc/UrRuV6sQbNWDxSSqGTeQu5nwDQGbqNxTqmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 139/169] platform/x86: intel_scu_ipc: Increase virtual timeout to 10s
Date:   Mon, 25 Oct 2021 21:15:20 +0200
Message-Id: <20211025191035.205405977@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 5c02b581ce84eea240d25c8318a1f65133a04415 ]

Commit a7d53dbbc70a ("platform/x86: intel_scu_ipc: Increase virtual
timeout from 3 to 5 seconds") states that the recommended timeout range
is 5-10 seconds. Adjust the timeout value to the higher of those i.e 10
seconds, to account for situations where the 5 seconds is insufficient
for disconnect command success.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20210928101932.2543937-3-pmalani@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 25b98b12439f..daf199a9984b 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -75,7 +75,7 @@ struct intel_scu_ipc_dev {
 #define IPC_READ_BUFFER		0x90
 
 /* Timeout in jiffies */
-#define IPC_TIMEOUT		(5 * HZ)
+#define IPC_TIMEOUT		(10 * HZ)
 
 static struct intel_scu_ipc_dev *ipcdev; /* Only one for now */
 static DEFINE_MUTEX(ipclock); /* lock used to prevent multiple call to SCU */
-- 
2.33.0



