Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE26C5603
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjCVUCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCVUCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:02:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06B06BC25;
        Wed, 22 Mar 2023 12:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF99B62276;
        Wed, 22 Mar 2023 19:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14074C433D2;
        Wed, 22 Mar 2023 19:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515146;
        bh=UgHQf1efIHBgU4uG2r7B5JWlDxv2+s1TXxnzspAXBoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1Q/jEYlGkQ+f4jM7md3oa4a+wDHkauElMlagZDT54QFqXQ5B2yY9dfrRnnNCmS72
         bVRGKZuxWZfxEYZ/83n6Rz2QSDf363kWYnunvnOwCIUJtICfktoGwyISneFs+b2ISR
         LVxc/2NMlmDX495wtaXvu04PdVs0zNLy1k9ZnbOIZ4cz1cU2poo0Smp7WZzMcWLcYQ
         AnUBaUMgvOxiC6SJfvFs1K8Ksa58/LjNHJ9M3BLbVYMnjobef0i17mvDoGMVXKey6N
         mPZ30SYrMA3HzMUuVKCPTjahdpO9u2OdWhN8066AZ1DAzF/5xLgjtZictZRsBIJVgU
         8o3ZTvNqGSlnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>,
        Hariganesh Govindarajulu <hariganesh.govindarajulu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        junming@nfschina.com, linux-acpi@vger.kernel.org,
        acpica-devel@lists.linuxfoundation.org
Subject: [PATCH AUTOSEL 6.2 33/45] ACPI: tools: pfrut: Check if the input of level and type is in the right numeric range
Date:   Wed, 22 Mar 2023 15:56:27 -0400
Message-Id: <20230322195639.1995821-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 0bc23d8b2237a104d7f8379d687aa4cb82e2968b ]

The user provides arbitrary non-numeic value to level and type,
which could bring unexpected behavior. In this case the expected
behavior would be to throw an error.

 pfrut -h
usage: pfrut [OPTIONS]
code injection:
-l, --load
-s, --stage
-a, --activate
-u, --update [stage and activate]
-q, --query
-d, --revid
update telemetry:
-G, --getloginfo
-T, --type(0:execution, 1:history)
-L, --level(0, 1, 2, 4)
-R, --read
-D, --revid log

 pfrut -T A
 pfrut -G
log_level:0
log_type:0
log_revid:2
max_data_size:65536
chunk1_size:0
chunk2_size:1530
rollover_cnt:0
reset_cnt:17

Fix this by restricting the input to be in the expected range.

Reported-by: Hariganesh Govindarajulu <hariganesh.govindarajulu@intel.com>
Suggested-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/acpi/tools/pfrut/pfrut.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/power/acpi/tools/pfrut/pfrut.c b/tools/power/acpi/tools/pfrut/pfrut.c
index 52aa0351533c3..388c9e3ad0407 100644
--- a/tools/power/acpi/tools/pfrut/pfrut.c
+++ b/tools/power/acpi/tools/pfrut/pfrut.c
@@ -97,7 +97,7 @@ static struct option long_options[] = {
 static void parse_options(int argc, char **argv)
 {
 	int option_index = 0;
-	char *pathname;
+	char *pathname, *endptr;
 	int opt;
 
 	pathname = strdup(argv[0]);
@@ -125,11 +125,23 @@ static void parse_options(int argc, char **argv)
 			log_getinfo = 1;
 			break;
 		case 'T':
-			log_type = atoi(optarg);
+			log_type = strtol(optarg, &endptr, 0);
+			if (*endptr || (log_type != 0 && log_type != 1)) {
+				printf("Number expected: type(0:execution, 1:history) - Quit.\n");
+				exit(1);
+			}
+
 			set_log_type = 1;
 			break;
 		case 'L':
-			log_level = atoi(optarg);
+			log_level = strtol(optarg, &endptr, 0);
+			if (*endptr ||
+			    (log_level != 0 && log_level != 1 &&
+			     log_level != 2 && log_level != 4)) {
+				printf("Number expected: level(0, 1, 2, 4) - Quit.\n");
+				exit(1);
+			}
+
 			set_log_level = 1;
 			break;
 		case 'R':
-- 
2.39.2

