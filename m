Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C5859DBF7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351163AbiHWKno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356317AbiHWKlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B55A9270;
        Tue, 23 Aug 2022 02:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F43CB81C4E;
        Tue, 23 Aug 2022 09:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B9EC433C1;
        Tue, 23 Aug 2022 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245756;
        bh=Tmyi9bk+1bbxmTO9xBpQGKNVA74gTxDUx72W9Ihj6ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCWeV8WTpEl1XPHmCIGQwwI8D6qS+xCL/+f9YydMUp2Y1IMgWynNB9TiZoLpZEm7h
         FmhS8EsLwRUYf/odDrE7L9VO5uD7XDl9ElvLgwBzItTE2dY/wrlu2TOo1TTMPmW0db
         f8L1zHEdfVuCsfQJDsIF8SzO0I3LgQH0i25SPeLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/287] tools/thermal: Fix possible path truncations
Date:   Tue, 23 Aug 2022 10:25:49 +0200
Message-Id: <20220823080106.841588426@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 6c58cf40e3a1d2f47c09d3489857e9476316788a ]

A build with -D_FORTIFY_SOURCE=2 enabled will produce the following warnings:

sysfs.c:63:30: warning: '%s' directive output may be truncated writing up to 255 bytes into a region of size between 0 and 255 [-Wformat-truncation=]
  snprintf(filepath, 256, "%s/%s", path, filename);
                              ^~
Bump up the buffer to PATH_MAX which is the limit and account for all of
the possible NUL and separators that could lead to exceeding the
allocated buffer sizes.

Fixes: 94f69966faf8 ("tools/thermal: Introduce tmon, a tool for thermal subsystem")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/sysfs.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
index 18f523557983..1b17cbc54c9d 100644
--- a/tools/thermal/tmon/sysfs.c
+++ b/tools/thermal/tmon/sysfs.c
@@ -22,6 +22,7 @@
 #include <stdint.h>
 #include <dirent.h>
 #include <libintl.h>
+#include <limits.h>
 #include <ctype.h>
 #include <time.h>
 #include <syslog.h>
@@ -42,9 +43,9 @@ int sysfs_set_ulong(char *path, char *filename, unsigned long val)
 {
 	FILE *fd;
 	int ret = -1;
-	char filepath[256];
+	char filepath[PATH_MAX + 2]; /* NUL and '/' */
 
-	snprintf(filepath, 256, "%s/%s", path, filename);
+	snprintf(filepath, sizeof(filepath), "%s/%s", path, filename);
 
 	fd = fopen(filepath, "w");
 	if (!fd) {
@@ -66,9 +67,9 @@ static int sysfs_get_ulong(char *path, char *filename, unsigned long *p_ulong)
 {
 	FILE *fd;
 	int ret = -1;
-	char filepath[256];
+	char filepath[PATH_MAX + 2]; /* NUL and '/' */
 
-	snprintf(filepath, 256, "%s/%s", path, filename);
+	snprintf(filepath, sizeof(filepath), "%s/%s", path, filename);
 
 	fd = fopen(filepath, "r");
 	if (!fd) {
@@ -85,9 +86,9 @@ static int sysfs_get_string(char *path, char *filename, char *str)
 {
 	FILE *fd;
 	int ret = -1;
-	char filepath[256];
+	char filepath[PATH_MAX + 2]; /* NUL and '/' */
 
-	snprintf(filepath, 256, "%s/%s", path, filename);
+	snprintf(filepath, sizeof(filepath), "%s/%s", path, filename);
 
 	fd = fopen(filepath, "r");
 	if (!fd) {
@@ -208,8 +209,8 @@ static int find_tzone_cdev(struct dirent *nl, char *tz_name,
 {
 	unsigned long trip_instance = 0;
 	char cdev_name_linked[256];
-	char cdev_name[256];
-	char cdev_trip_name[256];
+	char cdev_name[PATH_MAX];
+	char cdev_trip_name[PATH_MAX];
 	int cdev_id;
 
 	if (nl->d_type == DT_LNK) {
@@ -222,7 +223,8 @@ static int find_tzone_cdev(struct dirent *nl, char *tz_name,
 			return -EINVAL;
 		}
 		/* find the link to real cooling device record binding */
-		snprintf(cdev_name, 256, "%s/%s", tz_name, nl->d_name);
+		snprintf(cdev_name, sizeof(cdev_name) - 2, "%s/%s",
+			 tz_name, nl->d_name);
 		memset(cdev_name_linked, 0, sizeof(cdev_name_linked));
 		if (readlink(cdev_name, cdev_name_linked,
 				sizeof(cdev_name_linked) - 1) != -1) {
@@ -235,8 +237,8 @@ static int find_tzone_cdev(struct dirent *nl, char *tz_name,
 			/* find the trip point in which the cdev is binded to
 			 * in this tzone
 			 */
-			snprintf(cdev_trip_name, 256, "%s%s", nl->d_name,
-				"_trip_point");
+			snprintf(cdev_trip_name, sizeof(cdev_trip_name) - 1,
+				"%s%s", nl->d_name, "_trip_point");
 			sysfs_get_ulong(tz_name, cdev_trip_name,
 					&trip_instance);
 			/* validate trip point range, e.g. trip could return -1
-- 
2.35.1



