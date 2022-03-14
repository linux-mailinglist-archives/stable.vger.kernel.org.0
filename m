Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284BC4D8349
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiCNMMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiCNMI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43804FC40;
        Mon, 14 Mar 2022 05:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56BC2B80DF4;
        Mon, 14 Mar 2022 12:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED36EC340ED;
        Mon, 14 Mar 2022 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259541;
        bh=0GaHM71WTvRwvmUjyN6LM1irv0B9SFZIfrhRf36MkOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UW9XvAmgvmtJgbcsjrQdab6YaXkzPg7SYjm5EZ/+jHnVWhj+EbBlJP/1Y09HcgZkU
         t9ahWP5R+dbn4wLl2MhTFU8XcLtme3oMuTk5r3/GSS94XERNN0rHn1xhb0bmfdGPPp
         qKX4z/soSXY1sWKZhoMLG2Iiz/WyfDS45bRR/G98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/110] ice: stop disabling VFs due to PF error responses
Date:   Mon, 14 Mar 2022 12:53:32 +0100
Message-Id: <20220314112743.877476780@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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
index 4054adb5279c..4338e4ff7e85 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2234,24 +2234,6 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 
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
index a750e9a9d712..532f57f01467 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -14,7 +14,6 @@
 #define ICE_MAX_MACADDR_PER_VF		18
 
 /* Malicious Driver Detection */
-#define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
 #define ICE_MDD_EVENTS_THRESHOLD		30
 
 /* Static VF transaction/status register def */
@@ -107,8 +106,6 @@ struct ice_vf {
 	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 
-	u64 num_inval_msgs;		/* number of continuous invalid msgs */
-	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
-- 
2.34.1



