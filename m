Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9D6356E4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbiKWJh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbiKWJhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BF710AD26
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FEE61A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903A4C433D6;
        Wed, 23 Nov 2022 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196062;
        bh=I/arfYt+mwotRnITfI9CyXQupj+0/lPK+vRM1uhS9Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=do5+/WbXEcG+2whSmGxHsNF/ULUAdNQ3gXyUNCz15Z0fk8HEvwtNhzQHqYAbyoNor
         74mf/+JghsOrm2OyzEkTqFTiCNZWKY6giD7cqDWQM6K7gK3yUZT7uOAOV6c4jGpnHx
         IXxy+vhAQ9D5S8Rv92wm2pZjhNQjI4o0LV68aThM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 109/181] ring_buffer: Do not deactivate non-existant pages
Date:   Wed, 23 Nov 2022 09:51:12 +0100
Message-Id: <20221123084607.034038198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

commit 56f4ca0a79a9f1af98f26c54b9b89ba1f9bcc6bd upstream.

rb_head_page_deactivate() expects cpu_buffer to contain a valid list of
->pages, so verify that the list is actually present before calling it.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Link: https://lkml.kernel.org/r/20221114143129.3534443-1-d-tatianin@yandex-team.ru

Cc: stable@vger.kernel.org
Fixes: 77ae365eca895 ("ring-buffer: make lockless")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1733,9 +1733,9 @@ static void rb_free_cpu_buffer(struct ri
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	rb_head_page_deactivate(cpu_buffer);
-
 	if (head) {
+		rb_head_page_deactivate(cpu_buffer);
+
 		list_for_each_entry_safe(bpage, tmp, head, list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);


