Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867C34F6B09
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiDFUO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbiDFUOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818B1206ECC;
        Wed,  6 Apr 2022 11:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A29461B89;
        Wed,  6 Apr 2022 18:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A61C385A3;
        Wed,  6 Apr 2022 18:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269648;
        bh=ido5XWirC7wGX5X7OFgAK+kAjOjCTzq4qFG7/JRJ8ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjCrRLspXuECB1DXnVvxblNXIRtA+fv6BaguUie0mUWCXdoo49pr5URg7qc89Yo0M
         OVAfRJkylGsfOkF/Wi+xSztdj57bOgXfCGOa72xRCu4oDmGHLbcFZFZshAGBKPNgRD
         Xvnesj8RtrQotnqomj/DRKiUbXl0+R/aBP/CY6lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 19/43] arm64: Make ARM64_ERRATUM_1188873 depend on COMPAT
Date:   Wed,  6 Apr 2022 20:26:28 +0200
Message-Id: <20220406182437.241430826@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
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

From: Marc Zyngier <marc.zyngier@arm.com>

commit c2b5bba3967a000764e9148e6f020d776b7ecd82 upstream.

Since ARM64_ERRATUM_1188873 only affects AArch32 EL0, it makes some
sense that it should depend on COMPAT.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -444,6 +444,7 @@ config ARM64_ERRATUM_1024718
 config ARM64_ERRATUM_1188873
 	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
 	default y
+	depends on COMPAT
 	select ARM_ARCH_TIMER_OOL_WORKAROUND
 	help
 	  This option adds work arounds for ARM Cortex-A76 erratum 1188873


