Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489521BCB3C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgD1Sb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgD1SbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3B220B80;
        Tue, 28 Apr 2020 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098682;
        bh=BHS3e/jKJugNA1/jaut3g7kvGJk+OFVAbUw+Z9klqcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8J4jPwMVIOdXgj4OJHACComnNsVPPSuzJZPKBhIap7wzbC+74aeYqqttmwdeGqPL
         L6DqC1edXcXUZer/CjVpl1nNp9rLfaAwGzlmW/bjRjHjKTxmf72V5iu2nUAd7/uIWM
         2Jp7J8KgQJMiEf5n4pQ5IeFh1Mdxv8h/W7Ruolm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Mendes <luis.p.mendes@gmail.com>
Subject: [PATCH 5.6 098/167] staging: gasket: Fix incongruency in handling of sysfs entries creation
Date:   Tue, 28 Apr 2020 20:24:34 +0200
Message-Id: <20200428182237.551378595@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Mendes <luis.p.mendes@gmail.com>

commit 9195d762042b0e5e4ded63606b4b30a93cba4400 upstream.

Fix incongruency in handling of sysfs entries creation.
This issue could cause invalid memory accesses, by not properly
detecting the end of the sysfs attributes array.

Fixes: 84c45d5f3bf1 ("staging: gasket: Replace macro __ATTR with __ATTR_NULL")
Signed-off-by: Luis Mendes <luis.p.mendes@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200403151534.20753-1-luis.p.mendes@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/gasket/gasket_sysfs.c |    3 +--
 drivers/staging/gasket/gasket_sysfs.h |    4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -228,8 +228,7 @@ int gasket_sysfs_create_entries(struct d
 	}
 
 	mutex_lock(&mapping->mutex);
-	for (i = 0; strcmp(attrs[i].attr.attr.name, GASKET_ARRAY_END_MARKER);
-		i++) {
+	for (i = 0; attrs[i].attr.attr.name != NULL; i++) {
 		if (mapping->attribute_count == GASKET_SYSFS_MAX_NODES) {
 			dev_err(device,
 				"Maximum number of sysfs nodes reached for device\n");
--- a/drivers/staging/gasket/gasket_sysfs.h
+++ b/drivers/staging/gasket/gasket_sysfs.h
@@ -30,10 +30,6 @@
  */
 #define GASKET_SYSFS_MAX_NODES 196
 
-/* End markers for sysfs struct arrays. */
-#define GASKET_ARRAY_END_TOKEN GASKET_RESERVED_ARRAY_END
-#define GASKET_ARRAY_END_MARKER __stringify(GASKET_ARRAY_END_TOKEN)
-
 /*
  * Terminator struct for a gasket_sysfs_attr array. Must be at the end of
  * all gasket_sysfs_attribute arrays.


