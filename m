Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA09664949
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbjAJSU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbjAJSTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:19:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3E917E12
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8EFFB81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31428C433EF;
        Tue, 10 Jan 2023 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374626;
        bh=GQGUFmhYX1ymiYp2gW0b6dWHKW8PtEC70qugp1r+wK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9p2VnNg1w8AMIFhhEVUwVaDonIdu51Yc9sNCUmJD5MKm4La///4rGRb2SNmfm7eb
         RSN0ltkwm2oER8Ufiff7nmSmsBCIeAiwR2oUqxOlDrkWV96CVyykI3LgGa60pGPfju
         FqKtn9i3/jUGJ41qnh3Y4VS9Nr5b3RgLtRxbNZJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/159] selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier
Date:   Tue, 10 Jan 2023 19:03:47 +0100
Message-Id: <20230110180020.828346570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 1856628baa17032531916984808d1bdfd62700d4 ]

Return non-zero return value if there is any failure reported in this
script during the test. Otherwise it can only reflect the status of
the last command.

Fixes: f86ca07eb531 ("selftests: net: add arp_ndisc_evict_nocarrier")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/arp_ndisc_evict_nocarrier.sh        | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
index b4ec1eeee6c9..4a110bb01e53 100755
--- a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -18,6 +18,7 @@ readonly V4_ADDR1=10.0.10.2
 readonly V6_ADDR0=2001:db8:91::1
 readonly V6_ADDR1=2001:db8:91::2
 nsid=100
+ret=0
 
 cleanup_v6()
 {
@@ -61,7 +62,7 @@ setup_v6() {
     if [ $? -ne 0 ]; then
         cleanup_v6
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth2 down, which will put veth1 in NOCARRIER state
@@ -88,7 +89,7 @@ setup_v4() {
     if [ $? -ne 0 ]; then
         cleanup_v4
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth1 down, which will put veth0 in NOCARRIER state
@@ -115,6 +116,7 @@ run_arp_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -134,6 +136,7 @@ run_arp_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v4
@@ -164,6 +167,7 @@ run_ndisc_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -182,6 +186,7 @@ run_ndisc_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -198,6 +203,7 @@ run_ndisc_evict_nocarrier_disabled_all() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -218,3 +224,4 @@ if [ "$(id -u)" -ne 0 ];then
 fi
 
 run_all_tests
+exit $ret
-- 
2.35.1



