Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7C18629F
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgCPCeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbgCPCeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 727082073C;
        Mon, 16 Mar 2020 02:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326090;
        bh=hcTIdJiCXvD/krcQTIT1ht5ObWgrP9GQXXZnj8Jlw7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVrWJWsf2thcl4fJ/bYAYPKJbgm0Y3chNwaVfoU3U+SPm5AND1KrVQ1zNVB2eflcX
         EI2xUmD8/Bau520OnUBZuDWD3BsECy++/cN4BWlS/77EfaWQrxchNEIXhMoVPEJZmk
         fT9ReKimjgRmjt84zkcCrsuy0GKSNUhzqLlzbfIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.4 33/35] xenbus: req->err should be updated before req->state
Date:   Sun, 15 Mar 2020 22:34:09 -0400
Message-Id: <20200316023411.1263-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 8130b9d5b5abf26f9927b487c15319a187775f34 ]

This patch adds the barrier to guarantee that req->err is always updated
before req->state.

Otherwise, read_reply() would not return ERR_PTR(req->err) but
req->body, when process_writes()->xb_write() is failed.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Link: https://lore.kernel.org/r/20200303221423.21962-2-dongli.zhang@oracle.com
Reviewed-by: Julien Grall <jgrall@amazon.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_comms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
index 852ed161fc2a7..eb5151fc8efab 100644
--- a/drivers/xen/xenbus/xenbus_comms.c
+++ b/drivers/xen/xenbus/xenbus_comms.c
@@ -397,6 +397,8 @@ static int process_writes(void)
 	if (state.req->state == xb_req_state_aborted)
 		kfree(state.req);
 	else {
+		/* write err, then update state */
+		virt_wmb();
 		state.req->state = xb_req_state_got_reply;
 		wake_up(&state.req->wq);
 	}
-- 
2.20.1

