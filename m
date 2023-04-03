Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C766D4A47
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjDCOpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjDCOps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F339618271
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ADAA61EF1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3100C433D2;
        Mon,  3 Apr 2023 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533085;
        bh=UgHQf1efIHBgU4uG2r7B5JWlDxv2+s1TXxnzspAXBoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq3pfn7qtjhJt9Og6t9860PylIf11khMp/6Awln8hlTU4RLq1tPpJ5equbOgVfwM8
         /Gxmz5Ppu6CSFFpsSCB0Y/C0EQtFG4NT+M4RN5OkJENkeJ6A/kjqRmclEik3u8fTkF
         0INOJPYkAYfejNUu8V8JuHWzACXxYQNSsqUph/hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Hariganesh Govindarajulu <hariganesh.govindarajulu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/187] ACPI: tools: pfrut: Check if the input of level and type is in the right numeric range
Date:   Mon,  3 Apr 2023 16:08:12 +0200
Message-Id: <20230403140417.529337533@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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



