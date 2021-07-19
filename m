Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED1B3CDF47
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbhGSPI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344733AbhGSPGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E8C5606A5;
        Mon, 19 Jul 2021 15:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709639;
        bh=cWHiH12FvTJFDthkEwrs//hjGIjPEoNDcrBkmfawt0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx84N1Yf/ey94WL5bGGazecqlvHbRdrtnVmCDP5w2MurODLyeGmhH00d4CyPfGq1M
         zg01z4fBQu1tDCQoXh7vxaIinIaardwft24Szv0kdkxRB5N+z6Yuc9ly++dEFVElTi
         eVaxUv8TAw79s8Rc+7fKaiNt9xhGmMY1qoLGfE20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/149] selftests: timers: rtcpie: skip test if default RTC device does not exist
Date:   Mon, 19 Jul 2021 16:52:27 +0200
Message-Id: <20210719144910.727139352@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 0d3e5a057992bdc66e4dca2ca50b77fa4a7bd90e ]

This test will require /dev/rtc0, the default RTC device, or one
specified by user to run. Since this default RTC is not guaranteed to
exist on all of the devices, so check its existence first, otherwise
skip this test with the kselftest skip code 4.

Without this patch this test will fail like this on a s390x zVM:
$ selftests: timers: rtcpie
$ /dev/rtc0: No such file or directory
not ok 1 selftests: timers: rtcpie # exit=22

With this patch:
$ selftests: timers: rtcpie
$ Default RTC /dev/rtc0 does not exist. Test Skipped!
not ok 9 selftests: timers: rtcpie # SKIP

Fixed up change log so "With this patch" text doesn't get dropped.
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/rtcpie.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/rtcpie.c b/tools/testing/selftests/timers/rtcpie.c
index 47b5bad1b393..4ef2184f1558 100644
--- a/tools/testing/selftests/timers/rtcpie.c
+++ b/tools/testing/selftests/timers/rtcpie.c
@@ -18,6 +18,8 @@
 #include <stdlib.h>
 #include <errno.h>
 
+#include "../kselftest.h"
+
 /*
  * This expects the new RTC class driver framework, working with
  * clocks that will often not be clones of what the PC-AT had.
@@ -35,8 +37,14 @@ int main(int argc, char **argv)
 	switch (argc) {
 	case 2:
 		rtc = argv[1];
-		/* FALLTHROUGH */
+		break;
 	case 1:
+		fd = open(default_rtc, O_RDONLY);
+		if (fd == -1) {
+			printf("Default RTC %s does not exist. Test Skipped!\n", default_rtc);
+			exit(KSFT_SKIP);
+		}
+		close(fd);
 		break;
 	default:
 		fprintf(stderr, "usage:  rtctest [rtcdev] [d]\n");
-- 
2.30.2



