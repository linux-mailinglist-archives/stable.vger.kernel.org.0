Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4139431CEF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhJRNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhJRNoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A66615A2;
        Mon, 18 Oct 2021 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564106;
        bh=gg5zbCoLkAUDPeZuF+J83cdG60cdoGIwWITkWnl0mQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzoAXzVqPuoGhcrGOGe4zpGcJQwlSL5AQmV4SEFIbWVeftLXOqCPIaP8dSekE17i4
         rZIc/r3jHqatGm3lmNYfBdWpHXlJUcE7uozfpE3wL0s0i78UvdCzXSkgGTWnRUNkiy
         JsQPhR8QxpTLt13vbGNzNT3k2JLH/NWrJN6H1P+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 067/103] nvme-pci: Fix abort command id
Date:   Mon, 18 Oct 2021 15:24:43 +0200
Message-Id: <20211018132336.995230343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 85f74acf097a63a07f5a7c215db6883e5c35e3ff upstream.

The request tag is no longer the only component of the command id.

Fixes: e7006de6c2380 ("nvme: code command_id with a genctr for use-after-free validation")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1342,7 +1342,7 @@ static enum blk_eh_timer_return nvme_tim
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abort.opcode = nvme_admin_abort_cmd;
-	cmd.abort.cid = req->tag;
+	cmd.abort.cid = nvme_cid(req);
 	cmd.abort.sqid = cpu_to_le16(nvmeq->qid);
 
 	dev_warn(nvmeq->dev->ctrl.device,


