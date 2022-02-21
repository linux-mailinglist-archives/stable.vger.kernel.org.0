Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6794BDE1C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351693AbiBUJug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352484AbiBUJrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A8033E06;
        Mon, 21 Feb 2022 01:20:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68B79CE0E7D;
        Mon, 21 Feb 2022 09:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA9BC340E9;
        Mon, 21 Feb 2022 09:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435198;
        bh=qxGRsbf8hg4HMax8tspTmAjZi7JK5DAqGQ7B8X5vXhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOKdH0ZYSCWxUOrauxEonVjETKzN95Cf2ObjwnecooXxNEvlLgd54s8ZH5HCnpwI5
         ehwzeR1usqgCrP/+x/nui3f/n5LlmUz4Acp9zUkkaDxCHlAgtHBM5xSl31lGiEV6Gl
         czIKOyOxnbkjwL4nPcxJA+mbXIMoRflZHZvSKk8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 048/227] cifs: unlock chan_lock before calling cifs_put_tcp_session
Date:   Mon, 21 Feb 2022 09:47:47 +0100
Message-Id: <20220221084936.475750953@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cefd0e9623ba9..fb69524a992bb 100644
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



