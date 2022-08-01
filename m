Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE52F58695D
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiHAMCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiHAMAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:00:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564FE4E601;
        Mon,  1 Aug 2022 04:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D51F4B81171;
        Mon,  1 Aug 2022 11:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427DDC433D6;
        Mon,  1 Aug 2022 11:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354775;
        bh=QdhoJKHWHOYGae7EJTZdGq1HN/BPTPc3s5JJatJcrEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vhoft/hTOHG9sQeGQMcyqYK1zL7MekI+4gS9C6x4hYDFg4y6tH4IE1nuJKPIHrFD
         Llt8lyhLcaAyu66my58HbRXNakqagyTdCXG5t2TrRguFK3y4nCMfuB1Ntohcb2YEyO
         nghjOECO0YuIkPvVRs5MUikwFrcFoalO8bzEoQXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 08/69] asm-generic: remove a broken and needless ifdef conditional
Date:   Mon,  1 Aug 2022 13:46:32 +0200
Message-Id: <20220801114134.815320414@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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
 


