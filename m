Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA3F6895D1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjBCKVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjBCKVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A5D9EE07
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F28761ECA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA89C433EF;
        Fri,  3 Feb 2023 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419642;
        bh=NpIcMv6liOdVHf2PZXzPDLHYoNp54e/OD+2ATZPye6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nY6TJJlv32tNuUt+HgSnJcfFbVzx355Y1GrUVfdN4U+eyECfZptIflDueewL+qXJU
         ySsnhg1iBZZxT5GHyxqPzFQ8Q8BsX/949/Up+ygggPPIAMjBLlmlHyAXHtAveQXJA3
         tegLuROhoZnU8OTMlf2kaT1RFMkxTAZLI1U6SLGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 70/80] ia64: make IA64_MCA_RECOVERY bool instead of tristate
Date:   Fri,  3 Feb 2023 11:13:04 +0100
Message-Id: <20230203101018.227499813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit dbecf9b8b8ce580f4e11afed9d61e8aa294cddd2 upstream.

In linux-next, IA64_MCA_RECOVERY uses the (new) function
make_task_dead(), which is not exported for use by modules.  Instead of
exporting it for one user, convert IA64_MCA_RECOVERY to be a bool
Kconfig symbol.

In a config file from "kernel test robot <lkp@intel.com>" for a
different problem, this linker error was exposed when
CONFIG_IA64_MCA_RECOVERY=m.

Fixes this build error:

  ERROR: modpost: "make_task_dead" [arch/ia64/kernel/mca_recovery.ko] undefined!

Link: https://lkml.kernel.org/r/20220124213129.29306-1-rdunlap@infradead.org
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -445,7 +445,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config PERFMON
 	bool "Performance monitor support"


