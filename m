Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752606C16D3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjCTPJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjCTPJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20473AF0C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68132B80ECD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9A5C433EF;
        Mon, 20 Mar 2023 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324665;
        bh=zJPoiUz+eSYowOj0w9IvhiD1PniUzDXyLRXaDGr4xP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhq+9Oj4+wfspDpMCMoQyqsxUBxV00MGRA4DxpjmTzqepDBmMSlOPGD1L61tePP5w
         0RSYyxL6PwdD2finHHUy++CBDWpft/PlLKX+qym6z0VWylfczpgsVQpIt07+TC+PUn
         39n4Bk4ft2LxmbcQON2C9+fMzDwnlN5WHGQjGb/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/99] selftests: net: devlink_port_split.py: skip test if no suitable device available
Date:   Mon, 20 Mar 2023 15:54:15 +0100
Message-Id: <20230320145444.920810293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 24994513ad13ff2c47ba91d2b5df82c3d496c370 ]

The `devlink -j port show` command output may not contain the "flavour"
key, an example from Ubuntu 22.10 s390x LPAR(5.19.0-37-generic), with
mlx4 driver and iproute2-5.15.0:
  {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
           "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
           "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
           "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}

This will cause a KeyError exception.

Create a validate_devlink_output() to check for this "flavour" from
devlink command output to avoid this KeyError exception. Also let
it handle the check for `devlink -j dev show` output in main().

Apart from this, if the test was not started because the max lanes of
the designated device is 0. The script will still return 0 and thus
causing a false-negative test result.

Use a found_max_lanes flag to determine if these tests were skipped
due to this reason and return KSFT_SKIP to make it more clear.

Link: https://bugs.launchpad.net/bugs/1937133
Fixes: f3348a82e727 ("selftests: net: Add port split test")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Link: https://lore.kernel.org/r/20230315165353.229590-1-po-hsu.lin@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/devlink_port_split.py       | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 834066d465fc1..f0fbd7367f4f6 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -57,6 +57,8 @@ class devlink_ports(object):
         assert stderr == ""
         ports = json.loads(stdout)['port']
 
+        validate_devlink_output(ports, 'flavour')
+
         for port in ports:
             if dev in port:
                 if ports[port]['flavour'] == 'physical':
@@ -218,6 +220,27 @@ def split_splittable_port(port, k, lanes, dev):
     unsplit(port.bus_info)
 
 
+def validate_devlink_output(devlink_data, target_property=None):
+    """
+    Determine if test should be skipped by checking:
+      1. devlink_data contains values
+      2. The target_property exist in devlink_data
+    """
+    skip_reason = None
+    if any(devlink_data.values()):
+        if target_property:
+            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
+            for key in devlink_data:
+                if target_property in devlink_data[key]:
+                    skip_reason = None
+    else:
+        skip_reason = 'devlink output is empty, test skipped'
+
+    if skip_reason:
+        print(skip_reason)
+        sys.exit(KSFT_SKIP)
+
+
 def make_parser():
     parser = argparse.ArgumentParser(description='A test for port splitting.')
     parser.add_argument('--dev',
@@ -238,6 +261,7 @@ def main(cmdline=None):
         stdout, stderr = run_command(cmd)
         assert stderr == ""
 
+        validate_devlink_output(json.loads(stdout))
         devs = json.loads(stdout)['dev']
         dev = list(devs.keys())[0]
 
@@ -249,6 +273,7 @@ def main(cmdline=None):
 
     ports = devlink_ports(dev)
 
+    found_max_lanes = False
     for port in ports.if_names:
         max_lanes = get_max_lanes(port.name)
 
@@ -271,6 +296,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        found_max_lanes = True
+
+    if not found_max_lanes:
+        print(f"Test not started, no port of device {dev} reports max_lanes")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
-- 
2.39.2



