Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9C34062B3
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhIJAqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233990AbhIJAWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153BC6023D;
        Fri, 10 Sep 2021 00:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233268;
        bh=oKM4h4sSszh3tyXPxlVi2ZB8z/da0OOGWRHqYDw1HZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/OWVaGAmTGivWm5qk/WMvkc8z1Ir9Twr2NKxv7jqBaEXJZLcUQc4fBVOsP93AZG4
         FOC7Vsmi5mz3OsnvC0IeFKeVCnv+UUajSE5eRIpCb1A/OOtxOHRW3wW2MhkEQyEl6M
         VXGlMTW+NrOEE+70qhXlsrHcy9qKL3X26HQ96bjkw4EMfr9nG/XYd6BTmHPyXD9Nd9
         BlbR2bGRuNOPO2x7db4ZpiURzoAVCPQOpXgwqJA07zwuRyYpgc524KXjpy0D9mxgns
         cWskovW29KFdMOwrOBSh0aQIjE4PqJo4JzJlTZoyL7Tqfy/qpNFI3CuJUYnSbE0Pcp
         rCv2nF/vtk5jA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ulrich=20Sp=C3=B6rlein?= <uqs@FreeBSD.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/53] HID: sony: Fix more ShanWan clone gamepads to not rumble when plugged in.
Date:   Thu,  9 Sep 2021 20:20:04 -0400
Message-Id: <20210910002028.175174-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulrich Spörlein <uqs@FreeBSD.org>

[ Upstream commit bab94e97323baefe0afccad66e776f9c78b4f521 ]

The device string on these can differ, apparently, including typos. I've
bought 2 of these in 2012 and googling shows many folks out there with
that broken spelling in their dmesg.

Signed-off-by: Ulrich Spörlein <uqs@FreeBSD.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 2f073f536070..cdff43defe88 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2847,7 +2847,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (!strcmp(hdev->name, "FutureMax Dance Mat"))
 		quirks |= FUTUREMAX_DANCE_MAT;
 
-	if (!strcmp(hdev->name, "SHANWAN PS3 GamePad"))
+	if (!strcmp(hdev->name, "SHANWAN PS3 GamePad") ||
+	    !strcmp(hdev->name, "ShanWan PS(R) Ga`epad"))
 		quirks |= SHANWAN_GAMEPAD;
 
 	sc = devm_kzalloc(&hdev->dev, sizeof(*sc), GFP_KERNEL);
-- 
2.30.2

