Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51493C9011
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfJBRlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 13:41:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40853 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbfJBRlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 13:41:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id l3so20635392wru.7;
        Wed, 02 Oct 2019 10:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUZyNZheTJw4GC5851yKEfVpxUBc4f7pMP1DSM9q8jg=;
        b=TxqaMUzCDK4ovLkDJMl/hpwV9fisOrEBcq8rG7EFqfIoZeFC4i4T1p2HigugaA7msj
         cctE6s7h9qSHrtGNYOxs8FEUeqK+Fq4Z7iMWIlrhymawCSg7eo+2M2k8ejJfQKJ/ENO1
         grQwjgkUuJE4gV+WWodrZV+Y63EhFrKD8nqUt/zep7YJ8UHpAyrgN+0cP8NcYObZy0L8
         AjZtiO3U/8TFtSFzSxVWoio8/fLOXKImCw96MdNJOMf2/QyFjVRN485GVuMsqtaQzcGM
         8kzKfuslP92PB/irvSi4CPg3XcjF88w6yFIcUpQjS3GXRoG6K5E7LALUVJy2CBCaf5BB
         QJhQ==
X-Gm-Message-State: APjAAAV3cokkqB/SUKK45mKjxZm+tvMU3bxuNQ8hJjUdXk13bVD/mk1l
        XbyHUyEhXoHYQnqhvaK9jAg=
X-Google-Smtp-Source: APXvYqzWaLLj84b5DPgMGqOH66TFh2UVD9sMvffhg/6fPjFOWddMdm6yky7HGz0wVtcCSZ6uiKB5pg==
X-Received: by 2002:adf:e689:: with SMTP id r9mr3970235wrm.62.1570038072117;
        Wed, 02 Oct 2019 10:41:12 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id f186sm7879628wmg.21.2019.10.02.10.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:41:11 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: fix uninitialized variable
Date:   Wed,  2 Oct 2019 20:41:03 +0300
Message-Id: <20191002174103.1274-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The result variable in prism2_connect() can be used uninitialized on path
!channel --> ... --> is_wep --> sme->key --> sme->key_idx >= NUM_WEPKEYS.
This patch initializes result with 0.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/staging/wlan-ng/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index eee1998c4b18..d426905e187e 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -441,7 +441,7 @@ static int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 	int chan = -1;
 	int is_wep = (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) ||
 	    (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104);
-	int result;
+	int result = 0;
 	int err = 0;
 
 	/* Set the channel */
-- 
2.21.0

