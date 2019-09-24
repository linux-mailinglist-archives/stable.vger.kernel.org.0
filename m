Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01003BCFBA
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfIXRAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409901AbfIXQot (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06C3E217D9;
        Tue, 24 Sep 2019 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343488;
        bh=D4Qiu2RIjTeWdMxCBsBkoA53esOy0TSHq8E54FM0VMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wuNsRH2bhBqGIU9+c67xvfQX1Dkmsa1wF4Rwkz167ODfcc/Zvel5Pcci10v2DtqW
         eejTSBu5mUlsmJKszkitNvhxjNoBbPzL/GC2JaEL+l4m4reE3V0YXVWRXR13Lq96OW
         Ba+3Bso9PPne0q/IruaD90JFICHFizsNMtT4Bcvg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Jeff Layton <jlayton@kernel.org>, anton@enomsg.org,
        ccross@android.com, tony.luck@intel.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 67/87] pstore: fs superblock limits
Date:   Tue, 24 Sep 2019 12:41:23 -0400
Message-Id: <20190924164144.25591-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>

[ Upstream commit 83b8a3fbe3aa82ac3c253b698ae6a9be2dbdd5e0 ]

Leaving granularity at 1ns because it is dependent on the specific
attached backing pstore module. ramoops has microsecond resolution.

Fix the readback of ramoops fractional timestamp microseconds,
which has incorrectly been reporting the value as nanoseconds.

Fixes: 3f8f80f0cfeb ("pstore/ram: Read and write to the 'compressed' flag of pstore").

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: anton@enomsg.org
Cc: ccross@android.com
Cc: keescook@chromium.org
Cc: tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 2bb3468fc93aa..8caff834f0026 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -144,6 +144,7 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec64 *time,
 	if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lld.%lu-%c\n%n",
 		   (time64_t *)&time->tv_sec, &time->tv_nsec, &data_type,
 		   &header_length) == 3) {
+		time->tv_nsec *= 1000;
 		if (data_type == 'C')
 			*compressed = true;
 		else
@@ -151,6 +152,7 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec64 *time,
 	} else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lld.%lu\n%n",
 			  (time64_t *)&time->tv_sec, &time->tv_nsec,
 			  &header_length) == 2) {
+		time->tv_nsec *= 1000;
 		*compressed = false;
 	} else {
 		time->tv_sec = 0;
-- 
2.20.1

