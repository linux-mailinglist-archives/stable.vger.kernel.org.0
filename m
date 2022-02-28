Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818D04C7610
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiB1R7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbiB1R5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:57:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C45A2DD50;
        Mon, 28 Feb 2022 09:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EF43B81187;
        Mon, 28 Feb 2022 17:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A64C340E7;
        Mon, 28 Feb 2022 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070291;
        bh=+3NWXV/ij98gyzbua8DxAV20vrwUsHuHwyrxkfxw58Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqa+MX/1X5PWrsFf0tHp6cGyzRTDhPgC47JlZpleaM6N304VMq2QIZ1v38Vb0kF24
         Kf662XIb/mqleDdYO0ScJ9f2sTMbqAS7QWxOay06Za4sXcn+vb2isDeQG06ezggthM
         6yYmyAgrZIGBz80x3aVR6u4yKet56Kcmdg77xPsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.16 054/164] ice: initialize local variable tlv
Date:   Mon, 28 Feb 2022 18:23:36 +0100
Message-Id: <20220228172405.047717439@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 5950bdc88dd1d158f2845fdff8fb1de86476806c upstream.

Clang static analysis reports this issues
ice_common.c:5008:21: warning: The left expression of the compound
  assignment is an uninitialized value. The computed value will
  also be garbage
  ldo->phy_type_low |= ((u64)buf << (i * 16));
  ~~~~~~~~~~~~~~~~~ ^

When called from ice_cfg_phy_fec() ldo is the uninitialized local
variable tlv.  So initialize.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3319,7 +3319,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi
 
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
-		struct ice_link_default_override_tlv tlv;
+		struct ice_link_default_override_tlv tlv = { 0 };
 
 		status = ice_get_link_default_override(&tlv, pi);
 		if (status)


