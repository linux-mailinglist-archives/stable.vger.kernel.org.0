Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2AAA8E61
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732926AbfIDR5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbfIDR5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B2621883;
        Wed,  4 Sep 2019 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619860;
        bh=54VtRoqU8kvRGwbrBOQmMbSEAWo9D7ld9pRs7Lg+DvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3Wv9BUfyZcTp6e6CCaE+msozJ+63A1a+LlErdHMg8nBEZ2PEKYiKByuEattDHiID
         Ta9Yfhv7y3RYjOe3cekXCaW/zhq3umDb8Quwya+pBwXfktuxLnvfY4P9PEhDNtg4lI
         4FnP4uY8YzsgalzerVbPiSaRrr8boCczbQ5jJfMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/77] libata: add SG safety checks in SFF pio transfers
Date:   Wed,  4 Sep 2019 19:53:08 +0200
Message-Id: <20190904175305.616064032@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 752ead44491e8c91e14d7079625c5916b30921c5 ]

Abort processing of a command if we run out of mapped data in the
SG list. This should never happen, but a previous bug caused it to
be possible. Play it safe and attempt to abort nicely if we don't
have more SG segments left.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 18de4c4570682..1d8901fc0bfa9 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -703,6 +703,10 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	unsigned int offset;
 	unsigned char *buf;
 
+	if (!qc->cursg) {
+		qc->curbytes = qc->nbytes;
+		return;
+	}
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
@@ -742,6 +746,8 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	if (qc->cursg_ofs == qc->cursg->length) {
 		qc->cursg = sg_next(qc->cursg);
+		if (!qc->cursg)
+			ap->hsm_task_state = HSM_ST_LAST;
 		qc->cursg_ofs = 0;
 	}
 }
-- 
2.20.1



