Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ABE6130FD
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJaHD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJaHD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3339BE2D
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1E4DB810BC
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E5EC433C1;
        Mon, 31 Oct 2022 07:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199834;
        bh=1AkUeqNADQBB7pzpW3z/rn1bKmX3B4Ihyi/LGOTb8rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHz0CwwIViS33pC43M8Fx0aXGYpcjKXv7+xQc3De30ruREqzID77xK76tuCOc1VvN
         27cNqBnKjcEc2YvDfp0b/OrCyR92plDOAWztO8ZOqs0H659c4HoK0cEuCjhVJdzru9
         mZt/xWcmrN323pGj4xWpyl5wiOL7228P+JivebWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 30/34] x86/bugs: Add Cannon lake to RETBleed affected CPU list
Date:   Mon, 31 Oct 2022 08:03:03 +0100
Message-Id: <20221031070140.821082596@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f54d45372c6ac9c993451de5e51312485f7d10bc upstream.

Cannon lake is also affected by RETBleed, add it to the list.

Fixes: 6ad0ad2bf8a6 ("x86/bugs: Report Intel retbleed vulnerability")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust cpu model name CANNONLAKE_L -> CANNONLAKE_MOBILE ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1004,6 +1004,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_MOBILE,X86_STEPPING_ANY,		RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),


