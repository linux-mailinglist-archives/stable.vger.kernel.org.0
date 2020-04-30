Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32DE1BFAA6
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgD3Ny7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbgD3Ny5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0010820870;
        Thu, 30 Apr 2020 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254896;
        bh=iKLOjbISfSmx+ATUFlxMQc5jsMELnFldoSD6Jp2nEvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yj3xj5rGz02BzKCNPHwTPRiMN0z1eN16AcAvUAOXtYhE/Od+9UTZgxlZInhVkYLVo
         c+HR0dLkd6kOsqq6WvYlVboAdwS7YxOjA4Gs5hczJN2Yk02sopqAd9tw1Tx0Z98b0j
         yE3u5loWLyFZ6/x6NtYGv6GdsoSz2anRd4poh0DA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/11] selftests/ipc: Fix test failure seen after initial test run
Date:   Thu, 30 Apr 2020 09:54:44 -0400
Message-Id: <20200430135453.21353-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135453.21353-1-sashal@kernel.org>
References: <20200430135453.21353-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit b87080eab4c1377706c113fc9c0157f19ea8fed1 ]

After successfully running the IPC msgque test once, subsequent runs
result in a test failure:

  $ sudo ./run_kselftest.sh
  TAP version 13
  1..1
  # selftests: ipc: msgque
  # Failed to get stats for IPC queue with id 0
  # Failed to dump queue: -22
  # Bail out!
  # # Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
  not ok 1 selftests: ipc: msgque # exit=1

The dump_queue() function loops through the possible message queue index
values using calls to msgctl(kern_id, MSG_STAT, ...) where kern_id
represents the index value. The first time the test is ran, the initial
index value of 0 is valid and the test is able to complete. The index
value of 0 is not valid in subsequent test runs and the loop attempts to
try index values of 1, 2, 3, and so on until a valid index value is
found that corresponds to the message queue created earlier in the test.

The msgctl() syscall returns -1 and sets errno to EINVAL when invalid
index values are used. The test failure is caused by incorrectly
comparing errno to -EINVAL when cycling through possible index values.

Fix invalid test failures on subsequent runs of the msgque test by
correctly comparing errno values to a non-negated EINVAL.

Fixes: 3a665531a3b7 ("selftests: IPC message queue copy feature test")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ipc/msgque.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index 1b2ce334bb3f0..47c074d73e610 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -135,7 +135,7 @@ int dump_queue(struct msgque_data *msgque)
 	for (kern_id = 0; kern_id < 256; kern_id++) {
 		ret = msgctl(kern_id, MSG_STAT, &ds);
 		if (ret < 0) {
-			if (errno == -EINVAL)
+			if (errno == EINVAL)
 				continue;
 			printf("Failed to get stats for IPC queue with id %d\n",
 					kern_id);
-- 
2.20.1

