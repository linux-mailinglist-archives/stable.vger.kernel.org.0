Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD76553D0A
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355434AbiFUVBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355143AbiFUU5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F031DE2;
        Tue, 21 Jun 2022 13:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76673B81B01;
        Tue, 21 Jun 2022 20:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DEAC36AE2;
        Tue, 21 Jun 2022 20:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844639;
        bh=2Qm9XYXzw72rkhJkvitrb4JwhizBopoPWwDpsBfUxN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+kbUx1Jm/kknMgcRmUHo0wFvq/dmWFKPLaTFkmnAPI/c3Pl7zdg5H27go61CNwwG
         x9GISQ+zsSBBn7ZCxOnw3NqLkddL1Gt35jhwXodd8tZaiv/fbNzU2XQM29wOpIp3Ey
         FkqpuWkGLYo7ZtpRauVwmknFVnoaz6Cz/cEARJWOd5DBxIMzvd8L3eKqSFEbdgT2uQ
         Lo453Cr5yQr+QS8av6eUCI5qhzIWTI7ezhNN6Q0WwPkHeTvda+rVt0mmTwinZxeyvy
         pd2soLU22SQ6OUsoTZu5K0jcMAErksuAJgfJt4CVDK23qDNnBCfPXhHhIhAXltncQV
         xzOqSPpX02U2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 19/20] cifs: when a channel is not found for server, log its connection id
Date:   Tue, 21 Jun 2022 16:50:09 -0400
Message-Id: <20220621205010.250185-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 5d24968f5b7e00bae564b1646c3b9e0e3750aabe ]

cifs_ses_get_chan_index gets the index for a given server pointer.
When a match is not found, we warn about a possible bug.
However, printing details about the non-matching server could be
more useful to debug here.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 822da5689166..cdc3781a6c3b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -81,6 +81,9 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 	}
 
 	/* If we didn't find the channel, it is likely a bug */
+	if (server)
+		cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
+			 server->conn_id);
 	WARN_ON(1);
 	return 0;
 }
-- 
2.35.1

