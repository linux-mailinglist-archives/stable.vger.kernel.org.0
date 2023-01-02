Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD865B0CC
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbjABL2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjABL1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:27:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CD36360
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1016860F21
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239EBC433D2;
        Mon,  2 Jan 2023 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658802;
        bh=P4KDS1+0IVrYWVKae1eSTEcsh8RQayNAI42PZ3RQB64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQNcrd+i0mwADdMgVvktGIvQLmrRmuBow2njCxqTL322xBhRCFBzUxF7U9uUN7YnZ
         oaDBVra7/0NNpvDZyYrdG1xbfMOmD/UXW8UB4cDMHzmngaxLu7y+tfeZ5p/7DKgCzb
         cGvJeX5nUMwWjggWhCYOc7IH541VqusqqnVeoHmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Stefani <luca@osomprivacy.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 48/71] pstore: Properly assign mem_type property
Date:   Mon,  2 Jan 2023 12:22:13 +0100
Message-Id: <20230102110553.506556370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

From: Luca Stefani <luca@osomprivacy.com>

commit beca3e311a49cd3c55a056096531737d7afa4361 upstream.

If mem-type is specified in the device tree
it would end up overriding the record_size
field instead of populating mem_type.

As record_size is currently parsed after the
improper assignment with default size 0 it
continued to work as expected regardless of the
value found in the device tree.

Simply changing the target field of the struct
is enough to get mem-type working as expected.

Fixes: 9d843e8fafc7 ("pstore: Add mem_type property DT parsing support")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Stefani <luca@osomprivacy.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221222131049.286288-1-luca@osomprivacy.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -670,7 +670,7 @@ static int ramoops_parse_dt(struct platf
 		field = value;						\
 	}
 
-	parse_u32("mem-type", pdata->record_size, pdata->mem_type);
+	parse_u32("mem-type", pdata->mem_type, pdata->mem_type);
 	parse_u32("record-size", pdata->record_size, 0);
 	parse_u32("console-size", pdata->console_size, 0);
 	parse_u32("ftrace-size", pdata->ftrace_size, 0);


