Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BFE26B3E4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgIOXMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44091206C9;
        Tue, 15 Sep 2020 14:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180230;
        bh=xW9liJaxqgaUSCMWwyrHZnak/GMUg57/bVOp4oy6rUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbmf7kVsUe4VskDc2CEKCNKnXCdUed/2R6OupoIDiAQ1yGNHFZhG2adIBY+ebJrpq
         ffqb6vpUSoCrWxozfR5nz6eCHBQSFpuhsyjSkbMhh+WMYGN6qVpzTPQgI81/vLa+Bl
         uluXGmMfPnkvJzpafREwFpZ6EJsYUufA6DcSvhNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 5.8 160/177] debugfs: Fix module state check condition
Date:   Tue, 15 Sep 2020 16:13:51 +0200
Message-Id: <20200915140701.362722769@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

commit e3b9fc7eec55e6fdc8beeed18f2ed207086341e2 upstream.

The '#ifdef MODULE' check in the original commit does not work as intended.
The code under the check is not built at all if CONFIG_DEBUG_FS=y. Fix this
by using a correct check.

Fixes: 275678e7a9be ("debugfs: Check module state before warning in {full/open}_proxy_open()")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811150129.53343-1-vdronov@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/debugfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -177,7 +177,7 @@ static int open_proxy_open(struct inode
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;
@@ -312,7 +312,7 @@ static int full_proxy_open(struct inode
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;


