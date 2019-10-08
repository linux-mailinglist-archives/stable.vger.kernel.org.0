Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A67CFF1C
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfJHQnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:43:33 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36983 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbfJHQnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:43:33 -0400
Received: by mail-ot1-f66.google.com with SMTP id k32so14583436otc.4;
        Tue, 08 Oct 2019 09:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vS/5fB54XstU4rdvgpJKZPrhcUUHcFJDqzPvMYzq7Aw=;
        b=dmqKzUE9oRZZBh7/aqQoqcQw7cmx9ZH8reWN0u5DAQ1yhGtTTDAfVtLTtDVQk3kZ71
         FLDy/oU/nkBnpvRU2nNbRHRbk8khRAwLeJ9frv/61Vhp8Mc7OuFpkxPBWeXkmieiOQfn
         Vjzoga+VgBNxrsz2HzB9o9wHPb2Irhnw6QyFqN5us7cXz5dUswzmrZwr4V9cf5Aimigz
         ftWa/J98qlgoDbr+mxKh8j3cqPiR6oHame+DRdEQ4nE9UDzE4qLQ/eT7rkBgCDU6gg0l
         vAT1P9j7awYGpupDYnYx+OtrmlhysiaCmsKrTHn9rMDgz+cUiuqHVU1yCO0zyzIvqxL9
         1L8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vS/5fB54XstU4rdvgpJKZPrhcUUHcFJDqzPvMYzq7Aw=;
        b=JzWP3vYJs7HW3FNJZOozUQBP2UJSX0KiijxJEXHVjo/TOesnDTDHB9xmpSsKzjjDhl
         wyVfB9XU6bx4cGiFnHSc1oyp3mY+qYrOHlhWCye/QF/0ebRu5bCWQsOzcUGctlZVnHCj
         yB066udb4eBnaUl9hKEcTK/muyVzyzUqKuBVCjXgi+6jTHfjkWJEg8gaTGa5KIBa3KSr
         tOaAnQiajx8H5G5AevvUO6gH3xsiigjANd1Gip2qIhdAcRv2nr9PYJKT29/gmath62hJ
         jRGyhD2Ryim69bAHwXhngTqZadbHqdpvbwgC7zv7jV2emSl9vaYkqiQVMmnkZMSRNJz9
         Yc/A==
X-Gm-Message-State: APjAAAUMmnwReKUB5Noz7IeCYlgHrq19foZlSESAC4kMJeEpumZEUA6X
        7o2WQ3HLUJByKurZdPc2q+NlhQJS
X-Google-Smtp-Source: APXvYqyDq/0iYUbTxfT10aEUY65SgeenNxyo9GuSQpVtPKIiHov/xAO5zWJZIkIAzQq1BcUPeUHg1Q==
X-Received: by 2002:a9d:6155:: with SMTP id c21mr16819491otk.370.1570553010857;
        Tue, 08 Oct 2019 09:43:30 -0700 (PDT)
Received: from localhost.localdomain (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.gmail.com with ESMTPSA id j31sm5680961ota.13.2019.10.08.09.43.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:43:30 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc:     Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: More strictly validate .abort_scan
Date:   Tue,  8 Oct 2019 11:33:24 -0500
Message-Id: <20191008163324.2614-1-denkenz@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

nl80211 requires NL80211_CMD_ABORT_SCAN to have a wdev or netdev
attribute present and checks that if netdev is provided it is UP.
However, mac80211 does not check that an ongoing scan actually belongs
to the netdev/wdev provided by the user.  In other words, it is possible
for an application to cancel scans on an interface it doesn't manage.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Cc: stable@vger.kernel.org
---
 net/mac80211/cfg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 70739e746c13..ece344f9e9ca 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2333,7 +2333,13 @@ static int ieee80211_scan(struct wiphy *wiphy,
 
 static void ieee80211_abort_scan(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	ieee80211_scan_cancel(wiphy_priv(wiphy));
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata =
+					IEEE80211_WDEV_TO_SUB_IF(wdev);
+	bool cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
+
+	if (cancel_scan)
+		ieee80211_scan_cancel(local);
 }
 
 static int
-- 
2.21.0

