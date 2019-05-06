Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232014F4B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfEFOfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfEFOf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8506021530;
        Mon,  6 May 2019 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153328;
        bh=ficshpO8Shqw6Abdhvok6FU9UFWIkLTXgtO1J+kYecU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7BPkkfIutkqgi7CsZ8bKjJfc0pE4zWRZ/nau/CWZJ9yv7LxuDNYGKgr/qC/xGE7d
         G8gXOPWg9bi89cWWLY4e3ipC+4ZSwl9JdcWhf0IOh3U/IxvAGgPMY8tyCpLuAuwNZS
         u2hXxsjcYo/zOuKCyZTsMsRFiESLcynXolI3mGtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 026/122] HID: Increase maximum report size allowed by hid_field_extract()
Date:   Mon,  6 May 2019 16:31:24 +0200
Message-Id: <20190506143057.104585809@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 94a9992f7dbdfb28976b565af220e0c4a117144a ]

Commit 71f6fa90a353 ("HID: increase maximum global item tag report size
to 256") increases the max report size from 128 to 256.

We also need to update the report size in hid_field_extract() otherwise
it complains and truncates now valid report size:
[ 406.165461] hid-sensor-hub 001F:8086:22D8.0002: hid_field_extract() called with n (192) > 32! (kworker/5:1)

BugLink: https://bugs.launchpad.net/bugs/1818547
Fixes: 71f6fa90a353 ("HID: increase maximum global item tag report size to 256")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9993b692598f..860e21ec6a49 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1301,10 +1301,10 @@ static u32 __extract(u8 *report, unsigned offset, int n)
 u32 hid_field_extract(const struct hid_device *hid, u8 *report,
 			unsigned offset, unsigned n)
 {
-	if (n > 32) {
-		hid_warn(hid, "hid_field_extract() called with n (%d) > 32! (%s)\n",
+	if (n > 256) {
+		hid_warn(hid, "hid_field_extract() called with n (%d) > 256! (%s)\n",
 			 n, current->comm);
-		n = 32;
+		n = 256;
 	}
 
 	return __extract(report, offset, n);
-- 
2.20.1



