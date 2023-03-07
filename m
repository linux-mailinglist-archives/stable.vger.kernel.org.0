Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F16AE9FD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjCGR37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCGR3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:29:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07A0A029B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC6BBB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFBAC433EF;
        Tue,  7 Mar 2023 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209865;
        bh=Rs/DUMvyIUb3iNsxBuRf5rr+fHp2X4QsbIWzvdXZ4AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNB9Uvq9aEq18wKceH4Zvf6v4eIB5a3BL3kBpuOtzr0gTe2Qdl+hyJ/C2tnHZlHcu
         Yd13ol8VsGqu/1DjVdsqMs1doXZWioD7UqUJZOTRMtDZDvdEvpPIcom1k8Am1lPAqV
         ncLFI29qeVt+hqtqeGA1FahHcm3czBvqTEF5h4fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Tzin <amirtz@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0326/1001] sefltests: netdevsim: wait for devlink instance after netns removal
Date:   Tue,  7 Mar 2023 17:51:38 +0100
Message-Id: <20230307170035.661045039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit f922c7b1c1c45740d329bf248936fdb78c0cff6e ]

When devlink instance is put into network namespace and that network
namespace gets deleted, devlink instance is moved back into init_ns.
This is done as a part of cleanup_net() routine. Since cleanup_net()
is called asynchronously from workqueue, there is no guarantee that
the devlink instance move is done after "ip netns del" returns.

So fix this race by making sure that the devlink instance is present
before any other operation.

Reported-by: Amir Tzin <amirtz@nvidia.com>
Fixes: b74c37fd35a2 ("selftests: netdevsim: add tests for devlink reload with resources")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230220132336.198597-1-jiri@resnulli.us
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/netdevsim/devlink.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index a08c02abde121..7f7d20f222070 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -17,6 +17,18 @@ SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
 DL_HANDLE=netdevsim/$DEV_NAME
 
+wait_for_devlink()
+{
+	"$@" | grep -q $DL_HANDLE
+}
+
+devlink_wait()
+{
+	local timeout=$1
+
+	busywait "$timeout" wait_for_devlink devlink dev
+}
+
 fw_flash_test()
 {
 	RET=0
@@ -256,6 +268,9 @@ netns_reload_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "netns reload test"
 }
 
@@ -348,6 +363,9 @@ resource_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "resource test"
 }
 
-- 
2.39.2



