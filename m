Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1682593B47
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbiHOTrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345308AbiHOTqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1296E2EB;
        Mon, 15 Aug 2022 11:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A6E60FB8;
        Mon, 15 Aug 2022 18:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F51CC433D6;
        Mon, 15 Aug 2022 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589339;
        bh=cdnhM6keGBCbekNFSqz0/UM3k8voCBSTZYS+WXXc1WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIBRNcikMgrgfZ7qgb74E4aXCRXlCGiu3aBT92uFqpXHtnOg1X3Ws4V08NChk8uzF
         45/F/AU9B4V9M8shLugi5akc4q43ZVlohac9OBYfqemlCFdfKNxiapEk+dNgd4fbkr
         QW2jJGQOg1mayfTLIPp4ghQ+js8PdxgwES1LGqy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        Xie Shaowen <studentxswpy@163.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 687/779] Input: gscps2 - check return value of ioremap() in gscps2_probe()
Date:   Mon, 15 Aug 2022 20:05:31 +0200
Message-Id: <20220815180406.712047894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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


