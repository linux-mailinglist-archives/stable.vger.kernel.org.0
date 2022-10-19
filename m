Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80784603CAB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiJSIuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiJSIuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:50:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CFE57E2B;
        Wed, 19 Oct 2022 01:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3D3BB822EC;
        Wed, 19 Oct 2022 08:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2F0C433C1;
        Wed, 19 Oct 2022 08:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169037;
        bh=0O+iB5m/QXAnOYs1Dmvzn9u6uFowokWOpnnjHiYsCuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+UhsUx+mXyQrmSySzxi9jUVqloFWhon0o4QDDXA5lm9s1R6nQxyD90W/LIWMtHQ8
         54emroRZMrrSbPg/YWQpJDPtuHhiXOft76v7mXSQwzRR3+ljNJEgiEw4/6egiLY/LT
         Swy4nf/NDXqoch/U6O5RMPjc8hl63A0HxnsCQCIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lalith Rajendran <lalithkraj@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 137/862] ext4: make ext4_lazyinit_thread freezable
Date:   Wed, 19 Oct 2022 10:23:44 +0200
Message-Id: <20221019083256.037470765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lalith Rajendran <lalithkraj@google.com>

commit 3b575495ab8dbb4dbe85b4ac7f991693c3668ff5 upstream.

ext4_lazyinit_thread is not set freezable. Hence when the thread calls
try_to_freeze it doesn't freeze during suspend and continues to send
requests to the storage during suspend, resulting in suspend failures.

Cc: stable@kernel.org
Signed-off-by: Lalith Rajendran <lalithkraj@google.com>
Link: https://lore.kernel.org/r/20220818214049.1519544-1-lalithkraj@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3767,6 +3767,7 @@ static int ext4_lazyinit_thread(void *ar
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {


