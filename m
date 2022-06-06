Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5011C53E870
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiFFM11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiFFM1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:27:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB74AC12
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70929611CC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74722C34119;
        Mon,  6 Jun 2022 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518439;
        bh=9Hzwf4wjnNSIkP9RYhzNtlnSSAnm0qxFIy4UFyb9j2s=;
        h=Subject:To:Cc:From:Date:From;
        b=USAowG+8ZWBGixWbrV7P55A9Yl0v5VHwjJ7VdiDWZq8nNMUN9zCFe8x3MbgA18cIb
         XENblufAGLjuUJKL9H+nzrLaTL97OtMBeu/cj0Qh3clJwfidDBDt2dQItcy4dnOnva
         ROkoRi4V0+taMWfv2PwoK2i0sofxNG17Art35F+c=
Subject: FAILED: patch "[PATCH] dlm: fix pending remove if msg allocation fails" failed to apply to 5.15-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:27:06 +0200
Message-ID: <1654518426211167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba58995909b5098ca4003af65b0ccd5a8d13dd25 Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 6 Apr 2022 13:34:16 -0400
Subject: [PATCH] dlm: fix pending remove if msg allocation fails

This patch unsets ls_remove_len and ls_remove_name if a message
allocation of a remove messages fails. In this case we never send a
remove message out but set the per ls ls_remove_len ls_remove_name
variable for a pending remove. Unset those variable should indicate
possible waiters in wait_pending_remove() that no pending remove is
going on at this moment.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 137cf09b51e5..f5330e58d1fc 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4100,13 +4100,14 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
 	if (rv)
-		return;
+		goto out;
 
 	memcpy(ms->m_extra, name, len);
 	ms->m_hash = cpu_to_le32(hash);
 
 	send_message(mh, ms);
 
+out:
 	spin_lock(&ls->ls_remove_spin);
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);

