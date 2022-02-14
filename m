Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0214B49E0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346300AbiBNKSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiBNKPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0931678069;
        Mon, 14 Feb 2022 01:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4667C612BF;
        Mon, 14 Feb 2022 09:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22667C340E9;
        Mon, 14 Feb 2022 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832373;
        bh=CLfqbK5DAgyx3E+ykodxSz0Gwtxu7xIMZXMF5qlQwTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2JVbCZIr5Y+4IMXsARQW2xoA2GwIQfjIgmUUCD/sILsMMwasupXgkGgfwsaCQrKE
         lnQhq0osuW5q8HGhP9Ze7xrIK4q6oylJQug/cSRBUlCEhV/ONfa/KINSQy/NOwoHZn
         O3N21oLUzsLspXLoDs2jbF5fzhJZyIVN9KP1Rvko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH 5.15 134/172] vt_ioctl: fix array_index_nospec in vt_setactivate
Date:   Mon, 14 Feb 2022 10:26:32 +0100
Message-Id: <20220214092511.036875993@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jakobkoschel@gmail.com>

commit 61cc70d9e8ef5b042d4ed87994d20100ec8896d9 upstream.

array_index_nospec ensures that an out-of-bounds value is set to zero
on the transient path. Decreasing the value by one afterwards causes
a transient integer underflow. vsa.console should be decreased first
and then sanitized with array_index_nospec.

Kasper Acknowledgements: Jakob Koschel, Brian Johannesmeyer, Kaveh
Razavi, Herbert Bos, Cristiano Giuffrida from the VUSec group at VU
Amsterdam.

Co-developed-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220127144406.3589293-1-jakobkoschel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -599,8 +599,8 @@ static int vt_setactivate(struct vt_seta
 	if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 		return -ENXIO;
 
-	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES + 1);
 	vsa.console--;
+	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES);
 	console_lock();
 	ret = vc_allocate(vsa.console);
 	if (ret) {


