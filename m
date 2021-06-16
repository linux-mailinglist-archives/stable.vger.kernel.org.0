Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0FF3A9FF4
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhFPPnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234965AbhFPPlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5375613DB;
        Wed, 16 Jun 2021 15:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857857;
        bh=rw9OtMzykAKIRnVFKBRCJO42Dv3xma8kkNsPO2gMGgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6bnMxu85jgVB+7TGqIsZY1oueL51/PBEYAYjLjCJezbFtj7tQ+uVWvfEdih91V9q
         XTvrJRt/5nT/Ir/2EGLlXkvaeonhnBGxCRRn5QW+rZNguEbBTkGQIfTl48sRWSJJUi
         VYxEB85anyBky7Z53xmtna/SIBDedJ6+ZkwPcziA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 08/48] HID: asus: filter G713/G733 key event to prevent shutdown
Date:   Wed, 16 Jun 2021 17:33:18 +0200
Message-Id: <20210616152836.916447733@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

[ Upstream commit c980512b4512adf2c6f9edb948ce19423b23124d ]

The G713 and G733 both emit an unexpected keycode on some key
presses such as Fn+Pause. The device in this case is emitting
two events on key down, and 3 on key up, the third key up event
is report ID 0x02 and is unfiltered, causing incorrect event.

This patch filters out the single problematic event.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 1ed1c05c3d54..60606c11bdaf 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -355,6 +355,16 @@ static int asus_raw_event(struct hid_device *hdev,
 				return -1;
 			}
 		}
+		if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
+			/*
+			 * G713 and G733 send these codes on some keypresses, depending on
+			 * the key pressed it can trigger a shutdown event if not caught.
+			*/
+			if(data[0] == 0x02 && data[1] == 0x30) {
+				return -1;
+			}
+		}
+
 	}
 
 	return 0;
-- 
2.30.2



