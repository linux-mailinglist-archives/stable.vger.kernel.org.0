Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABB68954D
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjBCKQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBCKQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:16:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6629AFE4;
        Fri,  3 Feb 2023 02:16:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AAC2B82A5F;
        Fri,  3 Feb 2023 10:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE14C433D2;
        Fri,  3 Feb 2023 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419360;
        bh=3gN4Ub4grtZnQaSSRAejTV95S513QlFlsiZh4LY97go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB2i4tdjQNHBVNVYWLOaQEDvVzVomFgJzAze8WUSl6nd8LDuWVz7LS0v6Slfi2hyg
         PIdMJjV3DYjOfxOs/cqcaFCFF2/l1Z20UI0+0rpFVYgp1YzIw6QB2oqGDZWMsi1BSa
         ns+MWXTmqkyaWwx3feLYpwGPIZHPDelL1KzHyOZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 43/62] x86/asm: Fix an assembler warning with current binutils
Date:   Fri,  3 Feb 2023 11:12:39 +0100
Message-Id: <20230203101014.812689172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 55d235361fccef573990dfa5724ab453866e7816 upstream.

Fix a warning: "found `movsd'; assuming `movsl' was meant"

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/iomap_copy_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -22,6 +22,6 @@
  */
 ENTRY(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	ret
 ENDPROC(__iowrite32_copy)


