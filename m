Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56391FF18F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfKPQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbfKPPsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:05 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5630420855;
        Sat, 16 Nov 2019 15:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919284;
        bh=+NB0s+LCRAxdroStWyCsfEPiUhK5zPehk0eeSME6j/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKJYyvff/NB5qVseErzFzLIn3+kEpIRFweDitfIBniWK11I/rN3uKQLTy2haPhQdi
         T17+VePeQaRU4FsB0ZxWoObvoPsMRIYhiuiv6q066IDxNjwB0fPkfDaDMX6ajyHLmT
         5NESn7UOfnkebIpf7ahFVWZS8oV8FjdED+bi3oYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 035/150] nvmet-fcloop: suppress a compiler warning
Date:   Sat, 16 Nov 2019 10:45:33 -0500
Message-Id: <20191116154729.9573-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1216e9ef18b84f4fb5934792368fb01eb3540520 ]

Building with W=1 enables the compiler warning -Wimplicit-fallthrough=3. That
option does not recognize the fall-through comment in the fcloop driver. Add
a fall-through comment that is recognized for -Wimplicit-fallthrough=3. This
patch avoids that the compiler reports the following warning when building
with W=1:

drivers/nvme/target/fcloop.c:647:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (op == NVMET_FCOP_READDATA)
      ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 0b0a4825b3eb1..096523d8dd422 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -535,6 +535,7 @@ fcloop_fcp_op(struct nvmet_fc_target_port *tgtport,
 			break;
 
 		/* Fall-Thru to RSP handling */
+		/* FALLTHRU */
 
 	case NVMET_FCOP_RSP:
 		if (fcpreq) {
-- 
2.20.1

