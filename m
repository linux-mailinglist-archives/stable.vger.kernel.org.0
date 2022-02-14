Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444CF4B4836
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiBNJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344306AbiBNJvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DED694B1;
        Mon, 14 Feb 2022 01:42:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D711E6120B;
        Mon, 14 Feb 2022 09:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F1CC340E9;
        Mon, 14 Feb 2022 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831764;
        bh=IFK8yREHeBdWrhNcSpfKJd0kZcJEtrINbBXrpWbv/kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3eVUy8yPLA9OMXXLOFFBqXCM56+R0hqxi7W7QxUaOalDd3htFfiS60OGXl/f7BJZ
         Nx4ZecAzpqDF/8CJC/nUNPehBGlpXqB4LOkhMph3c3AsYFAp3MonMTQq+MtjA59Xim
         svmTCz5uyesI1CZUK2M+Js4kihH+FLJ50F5rE1Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH 5.10 088/116] vt_ioctl: add array_index_nospec to VT_ACTIVATE
Date:   Mon, 14 Feb 2022 10:26:27 +0100
Message-Id: <20220214092501.803818348@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
@@ -945,6 +945,7 @@ int vt_ioctl(struct tty_struct *tty,
 			return -ENXIO;
 
 		arg--;
+		arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 		console_lock();
 		ret = vc_allocate(arg);
 		console_unlock();


