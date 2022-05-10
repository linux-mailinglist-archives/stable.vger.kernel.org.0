Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6A521A2D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbiEJNyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbiEJNwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7299B29B807;
        Tue, 10 May 2022 06:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A486193C;
        Tue, 10 May 2022 13:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E8DC385A6;
        Tue, 10 May 2022 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189889;
        bh=JAHRXEIWY8lxKD+wFjsb89waQRDNc35/078AmjBzWLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUZOg+bQFcqeiIAYTu8E4uPiewTXrZtuUPB9d3ZP4JLPEiS4Ob/HkJJ9HC5gkqrhn
         soHBrGrfFzv1e/ZZ3rRUa4YJNuUs562WwOo93EvMSPzpJ+rRJvusf7V5XJfgNfgSh2
         1pmM0iRtXVG/D1LMl+BGWk60xYLX74ugsj23/sUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.17 061/140] iommu/vt-d: Drop stop marker messages
Date:   Tue, 10 May 2022 15:07:31 +0200
Message-Id: <20220510130743.363788473@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit da8669ff41fa31573375c9a4180f5c080677204b upstream.

The page fault handling framework in the IOMMU core explicitly states
that it doesn't handle PCI PASID Stop Marker and the IOMMU drivers must
discard them before reporting faults. This handles Stop Marker messages
in prq_event_thread() before reporting events to the core.

The VT-d driver explicitly drains the pending page requests when a CPU
page table (represented by a mm struct) is unbound from a PASID according
to the procedures defined in the VT-d spec. The Stop Marker messages do
not need a response. Hence, it is safe to drop the Stop Marker messages
silently if any of them is found in the page request queue.

Fixes: d5b9e4bfe0d88 ("iommu/vt-d: Report prq to io-pgfault framework")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20220421113558.3504874-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20220423082330.3897867-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -956,6 +956,10 @@ bad_req:
 			goto bad_req;
 		}
 
+		/* Drop Stop Marker message. No need for a response. */
+		if (unlikely(req->lpig && !req->rd_req && !req->wr_req))
+			goto prq_advance;
+
 		if (!svm || svm->pasid != req->pasid) {
 			/*
 			 * It can't go away, because the driver is not permitted


