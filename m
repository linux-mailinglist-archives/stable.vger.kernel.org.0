Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06F20DF2B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbgF2Ucv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732400AbgF2TZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92AB82544B;
        Mon, 29 Jun 2020 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445400;
        bh=n+cUBZCrIf+GYJLnVnt3+i5W6LAp8t1afFp1UK6ngXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjDQYTuiH+k0yrdxzqg54HkZNtydEEsY6uEIwzkkQNBLP42QMwaNOETsiBIMjDvX+
         +kgt0wyqtPvJ0K+XZoFFt925EMqKMLH0yknLSzGcZnhC16b+GAiwMJbgyU0iLlIrr0
         CmhFAFMegPTp1li4J5oAFbcyRr05m381t+oOo3W0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 152/191] xhci: Fix incorrect EP_STATE_MASK
Date:   Mon, 29 Jun 2020 11:39:28 -0400
Message-Id: <20200629154007.2495120-153-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit dceea67058fe22075db3aed62d5cb62092be5053 upstream.

EP_STATE_MASK should be 0x7 instead of 0xf

xhci spec 6.2.3 shows that the EP state field in the endpoint context data
structure consist of bits [2:0].
The old value included a bit from the next field which fortunately is a
 RsvdZ region. So hopefully this hasn't caused too much harm

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200624135949.22611-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 2b603ef5c10cd..2b8df83dad38d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -709,7 +709,7 @@ struct xhci_ep_ctx {
  * 4 - TRB error
  * 5-7 - reserved
  */
-#define EP_STATE_MASK		(0xf)
+#define EP_STATE_MASK		(0x7)
 #define EP_STATE_DISABLED	0
 #define EP_STATE_RUNNING	1
 #define EP_STATE_HALTED		2
-- 
2.25.1

