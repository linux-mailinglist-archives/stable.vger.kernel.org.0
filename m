Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7911CAC92
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgEHMyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgEHMyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12E9C2496C;
        Fri,  8 May 2020 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942480;
        bh=pNDq+qA0a6AeHHaZ1+wh57H8blS3M82LwnhCyrgPei8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbo9eTpkmuLe3xwhNkHxAFcgMjdFzyAvb8bDatgpfHjJDJMjMko3ICciMoD0EgVuZ
         IE8Hh8Wvi4jyZHKKY7qRLeHWxLSWev/0+SnAp59OMxSHLhchsWFtalA7klA508BfgR
         ZRraRogheHWdVIF1ByDvaChmlU3uFY91v/KT0FRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 12/49] Revert "Kernel selftests: tpm2: check for tpm support"
Date:   Fri,  8 May 2020 14:35:29 +0200
Message-Id: <20200508123044.748082043@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

[ Upstream commit aaa2d92efe1f972567f1691b423ab8dc606ab3a9 ]

This reverts commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc.

The original comment was neither reviewed nor tested. Thus, this the
*only* possible action to take.

Cc: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 13 ++-----------
 tools/testing/selftests/tpm2/test_space.sh |  9 +--------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index b630c7b5950a9..8155c2ea7ccbb 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,17 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
-self.flags = flags
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-
-if [ -f /dev/tpm0 ] ; then
-	python -m unittest -v tpm2_tests.SmokeTest
-	python -m unittest -v tpm2_tests.AsyncTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SmokeTest
+python -m unittest -v tpm2_tests.AsyncTest
 
 CLEAR_CMD=$(which tpm2_clear)
 if [ -n $CLEAR_CMD ]; then
diff --git a/tools/testing/selftests/tpm2/test_space.sh b/tools/testing/selftests/tpm2/test_space.sh
index 180b469c53b47..a6f5e346635e5 100755
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,11 +1,4 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-if [ -f /dev/tpmrm0 ] ; then
-	python -m unittest -v tpm2_tests.SpaceTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SpaceTest
-- 
2.20.1



