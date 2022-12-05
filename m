Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81359643433
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiLETnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiLETmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A9C264A4
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF8F6B811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECC8C433C1;
        Mon,  5 Dec 2022 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269212;
        bh=p/rAjpmOlj9tJa77i7Zf+Z4w8YNudZxzO6bEtdWem9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3+4ZFz2IWt/c1vEQPA6rbH21nQ4BMP62o+sVHvDYzqUChebveno1GdBi/T981/Wf
         d/y0Zw6TJQlvpdzeL9NVzXTsv1L3zNhqNKCToHBvuWmqRBm7siX570HWMEPhS17L/q
         EbRA4Xx7UGCwrKmvbJjQYypAEDgNPCgIe2Cc6R/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 5.4 044/153] lib/vdso: use "grep -E" instead of "egrep"
Date:   Mon,  5 Dec 2022 20:09:28 +0100
Message-Id: <20221205190809.982861669@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8ac3b5cd3e0521d92f9755e90d140382fc292510 upstream.

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this up by moving the vdso Makefile to use "grep -E" instead.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20220920170633.3133829-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/vdso/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/vdso/Makefile
+++ b/lib/vdso/Makefile
@@ -17,6 +17,6 @@ $(error ARCH_REL_TYPE_ABS is not set)
 endif
 
 quiet_cmd_vdso_check = VDSOCHK $@
-      cmd_vdso_check = if $(OBJDUMP) -R $@ | egrep -h "$(ARCH_REL_TYPE_ABS)"; \
+      cmd_vdso_check = if $(OBJDUMP) -R $@ | grep -E -h "$(ARCH_REL_TYPE_ABS)"; \
 		       then (echo >&2 "$@: dynamic relocations are not supported"; \
 			     rm -f $@; /bin/false); fi


