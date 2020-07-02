Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541EB21199C
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgGBBXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgGBBXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D06E20748;
        Thu,  2 Jul 2020 01:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652989;
        bh=7q/Jn05xenrj87leqnZtfVjiwdpZVJxdfTwBAn5Es/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mpv8Pdh5qKQY1vHvvHojHOAeHnbCnDJklZ7eJI7KY6TRz88ubcR+T5KBJ/NMQo1cT
         f4nvIH/9J6i1nUV+XGevKdSJeoZfkijkoRVVonIP9jMEG/s2wmQirzCrOS/lVz4zAA
         gFJBIbxKeKi83Xg+K+JcJBVIPCq3nKmReZXUy3CY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.7 12/53] staging: wfx: fix coherency of hif_scan() prototype
Date:   Wed,  1 Jul 2020 21:21:21 -0400
Message-Id: <20200702012202.2700645-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 29de523a6270a308d12d21f4fecf52dac491e226 ]

The function hif_scan() return the timeout for the completion of the
scan request. It is the only function from hif_tx.c that return another
thing than just an error code. This behavior is not coherent with the
rest of file. Worse, if value returned is positive, the caller can't
make say if it is a timeout or the value returned by the hardware.

Uniformize API with other HIF functions, only return the error code and
pass timeout with parameters.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200529121256.1045521-1-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/hif_tx.c | 6 ++++--
 drivers/staging/wfx/hif_tx.h | 2 +-
 drivers/staging/wfx/scan.c   | 6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
index 20b3045d76674..15ff60a584668 100644
--- a/drivers/staging/wfx/hif_tx.c
+++ b/drivers/staging/wfx/hif_tx.c
@@ -222,7 +222,7 @@ int hif_write_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val,
 }
 
 int hif_scan(struct wfx_vif *wvif, struct cfg80211_scan_request *req,
-	     int chan_start_idx, int chan_num)
+	     int chan_start_idx, int chan_num, int *timeout)
 {
 	int ret, i;
 	struct hif_msg *hif;
@@ -269,11 +269,13 @@ int hif_scan(struct wfx_vif *wvif, struct cfg80211_scan_request *req,
 	tmo_chan_fg = 512 * USEC_PER_TU + body->probe_delay;
 	tmo_chan_fg *= body->num_of_probe_requests;
 	tmo = chan_num * max(tmo_chan_bg, tmo_chan_fg) + 512 * USEC_PER_TU;
+	if (timeout)
+		*timeout = usecs_to_jiffies(tmo);
 
 	wfx_fill_header(hif, wvif->id, HIF_REQ_ID_START_SCAN, buf_len);
 	ret = wfx_cmd_send(wvif->wdev, hif, NULL, 0, false);
 	kfree(hif);
-	return ret ? ret : usecs_to_jiffies(tmo);
+	return ret;
 }
 
 int hif_stop_scan(struct wfx_vif *wvif)
diff --git a/drivers/staging/wfx/hif_tx.h b/drivers/staging/wfx/hif_tx.h
index f8520a14c14cd..7a21338470eeb 100644
--- a/drivers/staging/wfx/hif_tx.h
+++ b/drivers/staging/wfx/hif_tx.h
@@ -43,7 +43,7 @@ int hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id,
 int hif_write_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id,
 		  void *buf, size_t buf_size);
 int hif_scan(struct wfx_vif *wvif, struct cfg80211_scan_request *req80211,
-	     int chan_start, int chan_num);
+	     int chan_start, int chan_num, int *timeout);
 int hif_stop_scan(struct wfx_vif *wvif);
 int hif_join(struct wfx_vif *wvif, const struct ieee80211_bss_conf *conf,
 	     struct ieee80211_channel *channel, const u8 *ssid, int ssidlen);
diff --git a/drivers/staging/wfx/scan.c b/drivers/staging/wfx/scan.c
index 9aa14331affd6..d47b8a3ba403c 100644
--- a/drivers/staging/wfx/scan.c
+++ b/drivers/staging/wfx/scan.c
@@ -56,10 +56,10 @@ static int send_scan_req(struct wfx_vif *wvif,
 	wfx_tx_lock_flush(wvif->wdev);
 	wvif->scan_abort = false;
 	reinit_completion(&wvif->scan_complete);
-	timeout = hif_scan(wvif, req, start_idx, i - start_idx);
-	if (timeout < 0) {
+	ret = hif_scan(wvif, req, start_idx, i - start_idx, &timeout);
+	if (ret) {
 		wfx_tx_unlock(wvif->wdev);
-		return timeout;
+		return -EIO;
 	}
 	ret = wait_for_completion_timeout(&wvif->scan_complete, timeout);
 	if (req->channels[start_idx]->max_power != wvif->vif->bss_conf.txpower)
-- 
2.25.1

