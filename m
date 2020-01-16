Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC813FF56
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbgAPXmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388784AbgAPX0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DB7206D9;
        Thu, 16 Jan 2020 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217207;
        bh=CasMzY3yE/z02l19UuHHZrfvowP4z2p5CrjSbNYM8L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x//Dof7mEV+CvUKe8Yw3e5Fi7BycisFBtI1Iq+SibPcnqSVKldRoVYdPYCl1zdt0L
         ohkOcueKQx/JccPWc1BcyHBkt86tkb8SkmXlHvE+9zYJafEbr+SkoVP56c/1iqAKAB
         3Fv9MOVe93gdrHtsonP99lwrTdrwZYSRa6jf6f54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/203] selftests: firmware: Fix it to do root uid check and skip
Date:   Fri, 17 Jan 2020 00:18:21 +0100
Message-Id: <20200116231800.435820009@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit c65e41538b04e0d64a673828745a00cb68a24371 ]

firmware attempts to load test modules that require root access
and fail. Fix it to check for root uid and exit with skip code
instead.

Before this fix:

selftests: firmware: fw_run_tests.sh
modprobe: ERROR: could not insert 'test_firmware': Operation not permitted
You must have the following enabled in your kernel:
CONFIG_TEST_FIRMWARE=y
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
not ok 1 selftests: firmware: fw_run_tests.sh # SKIP

With this fix:

selftests: firmware: fw_run_tests.sh
skip all tests: must be run as root
not ok 1 selftests: firmware: fw_run_tests.sh # SKIP

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Reviwed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/firmware/fw_lib.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
index b879305a766d..5b8c0fedee76 100755
--- a/tools/testing/selftests/firmware/fw_lib.sh
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -34,6 +34,12 @@ test_modprobe()
 
 check_mods()
 {
+	local uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo "skip all tests: must be run as root" >&2
+		exit $ksft_skip
+	fi
+
 	trap "test_modprobe" EXIT
 	if [ ! -d $DIR ]; then
 		modprobe test_firmware
-- 
2.20.1



