Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8644D53D12D
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiFCSRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347757AbiFCSP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B5C61621;
        Fri,  3 Jun 2022 11:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63ADA61663;
        Fri,  3 Jun 2022 17:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57285C3411D;
        Fri,  3 Jun 2022 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279086;
        bh=h63YL1mZsMLVcspF3UHcpRh8yN21n3CyTPYJb1ZQRIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6gYtk1N5WEV0nyLhGi4HEVhImaYtmRwvT8KhwRwMBz4p/s8Hb1TMCEMJb0jHc0S2
         y+3+rROhcxQI0iZuDZYoBLcAoFzunXJsKVyR4qlpgFJ4JUwHymhf4uyI2REQ7uXQKh
         dGW57/l0OElfUSIa/wPpZ8KYot8F7rx45gTrNd48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haitao Huang <haitao.huang@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.18 49/67] x86/sgx: Obtain backing storage page with enclave mutex held
Date:   Fri,  3 Jun 2022 19:43:50 +0200
Message-Id: <20220603173822.141858221@linuxfoundation.org>
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

commit 0e4e729a830c1e7f31d3b3fbf8feb355a402b117 upstream.

Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
instruction faulting with a #GP.

The WARN is encountered when the reclaimer evicts a range of
pages from the enclave when the same pages are faulted back
right away.

The SGX backing storage is accessed on two paths: when there
are insufficient free pages in the EPC the reclaimer works
to move enclave pages to the backing storage and as enclaves
access pages that have been moved to the backing storage
they are retrieved from there as part of page fault handling.

An oversubscribed SGX system will often run the reclaimer and
page fault handler concurrently and needs to ensure that the
backing store is accessed safely between the reclaimer and
the page fault handler. This is not the case because the
reclaimer accesses the backing store without the enclave mutex
while the page fault handler accesses the backing store with
the enclave mutex.

Consider the scenario where a page is faulted while a page sharing
a PCMD page with the faulted page is being reclaimed. The
consequence is a race between the reclaimer and page fault
handler, the reclaimer attempting to access a PCMD at the
same time it is truncated by the page fault handler. This
could result in lost PCMD data. Data may still be
lost if the reclaimer wins the race, this is addressed in
the following patch.

The reclaimer accesses pages from the backing storage without
holding the enclave mutex and runs the risk of concurrently
accessing the backing storage with the page fault handler that
does access the backing storage with the enclave mutex held.

In the scenario below a PCMD page is truncated from the backing
store after all its pages have been loaded in to the enclave
at the same time the PCMD page is loaded from the backing store
when one of its pages are reclaimed:

sgx_reclaim_pages() {              sgx_vma_fault() {
                                     ...
                                     mutex_lock(&encl->lock);
                                     ...
                                     __sgx_encl_eldu() {
                                       ...
                                       if (pcmd_page_empty) {
/*
 * EPC page being reclaimed              /*
 * shares a PCMD page with an             * PCMD page truncated
 * enclave page that is being             * while requested from
 * faulted in.                            * reclaimer.
 */                                       */
sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
                                        }
                                       mutex_unlock(&encl->lock);
}                                    }

In this scenario there is a race between the reclaimer and the page fault
handler when the reclaimer attempts to get access to the same PCMD page
that is being truncated. This could result in the reclaimer writing to
the PCMD page that is then truncated, causing the PCMD data to be lost,
or in a new PCMD page being allocated. The lost PCMD data may still occur
after protecting the backing store access with the mutex - this is fixed
in the next patch. By ensuring the backing store is accessed with the mutex
held the enclave page state can be made accurate with the
SGX_ENCL_PAGE_BEING_RECLAIMED flag accurately reflecting that a page
is in the process of being reclaimed.

Consistently protect the reclaimer's backing store access with the
enclave's mutex to ensure that it can safely run concurrently with the
page fault handler.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Haitao Huang <haitao.huang@intel.com>
Link: https://lkml.kernel.org/r/fa2e04c561a8555bfe1f4e7adc37d60efc77387b.1652389823.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct s
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
+
+		mutex_lock(&encl_page->encl->lock);
 		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
+		}
 
-		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -413,7 +417,6 @@ skip:
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;


