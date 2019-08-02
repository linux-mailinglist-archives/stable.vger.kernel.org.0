Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A097F46F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391237AbfHBJct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391265AbfHBJcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:32:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D884F217D7;
        Fri,  2 Aug 2019 09:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738364;
        bh=wCN9HXtJSNEkJX/RR8719ZXt4WF6bm9SR0FQgJQhU0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMOxl+NhvjH2aRpo49u5cD1Sn1WlU4wtfbn4BlxUxMMEDJN+B4i1h2RoPU6BjS5zy
         v4lExqwQHGMHdzINHw43vg26vYauUJadw8hA0Yr2Uk/ZPZkdaOsFEEg4rzUtBBp7AY
         SrpaMNCdlUViH9k51uR1Ia8uveo2Qrk6522/hDEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grant Hernandez <granthernandez@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 058/158] Input: gtco - bounds check collection indent level
Date:   Fri,  2 Aug 2019 11:27:59 +0200
Message-Id: <20190802092215.847417263@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grant Hernandez <granthernandez@google.com>

commit 2a017fd82c5402b3c8df5e3d6e5165d9e6147dc1 upstream.

The GTCO tablet input driver configures itself from an HID report sent
via USB during the initial enumeration process. Some debugging messages
are generated during the parsing. A debugging message indentation
counter is not bounds checked, leading to the ability for a specially
crafted HID report to cause '-' and null bytes be written past the end
of the indentation array. As long as the kernel has CONFIG_DYNAMIC_DEBUG
enabled, this code will not be optimized out.  This was discovered
during code review after a previous syzkaller bug was found in this
driver.

Signed-off-by: Grant Hernandez <granthernandez@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/gtco.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -78,6 +78,7 @@ Scott Hill shill@gtcocalcomp.com
 
 /* Max size of a single report */
 #define REPORT_MAX_SIZE       10
+#define MAX_COLLECTION_LEVELS  10
 
 
 /* Bitmask whether pen is in range */
@@ -224,8 +225,7 @@ static void parse_hid_report_descriptor(
 	char  maintype = 'x';
 	char  globtype[12];
 	int   indent = 0;
-	char  indentstr[10] = "";
-
+	char  indentstr[MAX_COLLECTION_LEVELS + 1] = { 0 };
 
 	dev_dbg(ddev, "======>>>>>>PARSE<<<<<<======\n");
 
@@ -351,6 +351,13 @@ static void parse_hid_report_descriptor(
 			case TAG_MAIN_COL_START:
 				maintype = 'S';
 
+				if (indent == MAX_COLLECTION_LEVELS) {
+					dev_err(ddev, "Collection level %d would exceed limit of %d\n",
+						indent + 1,
+						MAX_COLLECTION_LEVELS);
+					break;
+				}
+
 				if (data == 0) {
 					dev_dbg(ddev, "======>>>>>> Physical\n");
 					strcpy(globtype, "Physical");
@@ -370,8 +377,15 @@ static void parse_hid_report_descriptor(
 				break;
 
 			case TAG_MAIN_COL_END:
-				dev_dbg(ddev, "<<<<<<======\n");
 				maintype = 'E';
+
+				if (indent == 0) {
+					dev_err(ddev, "Collection level already at zero\n");
+					break;
+				}
+
+				dev_dbg(ddev, "<<<<<<======\n");
+
 				indent--;
 				for (x = 0; x < indent; x++)
 					indentstr[x] = '-';


