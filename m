Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A7759A52A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353344AbiHSQmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353979AbiHSQl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EF61272D9;
        Fri, 19 Aug 2022 09:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 911EBB82802;
        Fri, 19 Aug 2022 16:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9986C433D6;
        Fri, 19 Aug 2022 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925304;
        bh=cdnhM6keGBCbekNFSqz0/UM3k8voCBSTZYS+WXXc1WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM7AzGws7cvOGLEj2bVU6ajlYgPYdb3cUrRSk62mfiObSPIQ8vjBNVGutpjeSECC4
         uxZZ3GcORvWe4ZiliysaralceNSFltDDaDy//9BnIQUXIzB766FaeUAv18errsTkPO
         0NH8Jut/6E1sE31zZWd6ffVGzLZ4qGETIT8LD2Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        Xie Shaowen <studentxswpy@163.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 449/545] Input: gscps2 - check return value of ioremap() in gscps2_probe()
Date:   Fri, 19 Aug 2022 17:43:39 +0200
Message-Id: <20220819153849.514435427@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xie Shaowen <studentxswpy@163.com>

commit e61b3125a4f036b3c6b87ffd656fc1ab00440ae9 upstream.

The function ioremap() in gscps2_probe() can fail, so
its return value should be checked.

Fixes: 4bdc0d676a643 ("remove ioremap_nocache and devm_ioremap_nocache")
Cc: <stable@vger.kernel.org> # v5.6+
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/gscps2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -350,6 +350,10 @@ static int __init gscps2_probe(struct pa
 	ps2port->port = serio;
 	ps2port->padev = dev;
 	ps2port->addr = ioremap(hpa, GSC_STATUS + 4);
+	if (!ps2port->addr) {
+		ret = -ENOMEM;
+		goto fail_nomem;
+	}
 	spin_lock_init(&ps2port->lock);
 
 	gscps2_reset(ps2port);


