Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBB60A74E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbiJXMsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiJXMmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFDD8A7EE;
        Mon, 24 Oct 2022 05:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7FD612D4;
        Mon, 24 Oct 2022 12:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13C5C433C1;
        Mon, 24 Oct 2022 12:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613193;
        bh=9lSZ8aRNqxUmK/4jyig8irUcUZqPBRulXTjpjA2nuaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTNzZ5uFc+dTmt9k2csTbehDzNldzFNj/hHot+GdrOTAq+SCm8UXG0EYA/CEHlB5h
         BFNYnkAafylPL5kMCE9uITe267zWPDOyampLZZPojKyWyEyKuf+MtJNilH3mKPyhaj
         vUWHO0EKOoaxmqFKxN4E5u87fv1eIOJgg55l2c/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lalith Rajendran <lalithkraj@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 043/255] ext4: make ext4_lazyinit_thread freezable
Date:   Mon, 24 Oct 2022 13:29:13 +0200
Message-Id: <20221024113003.863221366@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
@@ -3157,6 +3157,7 @@ static int ext4_lazyinit_thread(void *ar
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {


