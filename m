Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2E714E1DB
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgA3SsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731488AbgA3SsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9123A2082E;
        Thu, 30 Jan 2020 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410087;
        bh=BG0m2GrDH4m2acE7FgUelvrKxWuUu7u18RQMU/Mm3Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnAYCJ4Iu90alqCQ4AesaaRJmPYQCWZFR8T/LsYH/X2LNUVwWbrmNckW3KJy7IaYZ
         ZcYtCP7oR9NMaHwsUfGxr5THMVkRUMaopzV4slfljBJ+Eg8xlZlVcnrEtUiSpgdrAH
         mv3WuCfL0XI4Gq9hHpi51cihxVhLvXDjr4TDIipQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/55] HID: steam: Fix input device disappearing
Date:   Thu, 30 Jan 2020 19:39:21 +0100
Message-Id: <20200130183615.719491608@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>

[ Upstream commit 20eee6e5af35d9586774e80b6e0b1850e7cc9899 ]

The `connected` value for wired devices was not properly initialized,
it must be set to `true` upon creation, because wired devices do not
generate connection events.

When a raw client (the Steam Client) uses the device, the input device
is destroyed. Then, when the raw client finishes, it must be recreated.
But since the `connected` variable was false this never happended.

Signed-off-by: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 8dae0f9b819e0..6286204d4c560 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -768,8 +768,12 @@ static int steam_probe(struct hid_device *hdev,
 
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver connected");
+		/* If using a wireless adaptor ask for connection status */
+		steam->connected = false;
 		steam_request_conn_status(steam);
 	} else {
+		/* A wired connection is always present */
+		steam->connected = true;
 		ret = steam_register(steam);
 		if (ret) {
 			hid_err(hdev,
-- 
2.20.1



