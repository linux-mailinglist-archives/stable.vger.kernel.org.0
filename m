Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6424053D0E5
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346529AbiFCSHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiFCSGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95955D1AB;
        Fri,  3 Jun 2022 10:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52537615DA;
        Fri,  3 Jun 2022 17:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B5FC385A9;
        Fri,  3 Jun 2022 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279083;
        bh=jRGYaec2MuAtdgELoc6FWEItHG4GgkCI+meBt12+l9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsrkXD4kjOcfLxqzJp5E/O0swCCGzx2AFpV/Rrpm86BtjUMxz5eiIM4qsexG1kIY3
         ULAGv8k6J4KrN2WeD+zZxEFJAAjgWwzQwYAuksx0j9nY7k/oU957H/WmW+0iBEJfIU
         wSnxiptXFDQacP7xZg1Mm2qNXQ9ZvlVLymZSiC7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>
Subject: [PATCH 5.18 48/67] x86/sgx: Mark PCMD page as dirty when modifying contents
Date:   Fri,  3 Jun 2022 19:43:49 +0200
Message-Id: <20220603173822.114047536@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit 2154e1c11b7080aa19f47160bd26b6f39bbd7824 upstream.

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") expanded __sgx_encl_eldu()
to clear an enclave page's PCMD (Paging Crypto MetaData)
from the PCMD page in the backing store after the enclave
page is restored to the enclave.

Since the PCMD page in the backing store is modified the page
should be marked as dirty to ensure the modified data is retained.

Cc: stable@vger.kernel.org
Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/00cd2ac480db01058d112e347b32599c1a806bc4.1652389823.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -84,6 +84,7 @@ static int __sgx_encl_eldu(struct sgx_en
 	}
 
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+	set_page_dirty(b.pcmd);
 
 	/*
 	 * The area for the PCMD in the page was zeroed above.  Check if the


