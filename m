Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924F1615857
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKBCuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiKBCt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:49:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47CF5AE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88844617CA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A26EC433D6;
        Wed,  2 Nov 2022 02:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357395;
        bh=H+0N1VHLgsuSwI8bcX5bVrEM6UKqbnSEUAOlId7eYio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwWjZFuVzxlICaBMWPsSSxzxM70GLSnU7HcctcDVV876UllBQxzE7lXvTtWv01YVt
         aIgJxo1HUkgSoChal8Lt5W38iXfgrs5UU27K4EiBtSxfQtbXBhEiMY0vVFgNmJbtl7
         RPvjjee/Dl6X4e9H5YiMumsDjUDWbkesio54AqgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Toppins <jtoppins@redhat.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 163/240] selftests: net: Fix cross-tree inclusion of scripts
Date:   Wed,  2 Nov 2022 03:32:18 +0100
Message-Id: <20221102022115.069299808@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit ae108c48b5d2b34bcef3c4fb5076f42c922c426a ]

When exporting and running a subset of selftests via kselftest, files from
parts of the source tree which were not exported are not available. A few
tests are trying to source such files. Address the problem by using
symlinks.

The problem can be reproduced by running:
make -C tools/testing/selftests gen_tar TARGETS="drivers/net/bonding"
[... extract archive ...]
./run_kselftest.sh

or:
make kselftest KBUILD_OUTPUT=/tmp/kselftests TARGETS="drivers/net/bonding"

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Fixes: eccd0a80dc7f ("selftests: net: dsa: add a stress test for unlocked FDB operations")
Link: https://lore.kernel.org/netdev/40f04ded-0c86-8669-24b1-9a313ca21076@redhat.com/
Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/bonding/Makefile          | 4 +++-
 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh | 2 +-
 .../selftests/drivers/net/bonding/net_forwarding_lib.sh       | 1 +
 .../selftests/drivers/net/dsa/test_bridge_fdb_stress.sh       | 4 ++--
 tools/testing/selftests/drivers/net/team/Makefile             | 4 ++++
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh    | 4 ++--
 tools/testing/selftests/drivers/net/team/lag_lib.sh           | 1 +
 .../testing/selftests/drivers/net/team/net_forwarding_lib.sh  | 1 +
 tools/testing/selftests/lib.mk                                | 4 ++--
 9 files changed, 17 insertions(+), 8 deletions(-)
 create mode 120000 tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/lag_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 1d866658e541..c61299c10e36 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -5,6 +5,8 @@ TEST_PROGS := bond-break-lacpdu-tx.sh \
 	      dev_addr_lists.sh \
 	      bond-arp-interval-causes-panic.sh
 
-TEST_FILES := lag_lib.sh
+TEST_FILES := \
+	lag_lib.sh \
+	net_forwarding_lib.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
index e6fa24eded5b..5cfe7d8ebc25 100755
--- a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
@@ -14,7 +14,7 @@ ALL_TESTS="
 REQUIRE_MZ=no
 NUM_NETIFS=0
 lib_dir=$(dirname "$0")
-source "$lib_dir"/../../../net/forwarding/lib.sh
+source "$lib_dir"/net_forwarding_lib.sh
 
 source "$lib_dir"/lag_lib.sh
 
diff --git a/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh b/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
index dca8be6092b9..a1f269ee84da 100755
--- a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
+++ b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
@@ -18,8 +18,8 @@ NUM_NETIFS=1
 REQUIRE_JQ="no"
 REQUIRE_MZ="no"
 NETIF_CREATE="no"
-lib_dir=$(dirname $0)/../../../net/forwarding
-source $lib_dir/lib.sh
+lib_dir=$(dirname "$0")
+source "$lib_dir"/lib.sh
 
 cleanup() {
 	echo "Cleaning up"
diff --git a/tools/testing/selftests/drivers/net/team/Makefile b/tools/testing/selftests/drivers/net/team/Makefile
index 642d8df1c137..6a86e61e8bfe 100644
--- a/tools/testing/selftests/drivers/net/team/Makefile
+++ b/tools/testing/selftests/drivers/net/team/Makefile
@@ -3,4 +3,8 @@
 
 TEST_PROGS := dev_addr_lists.sh
 
+TEST_FILES := \
+	lag_lib.sh \
+	net_forwarding_lib.sh
+
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
index debda7262956..9684163949f0 100755
--- a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -11,9 +11,9 @@ ALL_TESTS="
 REQUIRE_MZ=no
 NUM_NETIFS=0
 lib_dir=$(dirname "$0")
-source "$lib_dir"/../../../net/forwarding/lib.sh
+source "$lib_dir"/net_forwarding_lib.sh
 
-source "$lib_dir"/../bonding/lag_lib.sh
+source "$lib_dir"/lag_lib.sh
 
 
 destroy()
diff --git a/tools/testing/selftests/drivers/net/team/lag_lib.sh b/tools/testing/selftests/drivers/net/team/lag_lib.sh
new file mode 120000
index 000000000000..e1347a10afde
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/lag_lib.sh
@@ -0,0 +1 @@
+../bonding/lag_lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh b/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 9d4cb94cf437..a3ea3d4a206d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -70,7 +70,7 @@ endef
 run_tests: all
 ifdef building_out_of_srctree
 	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then \
-		rsync -aq $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
+		rsync -aLq $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
 	fi
 	@if [ "X$(TEST_PROGS)" != "X" ]; then \
 		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) \
@@ -84,7 +84,7 @@ endif
 
 define INSTALL_SINGLE_RULE
 	$(if $(INSTALL_LIST),@mkdir -p $(INSTALL_PATH))
-	$(if $(INSTALL_LIST),rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
+	$(if $(INSTALL_LIST),rsync -aL $(INSTALL_LIST) $(INSTALL_PATH)/)
 endef
 
 define INSTALL_RULE
-- 
2.35.1



