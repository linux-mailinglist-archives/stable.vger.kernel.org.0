Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8684160A407
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiJXMFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiJXMDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E14423EB6;
        Mon, 24 Oct 2022 04:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4A8061290;
        Mon, 24 Oct 2022 11:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C878BC433D7;
        Mon, 24 Oct 2022 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612184;
        bh=6r7DvksVj6Eagna1spU2oiIU7PrPMrYurWR9NshWROo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyhXCPTahdQh4sVAiPDWXGzYoC7/8xYBLWAUVp+e/5zy1bZtvDI65kDxOn0kwt2KD
         ok6vhaC72UMQiWFvmnghf/SP9qcJTcmn4JknYmtt5E8fB+6J1Taww1a/i5zaf+RusX
         IBS1XZUgyeJ/FR7d4pNyWPxjRL8wevOPg05aqMp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lalith Rajendran <lalithkraj@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 070/210] ext4: make ext4_lazyinit_thread freezable
Date:   Mon, 24 Oct 2022 13:29:47 +0200
Message-Id: <20221024112959.332977521@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -3037,6 +3037,7 @@ static int ext4_lazyinit_thread(void *ar
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {


