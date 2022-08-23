Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E159E185
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358870AbiHWL5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359293AbiHWL4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:56:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4FAD6BAD;
        Tue, 23 Aug 2022 02:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7B30B81C89;
        Tue, 23 Aug 2022 09:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADA9C433C1;
        Tue, 23 Aug 2022 09:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247250;
        bh=X6jgYWZ4Mu4BRn1XVD+JQfc78HmS4SDy8hx0sB+nn/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwKcA03ErS6NUopAAOpxPiVc4xCzX+H+dcyQsSvtjBCDzu54Crf+8ifhLYduqPXiI
         0ia16yBFIiozkJR3qFvzCyndgyfer57RgUkK/s86FhlxNArGnT3PfKO0ThW1JoulxA
         nYec0ntzDhbwyCBAcHoEBWGLyxObr2gzwvzpexZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 335/389] iavf: Fix adminq error handling
Date:   Tue, 23 Aug 2022 10:26:53 +0200
Message-Id: <20220823080129.510039394@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

commit 419831617ed349992c84344dbd9e627f9e68f842 upstream.

iavf_alloc_asq_bufs/iavf_alloc_arq_bufs allocates with dma_alloc_coherent
memory for VF mailbox.
Free DMA regions for both ASQ and ARQ in case error happens during
configuration of ASQ/ARQ registers.
Without this change it is possible to see when unloading interface:
74626.583369: dma_debug_device_change: device driver has pending DMA allocations while released from device [count=32]
One of leaked entries details: [device address=0x0000000b27ff9000] [size=4096 bytes] [mapped with DMA_BIDIRECTIONAL] [mapped as coherent]

Fixes: d358aa9a7a2d ("i40evf: init code and hardware support")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -324,6 +324,7 @@ static enum iavf_status iavf_config_arq_
 static enum iavf_status iavf_init_asq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
+	int i;
 
 	if (hw->aq.asq.count > 0) {
 		/* queue already initialized */
@@ -354,12 +355,17 @@ static enum iavf_status iavf_init_asq(st
 	/* initialize base registers */
 	ret_code = iavf_config_asq_regs(hw);
 	if (ret_code)
-		goto init_adminq_free_rings;
+		goto init_free_asq_bufs;
 
 	/* success! */
 	hw->aq.asq.count = hw->aq.num_asq_entries;
 	goto init_adminq_exit;
 
+init_free_asq_bufs:
+	for (i = 0; i < hw->aq.num_asq_entries; i++)
+		iavf_free_dma_mem(hw, &hw->aq.asq.r.asq_bi[i]);
+	iavf_free_virt_mem(hw, &hw->aq.asq.dma_head);
+
 init_adminq_free_rings:
 	iavf_free_adminq_asq(hw);
 
@@ -383,6 +389,7 @@ init_adminq_exit:
 static enum iavf_status iavf_init_arq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
+	int i;
 
 	if (hw->aq.arq.count > 0) {
 		/* queue already initialized */
@@ -413,12 +420,16 @@ static enum iavf_status iavf_init_arq(st
 	/* initialize base registers */
 	ret_code = iavf_config_arq_regs(hw);
 	if (ret_code)
-		goto init_adminq_free_rings;
+		goto init_free_arq_bufs;
 
 	/* success! */
 	hw->aq.arq.count = hw->aq.num_arq_entries;
 	goto init_adminq_exit;
 
+init_free_arq_bufs:
+	for (i = 0; i < hw->aq.num_arq_entries; i++)
+		iavf_free_dma_mem(hw, &hw->aq.arq.r.arq_bi[i]);
+	iavf_free_virt_mem(hw, &hw->aq.arq.dma_head);
 init_adminq_free_rings:
 	iavf_free_adminq_arq(hw);
 


