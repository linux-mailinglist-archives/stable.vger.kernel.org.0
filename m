Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F166C6DEEAC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjDLIoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDLIoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A371093EA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA00A630B3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF07C433D2;
        Wed, 12 Apr 2023 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288977;
        bh=mXPxwdqctaWuvNo3Mr/rvXBuSKg6oqk9IDTnsDFszDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/2Pxbedwi5O6+lxJTWwKVMmOod1ModJsIp0CQlvBVYsu62jM3YiPEpmok5qlEStc
         cxgdXqal8TUNz1uVSCq6FgeP+SH93XoLdz/9JUx+4cHjw5jE7tGsr+9Rk2Y8tlH42U
         y9yMawAGucqKRK9mxbQ/EuyRxmfbfDJh4suEufW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miguel Luis <miguel.luis@oracle.com>,
        Boris Ostrovsky <boris.ovstrosky@oracle.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        David R <david@unsolicited.net>, stable@kernel.org
Subject: [PATCH 6.1 090/164] x86/acpi/boot: Correct acpi_is_processor_usable() check
Date:   Wed, 12 Apr 2023 10:33:32 +0200
Message-Id: <20230412082840.540377628@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric DeVolder <eric.devolder@oracle.com>

commit fed8d8773b8ea68ad99d9eee8c8343bef9da2c2c upstream.

The logic in acpi_is_processor_usable() requires the online capable
bit be set for hotpluggable CPUs.  The online capable bit has been
introduced in ACPI 6.3.

However, for ACPI revisions < 6.3 which do not support that bit, CPUs
should be reported as usable, not the other way around.

Reverse the check.

  [ bp: Rewrite commit message. ]

Fixes: e2869bd7af60 ("x86/acpi/boot: Do not register processors that cannot be onlined for x2APIC")
Suggested-by: Miguel Luis <miguel.luis@oracle.com>
Suggested-by: Boris Ostrovsky <boris.ovstrosky@oracle.com>
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: David R <david@unsolicited.net>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230327191026.3454-2-eric.devolder@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -193,7 +193,8 @@ static bool __init acpi_is_processor_usa
 	if (lapic_flags & ACPI_MADT_ENABLED)
 		return true;
 
-	if (acpi_support_online_capable && (lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
+	if (!acpi_support_online_capable ||
+	    (lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
 		return true;
 
 	return false;


