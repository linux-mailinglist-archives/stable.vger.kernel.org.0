Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA9A4F3318
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiDEK3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiDEJci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3115E7D;
        Tue,  5 Apr 2022 02:19:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E5F66144D;
        Tue,  5 Apr 2022 09:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802E4C385A2;
        Tue,  5 Apr 2022 09:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150381;
        bh=cJgNiIRKs43WwxcFvB9IigSsDaV6t6vyU5S0AYz5shw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAxE+NYH533leKUJTG1f9OuuRdVnYK+xqFcFi/W99uJIVbGrWvqIKzuhyzwGz9H5O
         VcLxO5SY6Oq29R+K1/dd4Ckd5K7BnOGIdqEFAd3XBf/t3xvm6TwLBp/t5wrbKc4fOX
         s0SIXEk7C0h8YV5xagA5F5VF8ZzV4gZdx8nzVLdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 036/913] xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()
Date:   Tue,  5 Apr 2022 09:18:18 +0200
Message-Id: <20220405070340.899196392@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 05519b8589a679edb8fa781259893d20bece04ad upstream.

xhci_decode_ctrl_ctx() returns the untouched buffer as-is if both "drop"
and "add" parameters are zero.

Fix the function to return an empty string in that case.

It was not immediately clear from the possible call chains whether this
issue is currently actually triggerable or not.

Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
usage in xhci tracing") the result effect in the failure case was different
as a static buffer was used here, but the code still worked incorrectly.

Fixes: 90d6d5731da7 ("xhci: Add tracing for input control context")
Cc: stable@vger.kernel.org
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
commit 4843b4b5ec64 ("xhci: fix even more unsafe memory usage in xhci tracing")
Link: https://lore.kernel.org/r/20220303110903.1662404-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2470,6 +2470,8 @@ static inline const char *xhci_decode_ct
 	unsigned int	bit;
 	int		ret = 0;
 
+	str[0] = '\0';
+
 	if (drop) {
 		ret = sprintf(str, "Drop:");
 		for_each_set_bit(bit, &drop, 32)


