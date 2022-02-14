Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB894B4C47
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348663AbiBNKjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:39:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348645AbiBNKhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:37:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50277A888D;
        Mon, 14 Feb 2022 02:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A058060C8A;
        Mon, 14 Feb 2022 10:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A78C340E9;
        Mon, 14 Feb 2022 10:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833002;
        bh=NOLA5kg11otvmBJsW+m0RL1uhgYczBCkkn/7e1ziXuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTcYYA/gc7HM/5p9jskP06/PPyJy4ipvhj//Xg/u+VhlLwtC267VZ7fqfNLd6Ys8M
         5KSKBIonGTA6bqTXYUvDZ77hf/6GAXjDRBdvMvblxxmD6pQTu10cfJZnDZtRyFjjXe
         6G8APY2YoMFwStX+F13fpn21+lFdCOnWTj+XH8dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.16 193/203] x86/sgx: Silence softlockup detection when releasing large enclaves
Date:   Mon, 14 Feb 2022 10:27:17 +0100
Message-Id: <20220214092516.943836506@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit 8795359e35bc33bf86b6d0765aa7f37431db3b9c upstream.

Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
triggers the softlockup detector.

Actual SGX systems have 128GB of enclave memory or more.  The
"unclobbered_vdso_oversubscribed" selftest creates one enclave which
consumes all of the enclave memory on the system. Tearing down such a
large enclave takes around a minute, most of it in the loop where
the EREMOVE instruction is applied to each individual 4k enclave page.

Spending one minute in a loop triggers the softlockup detector.

Add a cond_resched() to give other tasks a chance to run and placate
the softlockup detector.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>  (kselftest as sanity check)
Link: https://lkml.kernel.org/r/ced01cac1e75f900251b0a4ae1150aa8ebd295ec.1644345232.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -410,6 +410,8 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
+		/* Invoke scheduler to prevent soft lockups. */
+		cond_resched();
 	}
 
 	xa_destroy(&encl->page_array);


