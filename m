Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA33B582D21
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiG0QzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiG0QyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:54:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94527550B2;
        Wed, 27 Jul 2022 09:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7046B8200C;
        Wed, 27 Jul 2022 16:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C22BC433D6;
        Wed, 27 Jul 2022 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939732;
        bh=MS8D/rpR7mdKdbSsWN6KYy41jmHuV1eXxUbNByvPQLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSC4PdrLhGWJyt3MzoKvkEn3dQmjJai/r0Jfj67pzP4aCMgc7UNfSN1Tmmz/rUgwU
         /1QFSZDm8K1haaEF9KekwoY7ZDfblPqf3w0I2U8lr0nSLpg+MD8cEPjjYYZ5438wKE
         sCFQsDXgqxeNl/0fUKNvDqcH2+jf7ZaAqbwU56BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/105] dlm: fix pending remove if msg allocation fails
Date:   Wed, 27 Jul 2022 18:11:09 +0200
Message-Id: <20220727161015.429459308@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit ba58995909b5098ca4003af65b0ccd5a8d13dd25 ]

This patch unsets ls_remove_len and ls_remove_name if a message
allocation of a remove messages fails. In this case we never send a
remove message out but set the per ls ls_remove_len ls_remove_name
variable for a pending remove. Unset those variable should indicate
possible waiters in wait_pending_remove() that no pending remove is
going on at this moment.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2ce96a9ce63c..eaa28d654e9f 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4067,13 +4067,14 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
 	if (rv)
-		return;
+		goto out;
 
 	memcpy(ms->m_extra, name, len);
 	ms->m_hash = hash;
 
 	send_message(mh, ms);
 
+out:
 	spin_lock(&ls->ls_remove_spin);
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
-- 
2.35.1



