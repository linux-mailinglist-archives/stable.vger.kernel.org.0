Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C56551B9F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347760AbiFTNnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347784AbiFTNmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:42:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3202D2AE27;
        Mon, 20 Jun 2022 06:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46330B811E4;
        Mon, 20 Jun 2022 13:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98716C3411B;
        Mon, 20 Jun 2022 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730624;
        bh=ftUnPMZU24MRLwfpOo4vc5NlxqKsBXuHxgkiser/BO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZigrrZeRu92leowhXfssfTljZvpKHldadOmgv1Q7TVi+7sa8KcbNDhs1iBFKPmsf
         C2l8h80MjAXBhcrgmczrf/CapLuHGs5PxlmrLOwcFN97p4E8KcX/pHSfVzae9xSXie
         BAWaGpZ1eq/5rwNWXluf5ur08bL5Eqm6bCRWkgc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.15 092/106] tty: n_gsm: Debug output allocation must use GFP_ATOMIC
Date:   Mon, 20 Jun 2022 14:51:51 +0200
Message-Id: <20220620124727.113002706@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit e74024b2eccbb784824a0f9feaeaaa3b47514b79 upstream.

Dan Carpenter <dan.carpenter@oracle.com> reported the following Smatch
warning:

drivers/tty/n_gsm.c:720 gsm_data_kick()
warn: sleeping in atomic context

This is because gsm_control_message() is holding a spin lock so
gsm_hex_dump_bytes() needs to use GFP_ATOMIC instead of GFP_KERNEL.

Fixes: 925ea0fa5277 ("tty: n_gsm: Fix packet data hex dump output")
Cc: stable <stable@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220523155052.57129-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -454,7 +454,7 @@ static void gsm_hex_dump_bytes(const cha
 		return;
 	}
 
-	prefix = kasprintf(GFP_KERNEL, "%s: ", fname);
+	prefix = kasprintf(GFP_ATOMIC, "%s: ", fname);
 	if (!prefix)
 		return;
 	print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET, 16, 1, data, len,


