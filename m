Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C522A53CF29
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbiFCRyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9565B0;
        Fri,  3 Jun 2022 10:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09C560EE9;
        Fri,  3 Jun 2022 17:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0F1C385A9;
        Fri,  3 Jun 2022 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278667;
        bh=DdcTsahpMA3mopHeABHUdvpDhh4i1FgDJdxIWWBmhHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gphYyYLtbjedEeryDiSVeIGtXqFf2Jyi/7oA3Bk9ljne8tttOjOw1R4je7C4seUdF
         4Mw3CHsZlyQ6p7GYZ4aXlrIYQqu60RWo+xz796qG9BAW7swYts1MKqmc+VSbL9Dj8L
         au/RVVUhhdpEb7JuKMXdi9eaV2qIrE0nm3D53E9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>
Subject: [PATCH 5.15 54/66] x86/sgx: Ensure no data in PCMD page after truncate
Date:   Fri,  3 Jun 2022 19:43:34 +0200
Message-Id: <20220603173822.222435530@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
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

commit e3a3bbe3e99de73043a1d32d36cf4d211dc58c7e upstream.

A PCMD (Paging Crypto MetaData) page contains the PCMD
structures of enclave pages that have been encrypted and
moved to the shmem backing store. When all enclave pages
sharing a PCMD page are loaded in the enclave, there is no
need for the PCMD page and it can be truncated from the
backing store.

A few issues appeared around the truncation of PCMD pages. The
known issues have been addressed but the PCMD handling code could
be made more robust by loudly complaining if any new issue appears
in this area.

Add a check that will complain with a warning if the PCMD page is not
actually empty after it has been truncated. There should never be data
in the PCMD page at this point since it is was just checked to be empty
and truncated with enclave mutex held and is updated with the
enclave mutex held.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/6495120fed43fafc1496d09dd23df922b9a32709.1652389823.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/encl.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -187,12 +187,20 @@ static int __sgx_encl_eldu(struct sgx_en
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
+	get_page(b.pcmd);
 	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page))
+	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page)) {
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+		pcmd_page = kmap_atomic(b.pcmd);
+		if (memchr_inv(pcmd_page, 0, PAGE_SIZE))
+			pr_warn("PCMD page not empty after truncate.\n");
+		kunmap_atomic(pcmd_page);
+	}
+
+	put_page(b.pcmd);
 
 	return ret;
 }


