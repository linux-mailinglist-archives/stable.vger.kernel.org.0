Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A65E4996BF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347240AbiAXVGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444150AbiAXVAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6646C611DA;
        Mon, 24 Jan 2022 21:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24851C340E5;
        Mon, 24 Jan 2022 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058005;
        bh=kucaGnne7cqZQPDqTUhLgDG6belnp+ejA+u9CyOrx/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVb/01x37fk59ltfTuQxIqFiLS9sVvKG/bmE8fnFPNTGrtIEJzJYMvFcf7Joz73f2
         Djfpnfm2Pir4WaMP4IXD35emQcxy0uEoIPtHF5AvqOjwRz8IGv6yBijNxxgv+wO8Xo
         5VGV+mv1txw3Lwx7yBxkyO7pjmcybFeU22mzETo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0149/1039] selftests/bpf: Fix xdpxceiver failures for no hugepages
Date:   Mon, 24 Jan 2022 19:32:18 +0100
Message-Id: <20220124184130.171764698@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

[ Upstream commit dd7f091fd22b1dce6c20e8f7769aa068ed88ac6d ]

xsk_configure_umem() needs hugepages to work in unaligned mode. So when
hugepages are not configured, 'unaligned' tests should be skipped which
is determined by the helper function hugepages_present(). This function
erroneously returns true with MAP_NORESERVE flag even when no hugepages
are configured. The removal of this flag fixes the issue.

The test TEST_TYPE_UNALIGNED_INV_DESC also needs to be skipped when
there are no hugepages. However, this was not skipped as there was no
check for presence of hugepages and hence was failing. The check to skip
the test has now been added.

Fixes: a4ba98dd0c69 (selftests: xsk: Add test for unaligned mode)
Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211117123613.22288-1-tirthendu.sarkar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 6c7cf8aadc792..621342ec30c48 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1219,7 +1219,7 @@ static bool hugepages_present(struct ifobject *ifobject)
 	void *bufs;
 
 	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_HUGETLB, -1, 0);
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	if (bufs == MAP_FAILED)
 		return false;
 
@@ -1366,6 +1366,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		testapp_invalid_desc(test);
 		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC:
+		if (!hugepages_present(test->ifobj_tx)) {
+			ksft_test_result_skip("No 2M huge pages present.\n");
+			return;
+		}
 		test_spec_set_name(test, "UNALIGNED_INV_DESC");
 		test->ifobj_tx->umem->unaligned_mode = true;
 		test->ifobj_rx->umem->unaligned_mode = true;
-- 
2.34.1



