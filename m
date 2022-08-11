Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E1E59020D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiHKQCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiHKQCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:02:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDFB2D80;
        Thu, 11 Aug 2022 08:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC47601BF;
        Thu, 11 Aug 2022 15:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F201DC43470;
        Thu, 11 Aug 2022 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232982;
        bh=qsShld15yanExGZz6tj+YI1xZMgoDwaENHBqd2mx4bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIgtf1dU+Co8cci3seuZW93697xglg3pN74IwsuKB7KpXcKnlcemy3TWOAyhNWofS
         xpO5xjo9ZPbq2BzBu7EWkHdbMz0F2IqFVFwyksfoE0+xKTtjLUKxOReqSWKX71cZfF
         axl6HM8pFzo1fVwRn8TuGSrw8JDQkw3sjXTCIm4KbqZL/netBlLW+lFqc5MrxNq2AZ
         a7TcWwLRdcUiW2IrIlro+R9WnJXvdOC5gFFQIp1iMxK7LiZWWEKg4Rw78WcoW8P5/y
         A8TkCE2L61MDlqniCINh9G5+Dol0VlmJkYjEMHpSvYLFgau+1d5XzGbSAkIqExtyOn
         Iy/r0XABcdbwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 57/93] scripts: sphinx-pre-install: fix venv version check logic
Date:   Thu, 11 Aug 2022 11:41:51 -0400
Message-Id: <20220811154237.1531313-57-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit 7c2d45a347c7933cbe0efff14fe96adeb13fd761 ]

The logic which checks if the venv version is good enough
but was not activated is broken: it is checking against
the wrong val, making it to recommend to re-create a venv
every time. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Link: https://lore.kernel.org/r/afe01b7863fd655986d84ace8948f3d7aede796d.1656756450.git.mchehab@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index f126ecbb0494..ae8c49734899 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -741,7 +741,7 @@ sub recommend_sphinx_upgrade()
 
 	# Get the highest version from sphinx_*/bin/sphinx-build and the
 	# corresponding command to activate the venv/virtenv
-	$activate_cmd = get_virtenv();
+	($activate_cmd, $venv_ver) = get_virtenv();
 
 	# Store the highest version from Sphinx existing virtualenvs
 	if (($activate_cmd ne "") && ($venv_ver gt $cur_version)) {
@@ -759,10 +759,14 @@ sub recommend_sphinx_upgrade()
 	# Either there are already a virtual env or a new one should be created
 	$need_pip = 1;
 
+	return if (!$latest_avail_ver);
+
 	# Return if the reason is due to an upgrade or not
 	if ($latest_avail_ver lt $rec_version) {
 		$rec_sphinx_upgrade = 1;
 	}
+
+	return $latest_avail_ver;
 }
 
 #
@@ -820,7 +824,7 @@ sub recommend_sphinx_version($)
 	}
 
 	# Suggest newer versions if current ones are too old
-	if ($latest_avail_ver && $cur_version ge $min_version) {
+	if ($latest_avail_ver && $latest_avail_ver ge $min_version) {
 		# If there's a good enough version, ask the user to enable it
 		if ($latest_avail_ver ge $rec_version) {
 			printf "\nNeed to activate Sphinx (version $latest_avail_ver) on virtualenv with:\n";
@@ -897,7 +901,7 @@ sub check_needs()
 		}
 	}
 
-	recommend_sphinx_upgrade();
+	my $venv_ver = recommend_sphinx_upgrade();
 
 	my $virtualenv_cmd;
 
-- 
2.35.1

