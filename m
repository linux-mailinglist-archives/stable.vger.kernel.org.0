Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2815966778F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbjALOpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbjALOoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:44:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD98551C5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D8762034
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBA3C43392;
        Thu, 12 Jan 2023 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533983;
        bh=wELM2IhJpVi9ecpHrU/KxTYhprdCXLEz134HskwxezE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnjxaFGaRLT5TFxZXJ48uDnLpgRUPA5KRh17m3oSLdebaiitjlp/GHTa+VgxVh4Ho
         bLUCrDlhnJ7WjR9xfwCTKezdTk1WISsxoXcCm4VGghmB6I6NYsXC9KraTpla3yZpcE
         yAl8k9LKG68r0gI4BfNOXE1Ip9zvoRfQMJfSnPiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.10 656/783] ipmi: fix use after free in _ipmi_destroy_user()
Date:   Thu, 12 Jan 2023 14:56:12 +0100
Message-Id: <20230112135554.751427097@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit a92ce570c81dc0feaeb12a429b4bc65686d17967 upstream.

The intf_free() function frees the "intf" pointer so we cannot
dereference it again on the next line.

Fixes: cbb79863fc31 ("ipmi: Don't allow device module unload when in use")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Message-Id: <Y3M8xa1drZv4CToE@kili>
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1284,6 +1284,7 @@ static void _ipmi_destroy_user(struct ip
 	unsigned long    flags;
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
+	struct module    *owner;
 
 	if (!acquire_ipmi_user(user, &i)) {
 		/*
@@ -1345,8 +1346,9 @@ static void _ipmi_destroy_user(struct ip
 		kfree(rcvr);
 	}
 
+	owner = intf->owner;
 	kref_put(&intf->refcount, intf_free);
-	module_put(intf->owner);
+	module_put(owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)


