Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9DC2270AA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGTVic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgGTVib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2547122BEF;
        Mon, 20 Jul 2020 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281110;
        bh=QlJkFwDJkzmfzhz04rreCmj24sWmHkSIJ4GeGx6smRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vq+PFlSSf7NXoPXgYyvgC6QGtzRzXWcIniSmwM8C/FIYR8aHdEAygZhc6504iW8xG
         SuQbaiLr2Zam4wmWbQm5w1M/lQH5cz1EO5yRw8iVIccIWjmnQs8SRRR1wOZtzuXzCg
         hvm8hKFyWP1VtnIoAms9Dxliyr6ow49061BkXmUI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, kbuild test robot <lkp@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/34] usb: cdns3: trace: fix some endian issues
Date:   Mon, 20 Jul 2020 17:37:52 -0400
Message-Id: <20200720213807.407380-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 65b7cf48c211ece5e2560a334eb9608e48775a8f ]

It is found by sparse.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/trace.h b/drivers/usb/cdns3/trace.h
index 7cc8bebaa07da..f8482456116e8 100644
--- a/drivers/usb/cdns3/trace.h
+++ b/drivers/usb/cdns3/trace.h
@@ -333,9 +333,9 @@ DECLARE_EVENT_CLASS(cdns3_log_trb,
 	TP_fast_assign(
 		__assign_str(name, priv_ep->name);
 		__entry->trb = trb;
-		__entry->buffer = trb->buffer;
-		__entry->length = trb->length;
-		__entry->control = trb->control;
+		__entry->buffer = le32_to_cpu(trb->buffer);
+		__entry->length = le32_to_cpu(trb->length);
+		__entry->control = le32_to_cpu(trb->control);
 		__entry->type = usb_endpoint_type(priv_ep->endpoint.desc);
 	),
 	TP_printk("%s: trb %p, dma buf: 0x%08x, size: %ld, burst: %d ctrl: 0x%08x (%s%s%s%s%s%s%s)",
-- 
2.25.1

