Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2176D4930EC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbiARWi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiARWix (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:38:53 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD0C061574;
        Tue, 18 Jan 2022 14:38:53 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i129so654045pfe.13;
        Tue, 18 Jan 2022 14:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uOGvUUzuJX9YKCxOe9YLRXRye1b5vrA9LrzACjIeYmE=;
        b=YAj8C1CGqbzdUw599ssYVjQh9WjrrLHabGBGRFcdZ9OUmTA5loEfRUdxh1UZzrXMpw
         qKWXm+VXmqJdtvbN4ma0cqRznWJi2FcSAla3aQdMLsIZzcgYcmaz8AeaBN9WSPukts+l
         p+Jmi0KX+c/sRbDZ7dXM8DCBq+5Otsz5UicEyGGcd2u9leavSkDIZQIojw92+1zqalDS
         mq+02GSul8vd0k95A7zDp/l3aNccZN9kE2SMysROti/Y7yWWyU/+QBOlCgC3nwIr6yBQ
         RZxqC9eH0HZmwwh3JDOeu8YnOMyCCG8fqZOeJHob+FHKNJzNOQC3ceMAeGIIDmVvHQ0j
         pfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uOGvUUzuJX9YKCxOe9YLRXRye1b5vrA9LrzACjIeYmE=;
        b=ZgFOrrvwIljZciFpGzhXlP40EOneAusye0UzBSGVHrm7t0wSOxNo29T9GT4yH6PG6v
         If1W5onVwoZb4QFy2RuV4tKqaJW/zZFuC77s+pecWcDL89ygtXo1T9/ar5J/vgRCW21w
         u5nEA+9+ADq1UVDXeU8kyMHtb4CxRblI3hq2nkYMGEfnkAGWtgLgmcyNTkTQ4xbapGIk
         K1rJZFsMzyuCMspxwHzyi2NHvUnwA/iRQxKmfDD5VQPI6AN8AigwSLWNmtqypaJxGH30
         +1MVssQmQHKP3qpdrAZ5laSgcpSX13RJg8khGuffXlwrM6Ah66lul3LYEmAlclskFGa8
         g6nA==
X-Gm-Message-State: AOAM531jJBwJMgz2fkfiD+GAFne5LgIznqd/MA1yFOMR4aKrbAhQG5ef
        ZWGqffN5egJkvdq3NBP8ovNPZP/3eq0=
X-Google-Smtp-Source: ABdhPJyCNuqM1wGkg6Z3hTznjOqW8F8aoo98xeiVJBTEDidhS+92cxYgwWjvaz7qUBVSAh+9IoM4yw==
X-Received: by 2002:a63:154f:: with SMTP id 15mr24602005pgv.521.1642545533048;
        Tue, 18 Jan 2022 14:38:53 -0800 (PST)
Received: from horus.lan (75-164-184-207.ptld.qwest.net. [75.164.184.207])
        by smtp.gmail.com with ESMTPSA id om6sm3680713pjb.48.2022.01.18.14.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 14:38:52 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH] HID: wacom: Avoid using stale array indicies to read contact count
Date:   Tue, 18 Jan 2022 14:38:41 -0800
Message-Id: <20220118223841.45870-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we ever see a touch report with contact count data we initialize
several variables used to read the contact count in the pre-report
phase. These variables are never reset if we process a report which
doesn't contain a contact count, however. This can cause the pre-
report function to trigger a read of arbitrary memory (e.g. NULL
if we're lucky) and potentially crash the driver.

This commit restores resetting of the variables back to default
"none" values that were used prior to the commit mentioned
below.

Link: https://github.com/linuxwacom/input-wacom/issues/276
Fixes: 003f50ab673c (HID: wacom: Update last_slot_field during pre_report phase)
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 92b52b1de526..a7176fc0635d 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2682,6 +2682,10 @@ static void wacom_wac_finger_pre_report(struct hid_device *hdev,
 
 	hid_data->confidence = true;
 
+	hid_data->cc_report = 0;
+	hid_data->cc_index = -1;
+	hid_data->cc_value_index = -1;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;
-- 
2.34.1

