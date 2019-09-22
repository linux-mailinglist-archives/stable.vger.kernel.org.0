Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF44BA5B3
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfIVSpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388689AbfIVSpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B472C20882;
        Sun, 22 Sep 2019 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177901;
        bh=Nxw5aOhWfTdOiyaoeE7XsDYMnNJhhdM1ju1U9Tc3byo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elv/uXWK3lC0byJegVJfHJgv2JZW5LnZi6EQjJ7nkUE36Um7tqWpAsz1C79wUtlK6
         eqZKiCknJOdOKyRoazj1VnyaB7rqw/VAqmH2Kcle9cpYNPWpaPGXQ5zZDa/dDe0LIU
         p9BNlP0ZAXxxvvaNPQAm2CMu05ne2t8qYtn99yew=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 019/203] media: vivid:add sanity check to avoid divide error and set value to 1 if 0.
Date:   Sun, 22 Sep 2019 14:40:45 -0400
Message-Id: <20190922184350.30563-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vandana BN <bnvandana@gmail.com>

[ Upstream commit aa9c2182c45421d54ed27c2a1765f7adedce291b ]

Syzbot reported divide error in vivid_thread_vid_cap, which has been
seen only once and does not have a reproducer.
This patch adds sanity checks for the
denominator value with WARN_ON if it is 0 and replaces it with 1.

divide error: 0000 [#1] PREEMPT SMP KASAN
kobject: 'tx-0' (0000000017161f7f): kobject_uevent_env
CPU: 0 PID: 23689 Comm: vivid-003-vid-c Not tainted 5.0.0-rc4+ #58
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
RIP: 0010:vivid_cap_update_frame_period
drivers/media/platform/vivid/vivid-kthread-cap.c:661 [inline]
RIP: 0010:vivid_thread_vid_cap+0x221/0x284
drivers/media/platform/vivid/vivid-kthread-cap.c:789
Code: 48 c1 e9 03 0f b6 0c 11 48 89 f2 48 69 c0 00 ca 9a 3b 83 c2 03 38
ca
7c 08 84 c9 0f 85 f0 1e 00 00 41 8b 8f 24 64 00 00 31 d2 <48> f7 f1 49
89
c4 48 89 c3 49 8d 87 28 64 00 00 48 89 c2 48 89 45
RSP: 0018:ffff88808b4afd68 EFLAGS: 00010246
kobject: 'tx-0' (0000000017161f7f): fill_kobj_path: path
= '/devices/virtual/net/gre0/queues/tx-0'
RAX: 000000de5a6f8e00 RBX: 0000000100047b22 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: ffff88808b4aff00 R08: ffff88804862e1c0 R09: ffffffff89997008
R10: ffffffff89997010 R11: 0000000000000001 R12: 00000000fffffffc
R13: ffff8880a17e0500 R14: ffff88803e40f760 R15: ffff8882182b0140
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004cdc90 CR3: 000000005d827000 CR4: 00000000001426f0
Call Trace:
kobject: 'gretap0' (00000000d7549098): kobject_add_internal: parent:
'net',
set: 'devices'
kobject: 'loop2' (0000000094ed4ee4): kobject_uevent_env
kobject: 'loop2' (0000000094ed4ee4): fill_kobj_path: path
= '/devices/virtual/block/loop2'
  kthread+0x357/0x430 kernel/kthread.c:246
kobject: 'gretap0' (00000000d7549098): kobject_uevent_env
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Modules linked in:
kobject: 'gretap0' (00000000d7549098): fill_kobj_path: path
= '/devices/virtual/net/gretap0'
---[ end trace bc5c8b25b64d768f ]---
kobject: 'loop1' (0000000032036b86): kobject_uevent_env
RIP: 0010:vivid_cap_update_frame_period
drivers/media/platform/vivid/vivid-kthread-cap.c:661 [inline]
RIP: 0010:vivid_thread_vid_cap+0x221/0x2840
drivers/media/platform/vivid/vivid-kthread-cap.c:789
kobject: 'loop1' (0000000032036b86): fill_kobj_path: path
= '/devices/virtual/block/loop1'
Code: 48 c1 e9 03 0f b6 0c 11 48 89 f2 48 69 c0 00 ca 9a 3b 83 c2 03 38
ca
7c 08 84 c9 0f 85 f0 1e 00 00 41 8b 8f 24 64 00 00 31 d2 <48> f7 f1 49
89
c4 48 89 c3 49 8d 87 28 64 00 00 48 89 c2 48 89 45
kobject: 'loop0' (00000000dd9927c3): kobject_uevent_env
RSP: 0018:ffff88808b4afd68 EFLAGS: 00010246
RAX: 000000de5a6f8e00 RBX: 0000000100047b22 RCX: 0000000000000000
kobject: 'queues' (000000007ed20666): kobject_add_internal:
parent: 'gretap0', set: '<NULL>'
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: ffff88808b4aff00 R08: ffff88804862e1c0 R09: ffffffff89997008
kobject: 'loop0' (00000000dd9927c3): fill_kobj_path: path
= '/devices/virtual/block/loop0'
R10: ffffffff89997010 R11: 0000000000000001 R12: 00000000fffffffc
kobject: 'queues' (000000007ed20666): kobject_uevent_env
R13: ffff8880a17e0500 R14: ffff88803e40f760 R15: ffff8882182b0140
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000)
knlGS:0000000000000000
kobject: 'loop5' (00000000a41f9e79): kobject_uevent_env
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kobject: 'queues' (000000007ed20666): kobject_uevent_env: filter
function
caused the event to drop!
CR2: 00000000004cdc90 CR3: 000000005d827000 CR4: 00000000001426f0
kobject: 'loop5' (00000000a41f9e79): fill_kobj_path: path
= '/devices/virtual/block/loop5'

Reported-by: syz...@syzkaller.appspotmail.com
Signed-off-by: Vandana BN <bnvandana@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 6cf495a7d5cc1..ed466d737a90d 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -658,6 +658,8 @@ static void vivid_cap_update_frame_period(struct vivid_dev *dev)
 	u64 f_period;
 
 	f_period = (u64)dev->timeperframe_vid_cap.numerator * 1000000000;
+	if (WARN_ON(dev->timeperframe_vid_cap.denominator == 0))
+		dev->timeperframe_vid_cap.denominator = 1;
 	do_div(f_period, dev->timeperframe_vid_cap.denominator);
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
 		f_period >>= 1;
-- 
2.20.1

