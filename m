Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789E59E11A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfH0IED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbfH0IEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 277A4206BF;
        Tue, 27 Aug 2019 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893041;
        bh=EckM6EaT5wZqSIkZEo54Rgu+k2ypMTKdIE9vRi5T4LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vuizu/5aQTBxt1MzQcnG4Exlo7sMKG8rQWL6CY+RRZHu4v9oK9VswIaFwYZ+vzWFx
         fqlH6upaV0oz2JclAyb4fAxEcDI2nhPUIhr37qfgaf1fmibbSh5ADtayijFNC7jm9z
         PhGUjdB/iCre8HQlSUfAqnsNC5A2I/8nCxrKZBJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 098/162] libata: add SG safety checks in SFF pio transfers
Date:   Tue, 27 Aug 2019 09:50:26 +0200
Message-Id: <20190827072741.639793873@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
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
index 10aa278821427..4f115adb4ee83 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -658,6 +658,10 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	unsigned int offset;
 	unsigned char *buf;
 
+	if (!qc->cursg) {
+		qc->curbytes = qc->nbytes;
+		return;
+	}
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
@@ -683,6 +687,8 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	if (qc->cursg_ofs == qc->cursg->length) {
 		qc->cursg = sg_next(qc->cursg);
+		if (!qc->cursg)
+			ap->hsm_task_state = HSM_ST_LAST;
 		qc->cursg_ofs = 0;
 	}
 }
-- 
2.20.1



