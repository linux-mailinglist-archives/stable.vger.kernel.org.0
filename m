Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63564A4436
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359712AbiAaL1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:27:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56172 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359748AbiAaLZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37327612E7;
        Mon, 31 Jan 2022 11:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BC5C340E8;
        Mon, 31 Jan 2022 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628322;
        bh=6ft/EFgRLxzS72P1pMEZd4OCnBoxZ34zrPMieLQYXwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKzusJHKhBqQwTuG9Cv7IOABmMTueUyKfSsS4JV5sHIzNxnnRcdlAo0ERGtk6RVqE
         V+GiP8R8Rh5Y/6Ajx23R1/ZMDEidVygDmrMENVmEfrhXZZXQrcZuJewnEezd9C4ikC
         MmIxDTBIxPAIruLnMuVO5F9eigLGrTVvMBosejzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Pauk <pauk.denis@gmail.com>,
        Bernhard Seibold <mail@bernhard-seibold.de>,
        =?UTF-8?q?Pawe=C5=82=20Marciniak?= <pmarciniak@lodz.home.pl>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 168/200] hwmon: (nct6775) Fix crash in clear_caseopen
Date:   Mon, 31 Jan 2022 11:57:11 +0100
Message-Id: <20220131105239.204847579@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 79da533d3cc717ccc05ddbd3190da8a72bc2408b ]

Paweł Marciniak reports the following crash, observed when clearing
the chassis intrusion alarm.

BUG: kernel NULL pointer dereference, address: 0000000000000028
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 3 PID: 4815 Comm: bash Tainted: G S                5.16.2-200.fc35.x86_64 #1
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z97 Extreme4, BIOS P2.60A 05/03/2018
RIP: 0010:clear_caseopen+0x5a/0x120 [nct6775]
Code: 68 70 e8 e9 32 b1 e3 85 c0 0f 85 d2 00 00 00 48 83 7c 24 ...
RSP: 0018:ffffabcb02803dd8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff8e8808192880 RSI: 0000000000000000 RDI: ffff8e87c7509a68
RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000000000a
R10: 000000000000000a R11: f000000000000000 R12: 000000000000001f
R13: ffff8e87c7509828 R14: ffff8e87c7509a68 R15: ffff8e88494527a0
FS:  00007f4db9151740(0000) GS:ffff8e8ebfec0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000166b66001 CR4: 00000000001706e0
Call Trace:
 <TASK>
 kernfs_fop_write_iter+0x11c/0x1b0
 new_sync_write+0x10b/0x180
 vfs_write+0x209/0x2a0
 ksys_write+0x4f/0xc0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The problem is that the device passed to clear_caseopen() is the hwmon
device, not the platform device, and the platform data is not set in the
hwmon device. Store the pointer to sio_data in struct nct6775_data and
get if from there if needed.

Fixes: 2e7b9886968b ("hwmon: (nct6775) Use superio_*() function pointers in sio_data.")
Cc: Denis Pauk <pauk.denis@gmail.com>
Cc: Bernhard Seibold <mail@bernhard-seibold.de>
Reported-by: Paweł Marciniak <pmarciniak@lodz.home.pl>
Tested-by: Denis Pauk <pauk.denis@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 57ce8633a7256..3496a823e4d4f 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -1175,7 +1175,7 @@ static inline u8 in_to_reg(u32 val, u8 nr)
 
 struct nct6775_data {
 	int addr;	/* IO base of hw monitor block */
-	int sioreg;	/* SIO register address */
+	struct nct6775_sio_data *sio_data;
 	enum kinds kind;
 	const char *name;
 
@@ -3561,7 +3561,7 @@ clear_caseopen(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct nct6775_data *data = dev_get_drvdata(dev);
-	struct nct6775_sio_data *sio_data = dev_get_platdata(dev);
+	struct nct6775_sio_data *sio_data = data->sio_data;
 	int nr = to_sensor_dev_attr(attr)->index - INTRUSION_ALARM_BASE;
 	unsigned long val;
 	u8 reg;
@@ -3969,7 +3969,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	data->kind = sio_data->kind;
-	data->sioreg = sio_data->sioreg;
+	data->sio_data = sio_data;
 
 	if (sio_data->access == access_direct) {
 		data->addr = res->start;
-- 
2.34.1



