Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CD857995A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiGSMBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbiGSMBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F5F45F5C;
        Tue, 19 Jul 2022 04:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9182EB81A2E;
        Tue, 19 Jul 2022 11:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06790C341CB;
        Tue, 19 Jul 2022 11:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231904;
        bh=TU9v5a2oWC0O5pMZvZGTI08WLnI0FifRCJYCMF7RG18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjz+HMm8RqatOybJukJhTs8fD5goHwGm8iaZNKcSk0gVqwZ6KfvQsPH9ep5wHgQxZ
         C6oANVsazJzklNqWu60hNzLz8ACIVQfY4h9W99bdHBQWVxyIify6XcuoCO0ed+QWYk
         6a47T+W1PtDGmFp3wFzCzJzF1xq0vN9XDG4EdTY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 05/43] ARM: 9213/1: Print message about disabled Spectre workarounds only once
Date:   Tue, 19 Jul 2022 13:53:36 +0200
Message-Id: <20220719114522.562593265@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit e4ced82deb5fb17222fb82e092c3f8311955b585 upstream.

Print the message about disabled Spectre workarounds only once. The
message is printed each time CPU goes out from idling state on NVIDIA
Tegra boards, causing storm in KMSG that makes system unusable.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/proc-v7-bugs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -110,8 +110,7 @@ static unsigned int spectre_v2_install_w
 #else
 static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
-	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
-		smp_processor_id());
+	pr_info_once("Spectre V2: workarounds disabled by configuration\n");
 
 	return SPECTRE_VULNERABLE;
 }


