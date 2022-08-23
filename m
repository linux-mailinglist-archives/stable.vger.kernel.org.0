Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F10059DB2F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355384AbiHWKiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355711AbiHWKg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D279A6C22;
        Tue, 23 Aug 2022 02:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FE4E6158D;
        Tue, 23 Aug 2022 09:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B16C433D6;
        Tue, 23 Aug 2022 09:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245641;
        bh=kEJ44uGQhbsnlEsOnJCVVttPofYwKWyYENYgbKrdolw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJz0a/n4O7lY0E4L4toPKQmTHVz+OnY2avEqTSTvTCO2vCiw9IJgDb0LUGbQJ+k5/
         106HjGUZI0PdR9AFnvdDpAx4E1V0Iu7d3++pZxXU1Htd+x8QuRjDYPUu7zSwULFtYY
         KlrueIFIILBodMra+xgVskGpTFB5GBPy0xNvSdm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/287] netdevsim: Avoid allocation warnings triggered from user space
Date:   Tue, 23 Aug 2022 10:24:39 +0200
Message-Id: <20220823080104.076774622@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d0b80a9edb1a029ff913e81b47540e57ad034329 ]

We need to suppress warnings from sily map sizes. Also switch
from GFP_USER to GFP_KERNEL_ACCOUNT, I'm pretty sure I misunderstood
the flags when writing this code.

Fixes: 395cacb5f1a0 ("netdevsim: bpf: support fake map offload")
Reported-by: syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220726213605.154204-1-kuba@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 12f100392ed1..ca9042ddb6d7 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -330,10 +330,12 @@ nsim_map_alloc_elem(struct bpf_offloaded_map *offmap, unsigned int idx)
 {
 	struct nsim_bpf_bound_map *nmap = offmap->dev_priv;
 
-	nmap->entry[idx].key = kmalloc(offmap->map.key_size, GFP_USER);
+	nmap->entry[idx].key = kmalloc(offmap->map.key_size,
+				       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!nmap->entry[idx].key)
 		return -ENOMEM;
-	nmap->entry[idx].value = kmalloc(offmap->map.value_size, GFP_USER);
+	nmap->entry[idx].value = kmalloc(offmap->map.value_size,
+					 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!nmap->entry[idx].value) {
 		kfree(nmap->entry[idx].key);
 		nmap->entry[idx].key = NULL;
@@ -475,7 +477,7 @@ nsim_bpf_map_alloc(struct netdevsim *ns, struct bpf_offloaded_map *offmap)
 	if (offmap->map.map_flags)
 		return -EINVAL;
 
-	nmap = kzalloc(sizeof(*nmap), GFP_USER);
+	nmap = kzalloc(sizeof(*nmap), GFP_KERNEL_ACCOUNT);
 	if (!nmap)
 		return -ENOMEM;
 
-- 
2.35.1



