Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8294E4B4AC6
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344268AbiBNKAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:00:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiBNJ7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FFC6AA73;
        Mon, 14 Feb 2022 01:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 375F0B80DCC;
        Mon, 14 Feb 2022 09:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE35C340E9;
        Mon, 14 Feb 2022 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831289;
        bh=M/5dKUxzJXnKgyxX5TYZlhdq53UpEzROZzEaWXAB0Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkpYz9RvJj8gBzuRo9PNpLb4sg/6dd6FzIJyh8fUFpqPShMUFf1eu2Xmsjx4LaY4U
         GbnXYvd02vpn7Gi/EWoY1kjdzvsbu+TSCLgy1ko7IikozDn5+A5LQa5a84tgD4NNQU
         YUHhs3BShazVOt8TtI1BVFg97fN0GLiD3KM+JViQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH 4.19 35/49] vt_ioctl: add array_index_nospec to VT_ACTIVATE
Date:   Mon, 14 Feb 2022 10:26:01 +0100
Message-Id: <20220214092449.447743582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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

commit 28cb138f559f8c1a1395f5564f86b8bbee83631b upstream.

in vt_setactivate an almost identical code path has been patched
with array_index_nospec. In the VT_ACTIVATE path the user input
is from a system call argument instead of a usercopy.
For consistency both code paths should have the same mitigations
applied.

Kasper Acknowledgements: Jakob Koschel, Brian Johannesmeyer, Kaveh
Razavi, Herbert Bos, Cristiano Giuffrida from the VUSec group at VU
Amsterdam.

Co-developed-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220127144406.3589293-2-jakobkoschel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -691,6 +691,7 @@ int vt_ioctl(struct tty_struct *tty,
 			ret =  -ENXIO;
 		else {
 			arg--;
+			arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 			console_lock();
 			ret = vc_allocate(arg);
 			console_unlock();


