Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FCC38A665
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhETK02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236814AbhETKYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C114561C18;
        Thu, 20 May 2021 09:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504171;
        bh=7VcG0lWkhYG2Zht8kzAcgvLD5mz/r4+3sgLPA3nHlW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/nVsHBcIkonHaBnQ61JjsXIY+lbpdb/isV48VVKd3M/REcjT24c3a1+FpdkL3UM9
         PWJQb/m6me3wB9mhtGfjkfRm2uzmdfD+2EIjQIN+g3ILm/xC0H7AKKdCKul0UbTsfl
         +nyEZwymiTuwFIvNmUtKpthPUX/x35IAhsHSrNUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heming Zhao <heming.zhao@suse.com>,
        Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Subject: [PATCH 4.14 123/323] md: factor out a mddev_find_locked helper from mddev_find
Date:   Thu, 20 May 2021 11:20:15 +0200
Message-Id: <20210520092124.326124153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 8b57251f9a91f5e5a599de7549915d2d226cc3af upstream.

Factor out a self-contained helper to just lookup a mddev by the dev_t
"unit".

Cc: stable@vger.kernel.org
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -568,6 +568,17 @@ void mddev_init(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
+static struct mddev *mddev_find_locked(dev_t unit)
+{
+	struct mddev *mddev;
+
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
+		if (mddev->unit == unit)
+			return mddev;
+
+	return NULL;
+}
+
 static struct mddev *mddev_find(dev_t unit)
 {
 	struct mddev *mddev;
@@ -595,13 +606,13 @@ static struct mddev *mddev_find_or_alloc
 	spin_lock(&all_mddevs_lock);
 
 	if (unit) {
-		list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-			if (mddev->unit == unit) {
-				mddev_get(mddev);
-				spin_unlock(&all_mddevs_lock);
-				kfree(new);
-				return mddev;
-			}
+		mddev = mddev_find_locked(unit);
+		if (mddev) {
+			mddev_get(mddev);
+			spin_unlock(&all_mddevs_lock);
+			kfree(new);
+			return mddev;
+		}
 
 		if (new) {
 			list_add(&new->all_mddevs, &all_mddevs);
@@ -627,12 +638,7 @@ static struct mddev *mddev_find_or_alloc
 				return NULL;
 			}
 
-			is_free = 1;
-			list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-				if (mddev->unit == dev) {
-					is_free = 0;
-					break;
-				}
+			is_free = !mddev_find_locked(dev);
 		}
 		new->unit = dev;
 		new->md_minor = MINOR(dev);


