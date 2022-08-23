Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB559DD12
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359178AbiHWMDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359857AbiHWMCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB5EDC083;
        Tue, 23 Aug 2022 02:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA908B81C96;
        Tue, 23 Aug 2022 09:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07035C433D6;
        Tue, 23 Aug 2022 09:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247392;
        bh=wAb9caDwUzbk7UBhI7cFlk+Z8maI1Aajsuhg8IEI720=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvtnU8dDkL6IkfoD7/uAtQ0C8Qtd/H0RD+c7BEDTUS0HwtD8rSYscJ9gAzu48uozQ
         qXD2XCFzY+L5mjLTLm2wcCHwayW8q4xUEAv8xJj/ywSeV/qPOoMqiDwtSyVCDTmrvJ
         ZTwdghWsX0bRyaXOG/NvdDMOiLCsQ/ibF201a9Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qifu Zhang <zhangqifu@bytedance.com>,
        Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 021/158] Documentation: ACPI: EINJ: Fix obsolete example
Date:   Tue, 23 Aug 2022 10:25:53 +0200
Message-Id: <20220823080046.936596544@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qifu Zhang <zhangqifu@bytedance.com>

commit 9066e151c37950af92c3be6a7270daa8e8063db9 upstream.

Since commit 488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), the EINJ debugfs interface no longer accepts
negative values as input. Attempt to do so will result in EINVAL.

Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Qifu Zhang <zhangqifu@bytedance.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/firmware-guide/acpi/apei/einj.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/firmware-guide/acpi/apei/einj.rst
+++ b/Documentation/firmware-guide/acpi/apei/einj.rst
@@ -168,7 +168,7 @@ An error injection example::
   0x00000008	Memory Correctable
   0x00000010	Memory Uncorrectable non-fatal
   # echo 0x12345000 > param1		# Set memory address for injection
-  # echo $((-1 << 12)) > param2		# Mask 0xfffffffffffff000 - anywhere in this page
+  # echo 0xfffffffffffff000 > param2		# Mask - anywhere in this page
   # echo 0x8 > error_type			# Choose correctable memory error
   # echo 1 > error_inject			# Inject now
 


