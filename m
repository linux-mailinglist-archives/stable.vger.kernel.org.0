Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F085714E161
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgA3Sny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730711AbgA3Snw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A88205F4;
        Thu, 30 Jan 2020 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409832;
        bh=WuAup9z8oA2h3PB+InQ9sQYdz8cjXN1iK5cec6tvhDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfzBFfaXdTLHuTr9r3nj4eAu+ZBoiApVAQuGYyLoojE8oNyDy44VKNQlWN4mnCk/b
         jEBxLzkoZbt6XoEgig69q3Uu2Rwr00kCbjNKXk1epLEs/ONwI7eYcePlV1ooxG+ysM
         B5BQ5ZxUhlqXvpRHb9qyiF2ETO2JJ3HurxPC4SEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/110] HID: asus: Ignore Asus vendor-page usage-code 0xff events
Date:   Thu, 30 Jan 2020 19:38:24 +0100
Message-Id: <20200130183620.897861809@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c07a0254c89e4bb69ca781cd488baa5b628e2754 ]

At least on a T100HA an Asus vendor-page usage-code 0xff event is send on
every suspend and again on resume, resulting in the following warning:

asus 0003:0B05:1807.0002: Unmapped Asus vendor usagepage code 0xff

being logged twice on every suspend/resume.

This commit silences the "Unmapped Asus vendor usagepage code ..."
warning for usage-code 0xff to avoid these warnings being logged.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 8063b1d567b1d..e6e4c841fb06f 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -261,7 +261,8 @@ static int asus_event(struct hid_device *hdev, struct hid_field *field,
 		      struct hid_usage *usage, __s32 value)
 {
 	if ((usage->hid & HID_USAGE_PAGE) == 0xff310000 &&
-	    (usage->hid & HID_USAGE) != 0x00 && !usage->type) {
+	    (usage->hid & HID_USAGE) != 0x00 &&
+	    (usage->hid & HID_USAGE) != 0xff && !usage->type) {
 		hid_warn(hdev, "Unmapped Asus vendor usagepage code 0x%02x\n",
 			 usage->hid & HID_USAGE);
 	}
-- 
2.20.1



