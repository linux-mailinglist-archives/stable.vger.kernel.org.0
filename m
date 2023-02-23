Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B086A09E0
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbjBWNKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbjBWNKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:10:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D276E193C4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:10:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B6F616E0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F6BC433D2;
        Thu, 23 Feb 2023 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157828;
        bh=YC+vD6NkMbFqgfKdnVDnXXl+z5PTo+IF4asSUrstv50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgFVMxhQfTV3cO45embebSJIWzAkhlGn8Ep6S1mFDYjIlChHQkH4Wqcoy/EY55Ems
         k7y16UmFEoZ75INoISWbEdBSqPp8E0xOV51OTGTg4OKZZnKpRe2m3e3Qm8Hce1blip
         a0gsvy/nR5x4gZqxiVI4GoE9AUr10oTHWov2sgLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Will Deacon <will@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 6.1 35/46] arm64: remove special treatment for the link order of head.o
Date:   Thu, 23 Feb 2023 14:06:42 +0100
Message-Id: <20230223130433.230132011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 994b7ac1697b4581b7726d2ac64321e3c840229b upstream.

In the previous discussion (see the Link tag), Ard pointed out that
arm/arm64/kernel/head.o does not need any special treatment - the only
piece that must appear right at the start of the binary image is the
image header which is emitted into .head.text.

The linker script does the right thing to do. The build system does
not need to manipulate the link order of head.o.

Link: https://lore.kernel.org/lkml/CAMj1kXH77Ja8bSsq2Qj8Ck9iSZKw=1F8Uy-uAWGVDm4-CG=EuA@mail.gmail.com/
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Link: https://lore.kernel.org/r/20221012233500.156764-1-masahiroy@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/head-object-list.txt |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/head-object-list.txt
+++ b/scripts/head-object-list.txt
@@ -15,7 +15,6 @@ arch/alpha/kernel/head.o
 arch/arc/kernel/head.o
 arch/arm/kernel/head-nommu.o
 arch/arm/kernel/head.o
-arch/arm64/kernel/head.o
 arch/csky/kernel/head.o
 arch/hexagon/kernel/head.o
 arch/ia64/kernel/head.o


