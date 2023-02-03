Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A686896BF
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjBCKcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbjBCKan (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056B881B2A;
        Fri,  3 Feb 2023 02:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 975ABB82A64;
        Fri,  3 Feb 2023 10:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2319C4339B;
        Fri,  3 Feb 2023 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420189;
        bh=wlhF59pgf4V8qDjElfKhTcj52TEZtrqe3q44xNjnm4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJTMWIsJfVhk1jMqrbkljOIK69NbbBYixDMKEj75SxbNUMsvr9Ney3DjtJn5RnLQp
         V0ATdwTFpcRzZbnDVS8Pz2W/X74nr0bfSF3tRz8J1C3CQW1qPGBMkomMik5QfYbPz3
         XAYTCLrmlqKilkG33yTHMEQHDExUzZEdjFZ7kwb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 109/134] x86/asm: Fix an assembler warning with current binutils
Date:   Fri,  3 Feb 2023 11:13:34 +0100
Message-Id: <20230203101028.732656549@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
@@ -10,6 +10,6 @@
  */
 ENTRY(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	ret
 ENDPROC(__iowrite32_copy)


