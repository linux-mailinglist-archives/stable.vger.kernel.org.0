Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF2A8EB0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbfIDR72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbfIDR72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:59:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C017621883;
        Wed,  4 Sep 2019 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619967;
        bh=2g1bI4KN1ApHiOeyVHDMfszUuoz6nRsnAGam2R0nwMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4JIfQACoxeO7FoDWtR62UsHlm+B1CMLlhgETBvShS6LsJAb/X9wE/+S/gCqf4i3z
         OsW4PFruXl1y1LSWMEsGENX3FYXpWm1Goekt5cjAIELx9Nozou9V3EU0C9nsQIw6T5
         WPuRVLIiz0YW8JHBuivcwyUAkD04N2UizysU5ym0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/83] libata: add SG safety checks in SFF pio transfers
Date:   Wed,  4 Sep 2019 19:53:15 +0200
Message-Id: <20190904175305.914660523@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
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
index 8d22acdf90f0b..0e2bc5b9a78c1 100644
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



