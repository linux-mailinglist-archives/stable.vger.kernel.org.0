Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2485C1F2D26
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgFHXPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgFHXPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 927EA2068D;
        Mon,  8 Jun 2020 23:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658136;
        bh=VTDinPnBrTtWYq9r2jdfYIPmKUtkIW3BFWKhAo5czcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVcZRaokaH4XiXkR6gIRcOeyV4iiXskc6LDfjWcRgBghFemcnwgOzcmWaXyP1XFMa
         hdJjAqhgStJ0RKry+IOdkgweXVwYsyFf7XmF+D3zwjxGASaDdq7MHQFTz4vuR4eWjR
         t6I69BPyk09evXCC5ruIV7T1yKLza9zJLu4WtCeo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.6 170/606] staging: wfx: unlock on error path
Date:   Mon,  8 Jun 2020 19:04:55 -0400
Message-Id: <20200608231211.3363633-170-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f0b9d875faa4499afe3381404c3795e9da84bc00 upstream.

We need to release the tx_lock on the error path before returning.

Fixes: d1c015b4ef6f ("staging: wfx: rewrite wfx_hw_scan()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200512083656.GA251760@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wfx/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/scan.c b/drivers/staging/wfx/scan.c
index 6e1e50048651..9aa14331affd 100644
--- a/drivers/staging/wfx/scan.c
+++ b/drivers/staging/wfx/scan.c
@@ -57,8 +57,10 @@ static int send_scan_req(struct wfx_vif *wvif,
 	wvif->scan_abort = false;
 	reinit_completion(&wvif->scan_complete);
 	timeout = hif_scan(wvif, req, start_idx, i - start_idx);
-	if (timeout < 0)
+	if (timeout < 0) {
+		wfx_tx_unlock(wvif->wdev);
 		return timeout;
+	}
 	ret = wait_for_completion_timeout(&wvif->scan_complete, timeout);
 	if (req->channels[start_idx]->max_power != wvif->vif->bss_conf.txpower)
 		hif_set_output_power(wvif, wvif->vif->bss_conf.txpower);
-- 
2.25.1

