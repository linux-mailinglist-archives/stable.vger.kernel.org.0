Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6465B100
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjABL3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbjABL3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327BB5FA3
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1AAD60F59
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6DCC433D2;
        Mon,  2 Jan 2023 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658917;
        bh=RBkTt8QNg2ZO1olscYqpcA9tJe+hT/P+gMH3HMG0A9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6iqw53ZGPrI0FR5vElybz2jykCSeG5Br7Sc1hmLuD0fT4OwCokYbCsVF8STm+Mvw
         LUJ22rPYnWM77Of5AihHtjy8m6s8PlQsrK3wMKjM9744m58Vban8g2kC3NpgSuusrs
         nLWxoV7/WzFNCTasMocjZO3IYUf+8pVHpBAblXl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 49/74] mm/mempolicy: fix memory leak in set_mempolicy_home_node system call
Date:   Mon,  2 Jan 2023 12:22:22 +0100
Message-Id: <20230102110554.172194568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 38ce7c9bdfc228c14d7621ba36d3eebedd9d4f76 upstream.

When encountering any vma in the range with policy other than MPOL_BIND or
MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put on
the policy just allocated with mpol_dup().

This allows arbitrary users to leak kernel memory.

Link: https://lkml.kernel.org/r/20221215194621.202816-1-mathieu.desnoyers@efficios.com
Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1525,6 +1525,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		 * the home node for vmas we already updated before.
 		 */
 		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+			mpol_put(new);
 			err = -EOPNOTSUPP;
 			break;
 		}


