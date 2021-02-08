Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C853C313793
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhBHP1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233777AbhBHPWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D3E64F04;
        Mon,  8 Feb 2021 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797231;
        bh=HPgQTE1rrVEdPU+w3ivKoRwp3o4alHbSAUuORaMcYRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqNAowDs19OSoN2Dy4qrXRxmVw4bhpjuC3FZ9ESbesIzrJnucDJ1h939iAkvZCO1G
         Y2i+Xs9eEBFrjqC6i8QSTAkWnJg5D13424q8UNKAjRpu5PNhZSMHdAAl0bkq5ivNCz
         nchEFcreIMwU/VV0LKSfzxckjxEPP4zH58bGXC7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/120] i40e: Revert "i40e: dont report link up for a VF who hasnt enabled queues"
Date:   Mon,  8 Feb 2021 16:00:25 +0100
Message-Id: <20210208145819.933681429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit f559a356043a55bab25a4c00505ea65c50a956fb ]

This reverts commit 2ad1274fa35ace5c6360762ba48d33b63da2396c

VF queues were not brought up when PF was brought up after being
downed if the VF driver disabled VFs queues during PF down.
This could happen in some older or external VF driver implementations.
The problem was that PF driver used vf->queues_enabled as a condition
to decide what link-state it would send out which caused the issue.

Remove the check for vf->queues_enabled in the VF link notify.
Now VF will always be notified of the current link status.
Also remove the queues_enabled member from i40e_vf structure as it is
not used anymore. Otherwise VNF implementation was broken and caused
a link flap.

The original commit was a workaround to avoid breaking existing VFs though
it's really a fault of the VF code not the PF. The commit should be safe to
revert as all of the VFs we know of have been fixed. Also, since we now
know there is a related bug in the workaround, removing it is preferred.

Fixes: 2ad1274fa35a ("i40e: don't report link up for a VF who hasn't enabled")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 13 +------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2872c4dc77f07..3b269c70dcfe1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -55,12 +55,7 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
-
-	/* Always report link is down if the VF queues aren't enabled */
-	if (!vf->queues_enabled) {
-		pfe.event_data.link_event.link_status = false;
-		pfe.event_data.link_event.link_speed = 0;
-	} else if (vf->link_forced) {
+	if (vf->link_forced) {
 		pfe.event_data.link_event.link_status = vf->link_up;
 		pfe.event_data.link_event.link_speed =
 			(vf->link_up ? VIRTCHNL_LINK_SPEED_40GB : 0);
@@ -70,7 +65,6 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 		pfe.event_data.link_event.link_speed =
 			i40e_virtchnl_link_speed(ls->link_speed);
 	}
-
 	i40e_aq_send_msg_to_vf(hw, abs_vf_id, VIRTCHNL_OP_EVENT,
 			       0, (u8 *)&pfe, sizeof(pfe), NULL);
 }
@@ -2443,8 +2437,6 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		}
 	}
 
-	vf->queues_enabled = true;
-
 error_param:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES,
@@ -2466,9 +2458,6 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	/* Immediately mark queues as disabled */
-	vf->queues_enabled = false;
-
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 5491215d81deb..091e32c1bb46f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -98,7 +98,6 @@ struct i40e_vf {
 	unsigned int tx_rate;	/* Tx bandwidth limit in Mbps */
 	bool link_forced;
 	bool link_up;		/* only valid if VF link is forced */
-	bool queues_enabled;	/* true if the VF queues are enabled */
 	bool spoofchk;
 	u16 num_vlan;
 
-- 
2.27.0



