Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69A4431E46
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhJRN7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233694AbhJRN5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A76F6138B;
        Mon, 18 Oct 2021 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564462;
        bh=VybyTtxfkLbJJLoQqeiB7YIRwkUh6Xc42xiBXu4NZGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxmtCRwFhPajx4n5F9Fviv5TaROfeU/QNfe1C4R1gLncOCiwRzuz8ygNfJmUAIMdC
         otrrI2cGTTF1bBFqI9RUySryEwNibPu3rjDshuKi9CGRkpNeL7H4Xynj8a24DxasWK
         QosFNbddJQ22elDjBvNvdIO+0g9lCegfgIEXM9Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.14 097/151] nvme-pci: Fix abort command id
Date:   Mon, 18 Oct 2021 15:24:36 +0200
Message-Id: <20211018132343.825552678@linuxfoundation.org>
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
@@ -1331,7 +1331,7 @@ static enum blk_eh_timer_return nvme_tim
 	iod->aborted = 1;
 
 	cmd.abort.opcode = nvme_admin_abort_cmd;
-	cmd.abort.cid = req->tag;
+	cmd.abort.cid = nvme_cid(req);
 	cmd.abort.sqid = cpu_to_le16(nvmeq->qid);
 
 	dev_warn(nvmeq->dev->ctrl.device,


