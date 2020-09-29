Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C5927CAFA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgI2MXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8793C23BEC;
        Tue, 29 Sep 2020 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378882;
        bh=/6/ywuTfxFzeUl/jPNuDskh3E5Zhq0WW41vYUNDZ/jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ezw66t+TGK2i5dlYBg226eWUGnSE5hjyv8X6TA38X/RUk0TmEZYwrVcS01gMZMBto
         +b+Rw3DP/8P5DaHXzB2AsyX6+q3osxPcom8x844AsAeNU8HW6Ry5yVR89xh7HZLz4O
         PtUJjEBVJquD2JUTeet9rHG5Bb4xn5DDaGzMfItg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/245] scsi: qedi: Fix termination timeouts in session logout
Date:   Tue, 29 Sep 2020 12:59:54 +0200
Message-Id: <20200929105953.943335097@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit b9b97e6903032ec56e6dcbe137a9819b74a17fea ]

The destroy connection ramrod timed out during session logout.  Fix the
wait delay for graceful vs abortive termination as per the FW requirements.

Link: https://lore.kernel.org/r/20200408064332.19377-7-mrangankar@marvell.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 751941a3ed303..aa451c8b49e56 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1065,6 +1065,9 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		break;
 	}
 
+	if (!abrt_conn)
+		wait_delay += qedi->pf_params.iscsi_pf_params.two_msl_timer;
+
 	qedi_ep->state = EP_STATE_DISCONN_START;
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
 	if (ret) {
-- 
2.25.1



