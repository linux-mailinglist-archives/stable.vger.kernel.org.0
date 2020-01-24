Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352D814760E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgAXBRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbgAXBRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B722B2467F;
        Fri, 24 Jan 2020 01:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828666;
        bh=mT+Mylf0esXaJpgwHmYIz93oQT3mpdTi4KBdPMR82QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1bCdYTbYzwUu6lHNM89G/e5CdGfYHPxIDk8dQEnOKlDEtOllZRkVr3dtQqeJJY9m
         GGygq02g4oIFYT2dgcBOZsUnAIMQmp/y9U1gykQYyKdOjJwM7VnJKIIGJ8CEg74LqY
         dLlADTYHxnjbD1lMTSUIL6vkVPMXG0d7bGOu/5Bc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Zhang <zhangpan26@huawei.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/33] drivers/hid/hid-multitouch.c: fix a possible null pointer access.
Date:   Thu, 23 Jan 2020 20:17:08 -0500
Message-Id: <20200124011708.18232-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Zhang <zhangpan26@huawei.com>

[ Upstream commit 306d5acbfc66e7cccb4d8f91fc857206b8df80d1 ]

1002     if ((quirks & MT_QUIRK_IGNORE_DUPLICATES) && mt) {
1003         struct input_mt_slot *i_slot = &mt->slots[slotnum];
1004
1005         if (input_mt_is_active(i_slot) &&
1006             input_mt_is_used(mt, i_slot))
1007             return -EAGAIN;
1008     }

We previously assumed 'mt' could be null (see line 1002).

The following situation is similar, so add a judgement.

Signed-off-by: Pan Zhang <zhangpan26@huawei.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3cfeb1629f79f..28aaa26bb44cf 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1019,7 +1019,7 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 		tool = MT_TOOL_DIAL;
 	else if (unlikely(!confidence_state)) {
 		tool = MT_TOOL_PALM;
-		if (!active &&
+		if (!active && mt &&
 		    input_mt_is_active(&mt->slots[slotnum])) {
 			/*
 			 * The non-confidence was reported for
-- 
2.20.1

