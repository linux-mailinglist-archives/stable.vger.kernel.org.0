Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2587B548776
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380840AbiFMODH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380851AbiFMOCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:02:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3BC8E18C;
        Mon, 13 Jun 2022 04:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AFA612AC;
        Mon, 13 Jun 2022 11:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233CBC34114;
        Mon, 13 Jun 2022 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120292;
        bh=ESJOXc+ulgUDWDeGKaExj2KeP38AFg76sXrosl5PjqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEP5UoulzWNunN4RrukIYGNzdMyrmAEBM3FdO7olRgEspP3QM2er0Ay4k2by/d7o+
         CWWMiXaFVZEfZEuvN8E9kj6qpd7kII7mTJc96/c988tTId3DZ732J/dMOEejWyDIpR
         h6mGXE5pfLbwWE5Axg6c8jdmVCSWudZOI/w6UD6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Olivier Matz <olivier.matz@6wind.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.18 320/339] ixgbe: fix bcast packets Rx on VF after promisc removal
Date:   Mon, 13 Jun 2022 12:12:25 +0200
Message-Id: <20220613094936.453729811@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Matz <olivier.matz@6wind.com>

commit 803e9895ea2b0fe80bc85980ae2d7a7e44037914 upstream.

After a VF requested to remove the promiscuous flag on an interface, the
broadcast packets are not received anymore. This breaks some protocols
like ARP.

In ixgbe_update_vf_xcast_mode(), we should keep the IXGBE_VMOLR_BAM
bit (Broadcast Accept) on promiscuous removal.

This flag is already set by default in ixgbe_set_vmolr() on VF reset.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1184,9 +1184,9 @@ static int ixgbe_update_vf_xcast_mode(st
 
 	switch (xcast_mode) {
 	case IXGBEVF_XCAST_MODE_NONE:
-		disable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
+		disable = IXGBE_VMOLR_ROMPE |
 			  IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-		enable = 0;
+		enable = IXGBE_VMOLR_BAM;
 		break;
 	case IXGBEVF_XCAST_MODE_MULTI:
 		disable = IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;


