Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E06133476
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgAGU7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgAGU7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F02DB214D8;
        Tue,  7 Jan 2020 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430751;
        bh=E30sFues24HlCjY1fOZNux+zdrKpYpbad432urrigyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0L3LptXFjBlPUvgYtBpMv1LwT+rhA/NrmG0H/ScOx2DXdZKnAyN4JxQx9QOAhDHr
         zQNlSkfpUrYTyH4mU/WP+L3hhEiZ0R/F9SkuurIRRL3glSW0SBhik2VIiCkUtx4pZ6
         aZlzxIrj+Fblqtx3L2R0t0YnK0/KvBxw3bxAcsFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 080/191] media: cec: CEC 2.0-only bcast messages were ignored
Date:   Tue,  7 Jan 2020 21:53:20 +0100
Message-Id: <20200107205337.264248888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit cec935ce69fc386f13959578deb40963ebbb85c3 upstream.

Some messages are allowed to be a broadcast message in CEC 2.0
only, and should be ignored by CEC 1.4 devices.

Unfortunately, the check was wrong, causing such messages to be
marked as invalid under CEC 2.0.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/cec-adap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1083,11 +1083,11 @@ void cec_received_msg_ts(struct cec_adap
 			valid_la = false;
 		else if (!cec_msg_is_broadcast(msg) && !(dir_fl & DIRECTED))
 			valid_la = false;
-		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST1_4))
+		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST))
 			valid_la = false;
 		else if (cec_msg_is_broadcast(msg) &&
-			 adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0 &&
-			 !(dir_fl & BCAST2_0))
+			 adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0 &&
+			 !(dir_fl & BCAST1_4))
 			valid_la = false;
 	}
 	if (valid_la && min_len) {


