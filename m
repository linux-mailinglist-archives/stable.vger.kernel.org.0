Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D8812159A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbfLPSUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732101AbfLPSUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29F86207FF;
        Mon, 16 Dec 2019 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520431;
        bh=3moiQoxxvNMC+stxxb5nQ7tU8bHiKDEQTcfdzncWdX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+wWsfBHFxdsjNxaMSmIkhw2HJBTySMvo8fdKm3bKp5j2MfUxBm8mxjdpnyv1Yydi
         FJjStF+ShPWXRD/deIJQGIF84rjurt9MM/eX9qzArDStJcF2s9c3UdqvMLDxwyjq43
         irBUXkTXouv7W3kZaSE7lrRRWHBgQnU0SfSFazmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 152/177] quota: fix livelock in dquot_writeback_dquots
Date:   Mon, 16 Dec 2019 18:50:08 +0100
Message-Id: <20191216174848.112470783@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

commit 6ff33d99fc5c96797103b48b7b0902c296f09c05 upstream.

Write only quotas which are dirty at entry.

XFSTEST: https://github.com/dmonakhov/xfstests/commit/b10ad23566a5bf75832a6f500e1236084083cddc

Link: https://lore.kernel.org/r/20191031103920.3919-1-dmonakhov@openvz.org
CC: stable@vger.kernel.org
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/dquot.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -623,7 +623,7 @@ EXPORT_SYMBOL(dquot_scan_active);
 /* Write all dquot structures to quota files */
 int dquot_writeback_dquots(struct super_block *sb, int type)
 {
-	struct list_head *dirty;
+	struct list_head dirty;
 	struct dquot *dquot;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int cnt;
@@ -637,9 +637,10 @@ int dquot_writeback_dquots(struct super_
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
 		spin_lock(&dq_list_lock);
-		dirty = &dqopt->info[cnt].dqi_dirty_list;
-		while (!list_empty(dirty)) {
-			dquot = list_first_entry(dirty, struct dquot,
+		/* Move list away to avoid livelock. */
+		list_replace_init(&dqopt->info[cnt].dqi_dirty_list, &dirty);
+		while (!list_empty(&dirty)) {
+			dquot = list_first_entry(&dirty, struct dquot,
 						 dq_dirty);
 
 			WARN_ON(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));


