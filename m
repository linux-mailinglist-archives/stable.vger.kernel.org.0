Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1ACA73F2F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388336AbfGXTbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388188AbfGXTbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA40221951;
        Wed, 24 Jul 2019 19:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996690;
        bh=iEmGSmB5deUOstaonPxG5zJTjT6YsklEnpYP+mwMasg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWzDXp2+RKyK/SlkmRJ+n/82D6TYjePQiMF4Hg1qFL3MWor7xxYj6VGguGS45EUfp
         UZobydJl2UjRSUjdLonla/Jc69Hk2XJEGZwsn5/9lJtPpTK8a9kUrF8gSeZP6WG2HH
         UY4AoZL40juSt8365WRUiK4UF6P6XTua7Z3Z70Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Masri <amasri@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 183/413] wil6210: drop old event after wmi_call timeout
Date:   Wed, 24 Jul 2019 21:17:54 +0200
Message-Id: <20190724191747.874990353@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1a276003111c0404f6bfeffe924c5a21f482428b ]

This change fixes a rare race condition of handling WMI events after
wmi_call expires.

wmi_recv_cmd immediately handles an event when reply_buf is defined and
a wmi_call is waiting for the event.
However, in case the wmi_call has already timed-out, there will be no
waiting/running wmi_call and the event will be queued in WMI queue and
will be handled later in wmi_event_handle.
Meanwhile, a new similar wmi_call for the same command and event may
be issued. In this case, when handling the queued event we got WARN_ON
printed.

Fixing this case as a valid timeout and drop the unexpected event.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d89cd41e78ac..89a75ff29410 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3220,7 +3220,18 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 		/* check if someone waits for this event */
 		if (wil->reply_id && wil->reply_id == id &&
 		    wil->reply_mid == mid) {
-			WARN_ON(wil->reply_buf);
+			if (wil->reply_buf) {
+				/* event received while wmi_call is waiting
+				 * with a buffer. Such event should be handled
+				 * in wmi_recv_cmd function. Handling the event
+				 * here means a previous wmi_call was timeout.
+				 * Drop the event and do not handle it.
+				 */
+				wil_err(wil,
+					"Old event (%d, %s) while wmi_call is waiting. Drop it and Continue waiting\n",
+					id, eventid2name(id));
+				return;
+			}
 
 			wmi_evt_call_handler(vif, id, evt_data,
 					     len - sizeof(*wmi));
-- 
2.20.1



