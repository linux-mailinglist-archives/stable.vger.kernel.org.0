Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429B560ACA7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiJXOLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiJXOJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:09:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A00C7063;
        Mon, 24 Oct 2022 05:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C1ABB818D3;
        Mon, 24 Oct 2022 12:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A2C433D6;
        Mon, 24 Oct 2022 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615031;
        bh=7TzHp7JR3pzl8+mXbzvAKs6Xfx/X5wEEKYdThCCtqgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b63+lQ+1waPThjE19h1SDJJHqbBbBCQuMxT1o/F8nimj/rFAjZndEORVj38x16tLF
         Iy1S3XKt4SPJ+NH5KxRGMvYj5AkHdyvuXei1NpI7W3hFZQ30K3zNpcao9nPPJ8JH3d
         Fkl96hQol0CdR9S6t//T98+MWkSqA+16qW3Qfby0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lalith Rajendran <lalithkraj@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 094/530] ext4: make ext4_lazyinit_thread freezable
Date:   Mon, 24 Oct 2022 13:27:18 +0200
Message-Id: <20221024113049.271289195@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -3377,6 +3377,7 @@ static int ext4_lazyinit_thread(void *ar
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {


