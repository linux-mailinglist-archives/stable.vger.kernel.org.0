Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A681D1B0A99
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgDTMtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbgDTMtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200B6206DD;
        Mon, 20 Apr 2020 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386962;
        bh=rN6wlFe+icorxdHQwTv0cOLWEEiJVGC9O4Yn7RUxwm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUStb9IcPsHzhNCvsMn+/BTmnr0CFAt5e2kIQkcpy3vHRPrbsqapMhJKuK3GuxSrg
         rqon8rHCwsFMlJMaqzamQw0ODR5uT4TOlzL1i0H7ufukO3hc3twAey2G0IANCbLTIy
         XuJWuu4NvoNsr+kbkpaGbfAZNlfCMarTbFAToMb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 37/40] wil6210: add general initialization/size checks
Date:   Mon, 20 Apr 2020 14:39:47 +0200
Message-Id: <20200420121506.939424790@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

commit ac0e541ab2f2951845acee784ef487be40fb4c77 upstream.

Initialize unset variable, and verify that mid is valid.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/wil6210/debugfs.c |    2 ++
 drivers/net/wireless/ath/wil6210/wmi.c     |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -991,6 +991,8 @@ static ssize_t wil_write_file_txmgmt(str
 	int rc;
 	void *frame;
 
+	memset(&params, 0, sizeof(params));
+
 	if (!len)
 		return -EINVAL;
 
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2802,7 +2802,7 @@ static void wmi_event_handle(struct wil6
 
 		if (mid == MID_BROADCAST)
 			mid = 0;
-		if (mid >= wil->max_vifs) {
+		if (mid >= ARRAY_SIZE(wil->vifs) || mid >= wil->max_vifs) {
 			wil_dbg_wmi(wil, "invalid mid %d, event skipped\n",
 				    mid);
 			return;


