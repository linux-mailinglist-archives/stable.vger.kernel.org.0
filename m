Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A506720DA6F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgF2T5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387646AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A7E2487B;
        Mon, 29 Jun 2020 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444377;
        bh=7Bk9ZxxCMy936t5uvireMWAe3g6G4GcYr2AKjQrRcZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ7i3k3z8AL5eYkXnb18n154xa3MEzhT1kLTq50sZogCcursFN1uqjtEnqeFp+pjI
         b0cOUh31xUa6yjU9Z89awHI6sL+1jSnRPLtAwZxHJvgk8P8H8HSfochfOREbHsQPqR
         Bcr77zeeUMrClCn3Ept4KWzRy4DjvQ1wXCKbgI3Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 054/178] xhci: Fix incorrect EP_STATE_MASK
Date:   Mon, 29 Jun 2020 11:23:19 -0400
Message-Id: <20200629152523.2494198-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index 23a1abdc2b43c..c656b41b57b5a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -716,7 +716,7 @@ struct xhci_ep_ctx {
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

