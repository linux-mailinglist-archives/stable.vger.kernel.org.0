Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45FF1FE7E9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgFRCoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgFRBLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C5C21924;
        Thu, 18 Jun 2020 01:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442676;
        bh=xC3ut97fD0MLy+ms/mdfMJmo3sbdH9ILWuWNS4B9O7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WleStMkcanoz3earSaN8IuNkZTyFu60xn9H0akxxLdKXDPOGHnffoS1NCmqFkCE83
         8IictTTZ5wH0BfCUK92TgtjeSPCFUDtcWBfBNlwMb/gAh121/54th0XYRnRXUmpd5L
         b76epCNtZwGnXDjbIkLS9Sbe8+kak8YsPMMRj0V0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.7 144/388] staging: wfx: fix overflow in frame counters
Date:   Wed, 17 Jun 2020 21:04:01 -0400
Message-Id: <20200618010805.600873-144-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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

[ Upstream commit 87066173e34b0ca5d041d5519e6bb030b1958184 ]

It has been reported that trying to send small packets of data could
produce a "inconsistent notification" warning.

It seems that in some circumstances, the number of frame queued in the
driver could greatly increase and exceed UCHAR_MAX. So the field
"buffered" from struct sta_priv can overflow.

Just increase the size of "bueffered" to fix the problem.

Fixes: 7d2d2bfdeb82 ("staging: wfx: relocate "buffered" information to sta_priv")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200427134031.323403-10-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/sta.h b/drivers/staging/wfx/sta.h
index cf99a8a74a81..ace845f9ed14 100644
--- a/drivers/staging/wfx/sta.h
+++ b/drivers/staging/wfx/sta.h
@@ -37,7 +37,7 @@ struct wfx_grp_addr_table {
 struct wfx_sta_priv {
 	int link_id;
 	int vif_id;
-	u8 buffered[IEEE80211_NUM_TIDS];
+	int buffered[IEEE80211_NUM_TIDS];
 	// Ensure atomicity of "buffered" and calls to ieee80211_sta_set_buffered()
 	spinlock_t lock;
 };
-- 
2.25.1

