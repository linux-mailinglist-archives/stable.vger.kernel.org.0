Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF523176BD2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgCCCwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729003AbgCCCtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1067E24697;
        Tue,  3 Mar 2020 02:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203794;
        bh=Xvrs5Tl05cV7m4ac4tT9EVzboSu3Qc+AUWzumDZp8DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWtq8w//RYOLtZkk3YAqnDL+ST4XxN/+vdCG5RfE8aMmjQZ4RbYsnNpL32Iu2uDQD
         TnMuxAFtnduRlsf8za7WHC00V+LB8JgPJ37Rziw1nVh7w3cURNEQVMXap+coUlIHbc
         R9nDgKnDJseQWK/Fy6mHk3Wd3B7M6xuW7qupPJEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/22] s390/cio: cio_ignore_proc_seq_next should increase position index
Date:   Mon,  2 Mar 2020 21:49:27 -0500
Message-Id: <20200303024933.10371-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024933.10371-1-sashal@kernel.org>
References: <20200303024933.10371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 8b101a5e14f2161869636ff9cb4907b7749dc0c2 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Link: https://lore.kernel.org/r/d44c53a7-9bc1-15c7-6d4a-0c10cb9dffce@virtuozzo.com
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/blacklist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 2a3f874a21d54..9cebff8e8d740 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -303,8 +303,10 @@ static void *
 cio_ignore_proc_seq_next(struct seq_file *s, void *it, loff_t *offset)
 {
 	struct ccwdev_iter *iter;
+	loff_t p = *offset;
 
-	if (*offset >= (__MAX_SUBCHANNEL + 1) * (__MAX_SSID + 1))
+	(*offset)++;
+	if (p >= (__MAX_SUBCHANNEL + 1) * (__MAX_SSID + 1))
 		return NULL;
 	iter = it;
 	if (iter->devno == __MAX_SUBCHANNEL) {
@@ -314,7 +316,6 @@ cio_ignore_proc_seq_next(struct seq_file *s, void *it, loff_t *offset)
 			return NULL;
 	} else
 		iter->devno++;
-	(*offset)++;
 	return iter;
 }
 
-- 
2.20.1

