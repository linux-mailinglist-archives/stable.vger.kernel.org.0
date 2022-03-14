Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC84D825B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbiCNMDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240223AbiCNMCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFA949FBC;
        Mon, 14 Mar 2022 04:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8530661297;
        Mon, 14 Mar 2022 11:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41636C340EC;
        Mon, 14 Mar 2022 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259163;
        bh=uH+9wUozafbkU8hZyLgzaileE4CqzDonFw9tNkZ91r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opNnZS84ZEMUgcS+JWJvoF34k6TNx7XVbT6n06FLoA6jUuRKLvFkFo2gvOulHnyH/
         73rIBdnA3J9u2ufa0qTHs73nZ6E+Wx1peivePeaf7vIiJIx011vaQCxqMKHkFDpBG+
         1nMqETTwAQ4qULsE12xqBngL1IEUCRy6CSeRXYIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/71] ice: stop disabling VFs due to PF error responses
Date:   Mon, 14 Mar 2022 12:53:10 +0100
Message-Id: <20220314112738.415508406@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 79498d5af8e458102242d1667cf44df1f1564e63 ]

The ice_vc_send_msg_to_vf function has logic to detect "failure"
responses being sent to a VF. If a VF is sent more than
ICE_DFLT_NUM_INVAL_MSGS_ALLOWED then the VF is marked as disabled.
Almost identical logic also existed in the i40e driver.

This logic was added to the ice driver in commit 1071a8358a28 ("ice:
Implement virtchnl commands for AVF support") which itself copied from
the i40e implementation in commit 5c3c48ac6bf5 ("i40e: implement virtual
device interface").

Neither commit provides a proper explanation or justification of the
check. In fact, later commits to i40e changed the logic to allow
bypassing the check in some specific instances.

The "logic" for this seems to be that error responses somehow indicate a
malicious VF. This is not really true. The PF might be sending an error
for any number of reasons such as lack of resources, etc.

Additionally, this causes the PF to log an info message for every failed
VF response which may confuse users, and can spam the kernel log.

This behavior is not documented as part of any requirement for our
products and other operating system drivers such as the FreeBSD
implementation of our drivers do not include this type of check.

In fact, the change from dev_err to dev_info in i40e commit 18b7af57d9c1
("i40e: Lower some message levels") explains that these messages
typically don't actually indicate a real issue. It is quite likely that
a user who hits this in practice will be very confused as the VF will be
disabled without an obvious way to recover.

We already have robust malicious driver detection logic using actual
hardware detection mechanisms that detect and prevent invalid device
usage. Remove the logic since its not a documented requirement and the
behavior is not intuitive.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c   | 18 ------------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h   |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 48511ad0e0c8..5134342ff70f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1849,24 +1849,6 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 
 	dev = ice_pf_to_dev(pf);
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval) {
-		vf->num_inval_msgs++;
-		dev_info(dev, "VF %d failed opcode %d, retval: %d\n", vf->vf_id,
-			 v_opcode, v_retval);
-		if (vf->num_inval_msgs > ICE_DFLT_NUM_INVAL_MSGS_ALLOWED) {
-			dev_err(dev, "Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-			return -EIO;
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_inval_msgs = 0;
-	}
-
 	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
 				       msg, msglen, NULL);
 	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 59e5b4f16e96..d2e935c678a1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -13,7 +13,6 @@
 #define ICE_MAX_MACADDR_PER_VF		18
 
 /* Malicious Driver Detection */
-#define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
 #define ICE_MDD_EVENTS_THRESHOLD		30
 
 /* Static VF transaction/status register def */
@@ -97,8 +96,6 @@ struct ice_vf {
 	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 
-	u64 num_inval_msgs;		/* number of continuous invalid msgs */
-	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
-- 
2.34.1



