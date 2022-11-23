Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002CC635DDB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbiKWMuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237920AbiKWMtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:49:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E4474A95;
        Wed, 23 Nov 2022 04:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF9AEB81F31;
        Wed, 23 Nov 2022 12:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4950C433C1;
        Wed, 23 Nov 2022 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207416;
        bh=hgFrThZIfcHBiwNkmY0R/fI19wtC+GeruQrc2MOW8Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4pO5Bc0diGfrca0dcxCAVRJk5qVTX9MYxY7cFZt6GGdTLG/OZd9i/zwLa1XX+VEu
         GkLMS2Pzpg/0jjFoINETpj33beUToHrNrPcYRMnsjvm+ir+i7/8RZL6m1wEge7c0dq
         W5k0ehs07xKrNHoNa8ABz/ZXLH1+4hvHYHf58Vu4Fu3WgsAQAKXW8aWr97+eCRwC6F
         WbzCTSGWP4sfG3ED84y/VhzBZiz4YVw/fgAWZ3GZZdl5YJ5X9kkmEzrVtItSHrs1ce
         8Al6JVBZxcnE4H/79MRjIHKREgDW5WzHxExcO3071O09kzsulZZRcNUp9kMKn9ypya
         r5T5QtapycJkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 31/31] dm integrity: clear the journal on suspend
Date:   Wed, 23 Nov 2022 07:42:32 -0500
Message-Id: <20221123124234.265396-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 984bf2cc531e778e49298fdf6730e0396166aa21 ]

There was a problem that a user burned a dm-integrity image on CDROM
and could not activate it because it had a non-empty journal.

Fix this problem by flushing the journal (done by the previous commit)
and clearing the journal (done by this commit). Once the journal is
cleared, dm-integrity won't attempt to replay it on the next
activation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 761a40b0cc0c..5f51958e98de 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -259,6 +259,7 @@ struct dm_integrity_c {
 
 	struct completion crypto_backoff;
 
+	bool wrote_to_journal;
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
@@ -2361,6 +2362,8 @@ static void integrity_commit(struct work_struct *w)
 	if (!commit_sections)
 		goto release_flush_bios;
 
+	ic->wrote_to_journal = true;
+
 	i = commit_start;
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
@@ -3084,6 +3087,14 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
+		if (ic->wrote_to_journal) {
+			init_journal(ic, ic->free_section,
+				     ic->journal_sections - ic->free_section, ic->commit_seq);
+			if (ic->free_section) {
+				init_journal(ic, 0, ic->free_section,
+					     next_commit_seq(ic->commit_seq));
+			}
+		}
 	}
 
 	if (ic->mode == 'B') {
@@ -3111,6 +3122,8 @@ static void dm_integrity_resume(struct dm_target *ti)
 
 	DEBUG_print("resume\n");
 
+	ic->wrote_to_journal = false;
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
-- 
2.35.1

