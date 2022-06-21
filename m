Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DDE553CBC
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355162AbiFUVB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355356AbiFUU5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0DD32050;
        Tue, 21 Jun 2022 13:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C3AE6183B;
        Tue, 21 Jun 2022 20:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD5DC36AE3;
        Tue, 21 Jun 2022 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844608;
        bh=ENIfgnKT4F0lNJ/qDorl7uOUPZuK/leAw14sJdKKXfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLNmfM2oCxdf6aGGLtca1KYb7iwW3DsjzNkbx1nQPyvT+ZmLUNSeXWdlCJ2/E8lXP
         xsu1iIJTzVSC+W4pSDy0TcU8YoMJoHcw4Mhralr5el+l+JvKyMMVGMiQ9pbkTeGnqc
         OIFEBKvGErjTWwlGrpop/Mkmqr/umjGwqJ2EtUcBA/Z1pI3lA4rDqK/oFA8YzbYExX
         xQpVDGnqhkgW+/IXL11UCpJX39o0mEsmaHgO0hR+pP94I4Yjg6C2DeS26SkZk67neh
         xJ3HDXoZ6hXw3iXVsyP8nCM9uCraoPl/jQf7jTwVGMjIBaxkvd1Hej0uRioYpRDHTy
         8WnVzwh4AbMlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.18 21/22] cifs: when a channel is not found for server, log its connection id
Date:   Tue, 21 Jun 2022 16:49:27 -0400
Message-Id: <20220621204928.249907-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
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
index 83b9047c945a..453ce8f52b8b 100644
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

