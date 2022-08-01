Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03BB5869F1
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiHAMJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiHAMIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:08:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF5E655A0;
        Mon,  1 Aug 2022 04:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F16C6B81163;
        Mon,  1 Aug 2022 11:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D896C433C1;
        Mon,  1 Aug 2022 11:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354961;
        bh=QdhoJKHWHOYGae7EJTZdGq1HN/BPTPc3s5JJatJcrEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMjZn/SD2UVd1e7xv5faG373LHAXFkls1JOZ5oVc29VEYwyqDY1lHUM9tW02wKSRj
         fyIp62PyWGvFbs7816gN9rBpYvgf29XOhlYdwbHzZH2pGpPPntRPPWtNW6+jMKRna7
         NJwJlBX/etI/K4qePVUUKgSO918Hiy5WaFU4K0vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.18 13/88] asm-generic: remove a broken and needless ifdef conditional
Date:   Mon,  1 Aug 2022 13:46:27 +0200
Message-Id: <20220801114138.662815688@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit e2a619ca0b38f2114347b7078b8a67d72d457a3d upstream.

Commit 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
introduces the config symbol GENERIC_LIB_DEVMEM_IS_ALLOWED, but then
falsely refers to CONFIG_GENERIC_DEVMEM_IS_ALLOWED (note the missing LIB
in the reference) in ./include/asm-generic/io.h.

Luckily, ./scripts/checkkconfigsymbols.py warns on non-existing configs:

GENERIC_DEVMEM_IS_ALLOWED
Referencing files: include/asm-generic/io.h

The actual fix, though, is simply to not to make this function declaration
dependent on any kernel config. For architectures that intend to use
the generic version, the arch's 'select GENERIC_LIB_DEVMEM_IS_ALLOWED' will
lead to picking the function definition, and for other architectures, this
function is simply defined elsewhere.

The wrong '#ifndef' on a non-existing config symbol also always had the
same effect (although more by mistake than by intent). So, there is no
functional change.

Remove this broken and needless ifdef conditional.

Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/io.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1125,9 +1125,7 @@ static inline void memcpy_toio(volatile
 }
 #endif
 
-#ifndef CONFIG_GENERIC_DEVMEM_IS_ALLOWED
 extern int devmem_is_allowed(unsigned long pfn);
-#endif
 
 #endif /* __KERNEL__ */
 


