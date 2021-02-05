Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF531135D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhBEVUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:20:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhBEPCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B53265034;
        Fri,  5 Feb 2021 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534299;
        bh=qMW7ue19Uwp7HdV1n3mt6+nPLKC9zLXPVm9Mhou7CTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyzeFbEu51aqJ4/FPbdMWCXfQP3Fptu63cvSqXpdDLjTJ9qIGJZxYLT0TRyj8XO8D
         fgDFcfl10kT4EtzHyavtcJYwS4HD+eU2vCOO43RO6R50KE+/dfUn8qL4du1sQtJLP3
         VqO3iRA8Gj4NGJfBJMlDa1lpTfOYJs5PAqzRI+aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sujuan Chen <sujuan.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/57] mac80211: fix incorrect strlen of .write in debugfs
Date:   Fri,  5 Feb 2021 15:06:58 +0100
Message-Id: <20210205140657.342648190@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 6020d534fa012b80c6d13811dc4d2dfedca2e403 ]

This fixes strlen mismatch problems happening in some .write callbacks
of debugfs.

When trying to configure airtime_flags in debugfs, an error appeared:
ash: write error: Invalid argument

The error is returned from kstrtou16() since a wrong length makes it
miss the real end of input string.  To fix this, use count as the string
length, and set proper end of string for a char buffer.

The debug print is shown - airtime_flags_write: count = 2, len = 8,
where the actual length is 2, but "len = strlen(buf)" gets 8.

Also cleanup the other similar cases for the sake of consistency.

Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://lore.kernel.org/r/20210112032028.7482-1-shayne.chen@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 44 +++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 90470392fdaa7..de5cd3818690c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -120,18 +120,17 @@ static ssize_t aqm_write(struct file *file,
 {
 	struct ieee80211_local *local = file->private_data;
 	char buf[100];
-	size_t len;
 
-	if (count > sizeof(buf))
+	if (count >= sizeof(buf))
 		return -EINVAL;
 
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
-	buf[sizeof(buf) - 1] = '\0';
-	len = strlen(buf);
-	if (len > 0 && buf[len-1] == '\n')
-		buf[len-1] = 0;
+	if (count && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+	else
+		buf[count] = '\0';
 
 	if (sscanf(buf, "fq_limit %u", &local->fq.limit) == 1)
 		return count;
@@ -177,18 +176,17 @@ static ssize_t airtime_flags_write(struct file *file,
 {
 	struct ieee80211_local *local = file->private_data;
 	char buf[16];
-	size_t len;
 
-	if (count > sizeof(buf))
+	if (count >= sizeof(buf))
 		return -EINVAL;
 
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
-	buf[sizeof(buf) - 1] = 0;
-	len = strlen(buf);
-	if (len > 0 && buf[len - 1] == '\n')
-		buf[len - 1] = 0;
+	if (count && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+	else
+		buf[count] = '\0';
 
 	if (kstrtou16(buf, 0, &local->airtime_flags))
 		return -EINVAL;
@@ -237,20 +235,19 @@ static ssize_t aql_txq_limit_write(struct file *file,
 {
 	struct ieee80211_local *local = file->private_data;
 	char buf[100];
-	size_t len;
 	u32 ac, q_limit_low, q_limit_high, q_limit_low_old, q_limit_high_old;
 	struct sta_info *sta;
 
-	if (count > sizeof(buf))
+	if (count >= sizeof(buf))
 		return -EINVAL;
 
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
-	buf[sizeof(buf) - 1] = 0;
-	len = strlen(buf);
-	if (len > 0 && buf[len - 1] == '\n')
-		buf[len - 1] = 0;
+	if (count && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+	else
+		buf[count] = '\0';
 
 	if (sscanf(buf, "%u %u %u", &ac, &q_limit_low, &q_limit_high) != 3)
 		return -EINVAL;
@@ -306,18 +303,17 @@ static ssize_t force_tx_status_write(struct file *file,
 {
 	struct ieee80211_local *local = file->private_data;
 	char buf[3];
-	size_t len;
 
-	if (count > sizeof(buf))
+	if (count >= sizeof(buf))
 		return -EINVAL;
 
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
-	buf[sizeof(buf) - 1] = '\0';
-	len = strlen(buf);
-	if (len > 0 && buf[len - 1] == '\n')
-		buf[len - 1] = 0;
+	if (count && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+	else
+		buf[count] = '\0';
 
 	if (buf[0] == '0' && buf[1] == '\0')
 		local->force_tx_status = 0;
-- 
2.27.0



