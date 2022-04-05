Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175464F25F8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiDEHxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiDEHvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4F49729A;
        Tue,  5 Apr 2022 00:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3592261668;
        Tue,  5 Apr 2022 07:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4920DC34110;
        Tue,  5 Apr 2022 07:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144860;
        bh=vCNxLByh22qWpvDtzrk7nKcRMnmgzftlBFDb7fx5dWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PB8mB4pTiwGKIvxAoTcLtVGtF2JWf+Wke6jehXZt5qtxnk5SYTQzgnijAsIh8KncN
         9zS1s8nLZHgbK/kDxqmTECNVzfMZO3StY2Yj0fnBIq8yK6a3f8GcMML8vpFbOWYYKG
         n/6I+G6+SMRbmvLWhoQpjMq5mw4xSjPZCMMPcEmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.17 0180/1126] xtensa: fix stop_machine_cpuslocked call in patch_text
Date:   Tue,  5 Apr 2022 09:15:27 +0200
Message-Id: <20220405070412.889147845@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Max Filippov <jcmvbkbc@gmail.com>

commit f406f2d03e07afc199dd8cf501f361dde6be8a69 upstream.

patch_text must invoke patch_text_stop_machine on all online CPUs, but
it calls stop_machine_cpuslocked with NULL cpumask. As a result only one
CPU runs patch_text_stop_machine potentially leaving stale icache
entries on other CPUs. Fix that by calling stop_machine_cpuslocked with
cpu_online_mask as the last argument.

Cc: stable@vger.kernel.org
Fixes: 64711f9a47d4 ("xtensa: implement jump_label support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/jump_label.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -61,7 +61,7 @@ static void patch_text(unsigned long add
 			.data = data,
 		};
 		stop_machine_cpuslocked(patch_text_stop_machine,
-					&patch, NULL);
+					&patch, cpu_online_mask);
 	} else {
 		unsigned long flags;
 


