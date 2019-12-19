Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CA31269A9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfLSSj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfLSSj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86EA206D7;
        Thu, 19 Dec 2019 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780797;
        bh=BiT/mqY3cYPx4Ex65wi0uSHH0MprkirSenCtSPsYEGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHFuEOdU+qn6lnX+yQCRIpvJUFWnDJM27+8w/xaD7JBS8cNX0vY+4hOVfWic84RPF
         iDkrpj5tTqCX8zgqutwmPPeuwhFn3ePO0ACDFTRW602uAU8v5f2mLxQDYgBTuNjCUs
         03vtqyLM/u0GdJMUbzuhK2PXRzGeKr4MGOwfi0MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 122/162] quota: fix livelock in dquot_writeback_dquots
Date:   Thu, 19 Dec 2019 19:33:50 +0100
Message-Id: <20191219183215.195885197@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
@@ -604,7 +604,7 @@ EXPORT_SYMBOL(dquot_scan_active);
 /* Write all dquot structures to quota files */
 int dquot_writeback_dquots(struct super_block *sb, int type)
 {
-	struct list_head *dirty;
+	struct list_head dirty;
 	struct dquot *dquot;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int cnt;
@@ -617,9 +617,10 @@ int dquot_writeback_dquots(struct super_
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
 			/* Dirty and inactive can be only bad dquot... */
 			if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {


