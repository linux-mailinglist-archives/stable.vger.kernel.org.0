Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655A828924
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391774AbfEWTbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403757AbfEWTbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D12F2054F;
        Thu, 23 May 2019 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639863;
        bh=nzeW2X+X5V2hvChwOFElfChmral2wiPC7L2Eajqvbp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pA7EMfbsHctIzouoF7F5JUaxskX/iQ/xDknL8yZxH05T3Sr0DWgrUkARGSmXZql+X
         WAYEe8ChvaJCPD5hmwG5JiprJ87JkddtLBls3q+FpYJkGf53b0gB2OVdHycbN8fxOw
         tF2BfTiLJ68sy8RQ1oW8Xuj08FD1nHJYbJvXfBd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 104/122] dm init: fix max devices/targets checks
Date:   Thu, 23 May 2019 21:07:06 +0200
Message-Id: <20190523181719.105819177@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit 8e890c1ab1b1e0f765cd8da82c4dee011698a5e8 upstream.

dm-init should allow up to DM_MAX_{DEVICES,TARGETS} for devices/targets,
and not DM_MAX_{DEVICES,TARGETS} - 1.

Fix the checks and also fix the error message when the number of devices
is surpassed.

Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -160,7 +160,7 @@ static int __init dm_parse_table(struct
 
 	while (table_entry) {
 		DMDEBUG("parsing table \"%s\"", str);
-		if (++dev->dmi.target_count >= DM_MAX_TARGETS) {
+		if (++dev->dmi.target_count > DM_MAX_TARGETS) {
 			DMERR("too many targets %u > %d",
 			      dev->dmi.target_count, DM_MAX_TARGETS);
 			return -EINVAL;
@@ -242,9 +242,9 @@ static int __init dm_parse_devices(struc
 			return -ENOMEM;
 		list_add_tail(&dev->list, devices);
 
-		if (++ndev >= DM_MAX_DEVICES) {
-			DMERR("too many targets %u > %d",
-			      dev->dmi.target_count, DM_MAX_TARGETS);
+		if (++ndev > DM_MAX_DEVICES) {
+			DMERR("too many devices %lu > %d",
+			      ndev, DM_MAX_DEVICES);
 			return -EINVAL;
 		}
 


