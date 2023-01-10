Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A605F664A1D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbjAJSaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbjAJS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:29:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79271A4C75
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:24:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 984F7CE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4FAC433EF;
        Tue, 10 Jan 2023 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375068;
        bh=P4KDS1+0IVrYWVKae1eSTEcsh8RQayNAI42PZ3RQB64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8oRXyOONwFrXlTdUNwtdZRyuxuHj73QWMvdrNHtZvozmEIfy14GDabUp13/q9bmr
         Nn6fdMBsJoT7wMH/kPRhhBlEohfX26/kKlHTW2Mv2oHIQAku15sOzGq7yi2slfYB8h
         vyggI26w/gwDO328kYoGiYdoLy0ZFY74bmqerQzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Stefani <luca@osomprivacy.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 036/290] pstore: Properly assign mem_type property
Date:   Tue, 10 Jan 2023 19:02:08 +0100
Message-Id: <20230110180032.835424346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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


