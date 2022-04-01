Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462D94EF551
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350831AbiDAPNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350564AbiDAPAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CB3185441;
        Fri,  1 Apr 2022 07:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89BD2B824D5;
        Fri,  1 Apr 2022 14:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589B1C34111;
        Fri,  1 Apr 2022 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824479;
        bh=nPE0/rhmVHxbpJ45v6/d7l7g5cDcyD9IGl2HGzZV6dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A73qRg5PRhIIgRK9ubyvZCiluLopM4rk8VW5JFYFG1EypEZ0DB0WE6cX05U9115qu
         XgC9Gks63QMwvL1VFAtSD4Nkt6XjZD7F0Zhxwds+6I0rGfgAIBXhdTWbT0XBDynghH
         ojRlnJctFKSEa7JIwY5D3jIQTrHjM426uys/bwWG+GEex+ROtuYLzkUSGFNlg95Ps7
         n97UeFXcjg0UfQ66T3WSqzTCBdXYrCiWHcg7MW/q9AHnjDwH51sPrMiQvZRgDfPoQX
         KtR8B6Sy0DFZ0R5oeAr2zO1E7YAlw8IiBnp7gwkUgHkZ8sNMg/cPUzaxhVEycJgggX
         kF/IcuRtrEHMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jordy Zomer <jordy@jordyzomer.github.io>,
        Jordy Zomer <jordy@pwning.systems>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 10/22] dm ioctl: prevent potential spectre v1 gadget
Date:   Fri,  1 Apr 2022 10:47:17 -0400
Message-Id: <20220401144729.1955554-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144729.1955554-1-sashal@kernel.org>
References: <20220401144729.1955554-1-sashal@kernel.org>
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

From: Jordy Zomer <jordy@jordyzomer.github.io>

[ Upstream commit cd9c88da171a62c4b0f1c70e50c75845969fbc18 ]

It appears like cmd could be a Spectre v1 gadget as it's supplied by a
user and used as an array index. Prevent the contents of kernel memory
from being leaked to userspace via speculative execution by using
array_index_nospec.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2f020401d5ba..ddfea5324b58 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 
@@ -1669,6 +1670,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
+	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
-- 
2.34.1

