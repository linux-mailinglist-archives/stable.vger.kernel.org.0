Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9257422884
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhJENwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235356AbhJENwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631D6615A4;
        Tue,  5 Oct 2021 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441845;
        bh=d2xzpI4z3IPcrj7a57Lu5DnTjFHxhXbjEClnR1OjXUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r084GLbw3Ttl/Bc9juyTme5ICBAGLMmPZ6eUvUgna7pNXrS9O1eZMQQcEYuv9M0Wm
         fdPid7YIkDEqvpH7041QVcjku29d3AxxxSCCmlRC8ucpxq1qrzR68QFTSg57U4wfQC
         8s57WLf0fHLGS1tsOVsoAvIP0KkW8xB7pXROoabk3k58Rr+gq4CsU80vnMFh4dXPET
         GHnD5Xrt5r/aMZyMXfJYerkdzjJcgT3IS/zDuA73bn0tWFS+b8KlExk5uglvzem6ql
         SIz1cC0z4B46px1FrrdrVMbosQNuNaPULv+N5btgQvxkW13Ty6Ls0vhUdcM9Hp+yHR
         sQqEashYDLBbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "F.A.Sulaiman" <asha.16@itfac.mrt.ac.lk>,
        syzbot+07efed3bc5a1407bd742@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/40] HID: betop: fix slab-out-of-bounds Write in betop_probe
Date:   Tue,  5 Oct 2021 09:49:49 -0400
Message-Id: <20211005135020.214291-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "F.A.Sulaiman" <asha.16@itfac.mrt.ac.lk>

[ Upstream commit 1e4ce418b1cb1a810256b5fb3fd33d22d1325993 ]

Syzbot reported slab-out-of-bounds Write bug in hid-betopff driver.
The problem is the driver assumes the device must have an input report but
some malicious devices violate this assumption.

So this patch checks hid_device's input is non empty before it's been used.

Reported-by: syzbot+07efed3bc5a1407bd742@syzkaller.appspotmail.com
Signed-off-by: F.A. SULAIMAN <asha.16@itfac.mrt.ac.lk>
Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-betopff.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 0790fbd3fc9a..467d789f9bc2 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -56,15 +56,22 @@ static int betopff_init(struct hid_device *hid)
 {
 	struct betopff_device *betopff;
 	struct hid_report *report;
-	struct hid_input *hidinput =
-			list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int error;
 	int i, j;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
-- 
2.33.0

