Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F416B6BB224
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjCOMdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjCOMdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FED211D4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3569ACE19C5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F92DC433EF;
        Wed, 15 Mar 2023 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883530;
        bh=rdwxLvOfmcogiHk7y2Ql11OSRBzlXNwvHkL5uL0EAA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8xzaiWJou9u1sUAJnAdsTIP7s0SiFSAPQ49RiPdAibJqdosleUGKRdtvLswmICFb
         6OQsY8Lu1JYXJwxRahrKI6DPGqZ472Ra4ivuYZsPRhYLXPrfQcp5Da2tAMIO2trn6l
         rZ50ZHRm/DKjsStfHwC4hPSKF+v2fbY97PTljT6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/143] fs: dlm: remove send repeat remove handling
Date:   Wed, 15 Mar 2023 13:11:59 +0100
Message-Id: <20230315115741.512638188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 57a5724ef0b332eb6e78250157910a006b01bf6e ]

This patch removes the send repeat remove handling. This handling is
there to repeatingly DLM_MSG_REMOVE messages in cases the dlm stack
thinks it was not received at the first time. In cases of message drops
this functionality is necessary, but since the DLM midcomms layer
guarantees there are no messages drops between cluster nodes this
feature became not strict necessary anymore. Due message
delays/processing it could be that two send_repeat_remove() are sent out
while the other should be still on it's way. We remove the repeat remove
handling because we are sure that the message cannot be dropped due
communication errors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 724b6bab0d75 ("fs: dlm: fix use after free in midcomms commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 74 ---------------------------------------------------
 1 file changed, 74 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 94a72ede57646..b246d71b5e17a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4044,66 +4044,6 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 	return error;
 }
 
-static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
-{
-	char name[DLM_RESNAME_MAXLEN + 1];
-	struct dlm_message *ms;
-	struct dlm_mhandle *mh;
-	struct dlm_rsb *r;
-	uint32_t hash, b;
-	int rv, dir_nodeid;
-
-	memset(name, 0, sizeof(name));
-	memcpy(name, ms_name, len);
-
-	hash = jhash(name, len, 0);
-	b = hash & (ls->ls_rsbtbl_size - 1);
-
-	dir_nodeid = dlm_hash2nodeid(ls, hash);
-
-	log_error(ls, "send_repeat_remove dir %d %s", dir_nodeid, name);
-
-	spin_lock(&ls->ls_rsbtbl[b].lock);
-	rv = dlm_search_rsb_tree(&ls->ls_rsbtbl[b].keep, name, len, &r);
-	if (!rv) {
-		spin_unlock(&ls->ls_rsbtbl[b].lock);
-		log_error(ls, "repeat_remove on keep %s", name);
-		return;
-	}
-
-	rv = dlm_search_rsb_tree(&ls->ls_rsbtbl[b].toss, name, len, &r);
-	if (!rv) {
-		spin_unlock(&ls->ls_rsbtbl[b].lock);
-		log_error(ls, "repeat_remove on toss %s", name);
-		return;
-	}
-
-	/* use ls->remove_name2 to avoid conflict with shrink? */
-
-	spin_lock(&ls->ls_remove_spin);
-	ls->ls_remove_len = len;
-	memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
-	spin_unlock(&ls->ls_remove_spin);
-	spin_unlock(&ls->ls_rsbtbl[b].lock);
-
-	rv = _create_message(ls, sizeof(struct dlm_message) + len,
-			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
-	if (rv)
-		goto out;
-
-	memcpy(ms->m_extra, name, len);
-	ms->m_hash = cpu_to_le32(hash);
-
-	send_message(mh, ms);
-
-out:
-	spin_lock(&ls->ls_remove_spin);
-	ls->ls_remove_len = 0;
-	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
-	spin_unlock(&ls->ls_remove_spin);
-	wake_up(&ls->ls_remove_wait);
-}
-
 static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
@@ -4173,25 +4113,11 @@ static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 	   ENOTBLK request failures when the lookup reply designating us
 	   as master is delayed. */
 
-	/* We could repeatedly return -EBADR here if our send_remove() is
-	   delayed in being sent/arriving/being processed on the dir node.
-	   Another node would repeatedly lookup up the master, and the dir
-	   node would continue returning our nodeid until our send_remove
-	   took effect.
-
-	   We send another remove message in case our previous send_remove
-	   was lost/ignored/missed somehow. */
-
 	if (error != -ENOTBLK) {
 		log_limit(ls, "receive_request %x from %d %d",
 			  le32_to_cpu(ms->m_lkid), from_nodeid, error);
 	}
 
-	if (namelen && error == -EBADR) {
-		send_repeat_remove(ls, ms->m_extra, namelen);
-		msleep(1000);
-	}
-
 	setup_stub_lkb(ls, ms);
 	send_request_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
 	return error;
-- 
2.39.2



