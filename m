Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB65FB919
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 19:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJKRWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 13:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJKRWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 13:22:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAF35AA20
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 10:22:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so6790431pjb.2
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 10:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HuUOoz08+SNHgJw2Jvzf5iMIoAo0Arsi0psIv7dP0u8=;
        b=WvxA8BCWkMvihAnHOgYkuxtXj/EIRjAEB4wvWB6r1XwLHc6sBNR3d/1Jon3O85wltG
         GRu+IK/D2Qw/nGrqYVo2Ts85/AvJtEPc0T4ZvlvmERTUZ06/ilC87kUUM6EobvvZq4eu
         6PfOPQ7NV2KJW1AgqoiaqxZRfVChC1z4eHq+vcOngbAL4uztJ/s0F47bQis9RaM2LmTt
         +Ijqd+IVrZ2dJHSMj22beBP5ihrL2zqdRbtD8590B9BQXhtcy8IDX9jznO3ZchV6Ihq8
         yX1HmLuAVMPgIS1V6FoTat2EfstT/0UmcSNTZZwHHNoERoMhmw++DE4D3jVESZ7T9yHV
         Tcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HuUOoz08+SNHgJw2Jvzf5iMIoAo0Arsi0psIv7dP0u8=;
        b=UPWvOtM68GAJERF61M8FxSI1fkR6IxFa3O+5Wyr+KDkj0BJ9lMI+ZRu0tUuNNLM0zL
         rZlKKBGF137UOEgilg/+/FPlAlAMGrcGncOCdGBmkZt7X8x1PUBe9wuoRyeMshxqbKDU
         qPlD8r3M0xdcEXEP+5gUBOP2zGdQW/+NcA43PnT4bT1BMYRden2Bq9qC8Gef1tAk/fGs
         Hy7z+3wDZeT6AXkMJK9ovbT5YfzAK/fRPfdumkX8tvr+R9PnrV3ExLZCux6pH/liyTh2
         do1t3px3b6yUU+9d3dly6uWgD302400nRpcgjXyhWE11A+boULKEkpz6gLFsglYsOeFn
         b7Bg==
X-Gm-Message-State: ACrzQf3ngeE7whBAIZeQhX8MLorqaYQt8zyyvpP8RXgo17e4ERFtF4xI
        NAPsjsalZWg3P/8Js5JtgCRQ63tPLG+rIQ==
X-Google-Smtp-Source: AMsMyM400qEbgFfaunbf5iW4DvtwZ55zr4NuwsQVyVTrg+xU9FGwjmeY0HaEFOINBIm7fxt67Zlxwg==
X-Received: by 2002:a17:903:230b:b0:177:e667:7862 with SMTP id d11-20020a170903230b00b00177e6677862mr25590026plh.154.1665508938421;
        Tue, 11 Oct 2022 10:22:18 -0700 (PDT)
Received: from vimal-VirtualBox.. ([49.207.208.217])
        by smtp.gmail.com with ESMTPSA id c82-20020a624e55000000b0056265011136sm9276550pfb.112.2022.10.11.10.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 10:22:17 -0700 (PDT)
From:   Vimal Agrawal <avimalin@gmail.com>
X-Google-Original-From: Vimal Agrawal <vimal.agrawal@sophos.com>
To:     stable@vger.kernel.org
Cc:     fw@strlen.de, avimalin@gmail.com,
        Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: [PATCH 4.14.y] netfilter: nf_queue: fix socket leak
Date:   Tue, 11 Oct 2022 22:52:02 +0530
Message-Id: <20221011172202.3709-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Removal of the sock_hold got lost when backporting commit 4d05239203fa
("netfilter: nf_queue: fix possible use-after-free") to 4.14

This was causing a socket leak and was caught by kmemleak.
Tested by running kmemleak again with this fix.

Fixes: ef97921ccdc2 ("netfilter: nf_queue: fix possible use-after-free")
in 4.14
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
---
 net/netfilter/nf_queue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index dbc45165c533..46984cdee658 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -91,8 +91,6 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->skb->nf_bridge) {
 		struct net_device *physdev;
-- 
2.32.0

