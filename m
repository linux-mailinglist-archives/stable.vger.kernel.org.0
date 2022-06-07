Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32965541E02
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351616AbiFGWWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358031AbiFGWVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991C326D275;
        Tue,  7 Jun 2022 12:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CB89CE2476;
        Tue,  7 Jun 2022 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E233EC385A2;
        Tue,  7 Jun 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629747;
        bh=DerCkNsI2Cf3QemMT/beBdirNFSwUzXe5oOGb6F9b4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLGqbIlEpTRqjEEQxW7IRL55tmHEpAT/+aB7/22wQCdVwjIM9VlhhgOPJAJCPYTEN
         Jd+5gLjqcO7PsbMDFRNqgEjB06meZrRnd4vD2pB8DcjIeNjYiAcc5F7ZMsSR1jrocp
         t+JRWDyNAB3+D0y3ZuqK1g1+8h85Dof7T4TCAzPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.18 765/879] dlm: fix wake_up() calls for pending remove
Date:   Tue,  7 Jun 2022 19:04:43 +0200
Message-Id: <20220607165025.068730715@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit f6f7418357457ed58cbb020fc97e74d4e0e7b47f upstream.

This patch move the wake_up() call at the point when a remove message
completed. Before it was only when a remove message was going to be
sent. The possible waiter in wait_pending_remove() waits until a remove
is done if the resource name matches with the per ls variable
ls->ls_remove_name. If this is the case we must wait until a pending
remove is done which is indicated if DLM_WAIT_PENDING_COND() returns
false which will always be the case when ls_remove_len and
ls_remove_name are unset to indicate that a remove is not going on
anymore.

Fixes: 21d9ac1a5376 ("fs: dlm: use event based wait for pending remove")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1795,7 +1795,6 @@ static void shrink_bucket(struct dlm_ls
 		memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
 		spin_unlock(&ls->ls_remove_spin);
 		spin_unlock(&ls->ls_rsbtbl[b].lock);
-		wake_up(&ls->ls_remove_wait);
 
 		send_remove(r);
 
@@ -1804,6 +1803,7 @@ static void shrink_bucket(struct dlm_ls
 		ls->ls_remove_len = 0;
 		memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
 		spin_unlock(&ls->ls_remove_spin);
+		wake_up(&ls->ls_remove_wait);
 
 		dlm_free_rsb(r);
 	}
@@ -4079,7 +4079,6 @@ static void send_repeat_remove(struct dl
 	memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
 	spin_unlock(&ls->ls_remove_spin);
 	spin_unlock(&ls->ls_rsbtbl[b].lock);
-	wake_up(&ls->ls_remove_wait);
 
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
@@ -4095,6 +4094,7 @@ static void send_repeat_remove(struct dl
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
 	spin_unlock(&ls->ls_remove_spin);
+	wake_up(&ls->ls_remove_wait);
 }
 
 static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)


