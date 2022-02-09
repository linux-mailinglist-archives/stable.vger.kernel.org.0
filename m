Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5034AFA3A
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiBISfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239549AbiBISfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:35:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988DC05CBA5;
        Wed,  9 Feb 2022 10:35:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2613B82378;
        Wed,  9 Feb 2022 18:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A806FC340E7;
        Wed,  9 Feb 2022 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431738;
        bh=ThG/+Gd9ta56OPtFM3T/EEq/XFxpoRWYUP0PR2/q2SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gl/n5sARnAEzqop9HB0fBeqOTXvTY2e4PpDMwG1+t2zpOlfGph9mdIvYtyAW7Bf7Z
         VCHCjUNf6X31s1uqVbHIltQTCiy1ORbsgtrnmm7ZuFlspalJGhdoddYA4i1h0/GCm4
         0ZIijgp7pM4NPErxIfznQisYzR9lEbtEpo1ZAF+MP0DUP9py/3CHdVbIzNzrWDuyCf
         T0jz6UP29QGkyCOZ+0LMz4ZHF3E669K31xaTG97fLOAV3/rt4s97p26UIGGWbpXG9N
         024YsZwFrPq9iZUasq8aRcQYgFsPzySH48on0WYGPSJze90wc8s9WOIRE7DXiil4yb
         LLzS6+rFBU43Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.16 19/42] cifs: unlock chan_lock before calling cifs_put_tcp_session
Date:   Wed,  9 Feb 2022 13:32:51 -0500
Message-Id: <20220209183335.46545-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 489f710a738e24d887823a010b8b206b4124e26f ]

While removing an smb session, we need to free up the
tcp session for each channel for that session. We were
doing this with chan_lock held. This results in a
cyclic dependency with cifs_tcp_ses_lock.

For now, unlock the chan_lock temporarily before calling
cifs_put_tcp_session. This should not cause any problem
for now, since we do not remove channels anywhere else.
And this code segment will not be called by two threads.

When we do implement the code for removing channels, we
will need to execute proper ref counting here.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1060164b984a7..4c8db1a91e940 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1796,13 +1796,9 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 		int i;
 
 		for (i = 1; i < chan_count; i++) {
-			/*
-			 * note: for now, we're okay accessing ses->chans
-			 * without chan_lock. But when chans can go away, we'll
-			 * need to introduce ref counting to make sure that chan
-			 * is not freed from under us.
-			 */
+			spin_unlock(&ses->chan_lock);
 			cifs_put_tcp_session(ses->chans[i].server, 0);
+			spin_lock(&ses->chan_lock);
 			ses->chans[i].server = NULL;
 		}
 	}
-- 
2.34.1

