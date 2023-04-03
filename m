Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988E06D499C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjDCOji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbjDCOjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA17535010
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3278ACE12EB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2AFC433D2;
        Mon,  3 Apr 2023 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532766;
        bh=Y2i4hsHkNEO+l9DIkKNVBrIeO+hNy8N3Mnfvxx7tVjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVni+YMuKu8gChgtWB3F9/fuOrhEigFwB4ouRFv7y/im+9PK080Go/lsLDrgqIzur
         AVFtubJzNIntBCkMC4QXUgsgeZRw2FliSvrAwiSdH4NmyfVbJCWLSe/hLwDhOEwAm+
         JVhVX9DIgTfwkxwC2iuw1UBRadJYIvrcs51yk9yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Junfeng Guo <junfeng.guo@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/181] ice: add profile conflict check for AVF FDIR
Date:   Mon,  3 Apr 2023 16:09:03 +0200
Message-Id: <20230403140418.616762805@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junfeng Guo <junfeng.guo@intel.com>

[ Upstream commit 29486b6df3e6a63b57d1ed1dce06051267282ff4 ]

Add profile conflict check while adding some FDIR rules to avoid
unexpected flow behavior, rules may have conflict including:
        IPv4 <---> {IPv4_UDP, IPv4_TCP, IPv4_SCTP}
        IPv6 <---> {IPv6_UDP, IPv6_TCP, IPv6_SCTP}

For example, when we create an FDIR rule for IPv4, this rule will work
on packets including IPv4, IPv4_UDP, IPv4_TCP and IPv4_SCTP. But if we
then create an FDIR rule for IPv4_UDP and then destroy it, the first
FDIR rule for IPv4 cannot work on pkt IPv4_UDP then.

To prevent this unexpected behavior, we add restriction in software
when creating FDIR rules by adding necessary profile conflict check.

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index c6a58343d81d8..a2645ff3100e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -541,6 +541,72 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_has_prof_conflict
+ * @vf: pointer to the VF structure
+ * @conf: FDIR configuration for each filter
+ *
+ * Check if @conf has conflicting profile with existing profiles
+ *
+ * Return: true on success, and false on error.
+ */
+static bool
+ice_vc_fdir_has_prof_conflict(struct ice_vf *vf,
+			      struct virtchnl_fdir_fltr_conf *conf)
+{
+	struct ice_fdir_fltr *desc;
+
+	list_for_each_entry(desc, &vf->fdir.fdir_rule_list, fltr_node) {
+		struct virtchnl_fdir_fltr_conf *existing_conf;
+		enum ice_fltr_ptype flow_type_a, flow_type_b;
+		struct ice_fdir_fltr *a, *b;
+
+		existing_conf = to_fltr_conf_from_desc(desc);
+		a = &existing_conf->input;
+		b = &conf->input;
+		flow_type_a = a->flow_type;
+		flow_type_b = b->flow_type;
+
+		/* No need to compare two rules with different tunnel types or
+		 * with the same protocol type.
+		 */
+		if (existing_conf->ttype != conf->ttype ||
+		    flow_type_a == flow_type_b)
+			continue;
+
+		switch (flow_type_a) {
+		case ICE_FLTR_PTYPE_NONF_IPV4_UDP:
+		case ICE_FLTR_PTYPE_NONF_IPV4_TCP:
+		case ICE_FLTR_PTYPE_NONF_IPV4_SCTP:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_OTHER)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV4_SCTP)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV6_UDP:
+		case ICE_FLTR_PTYPE_NONF_IPV6_TCP:
+		case ICE_FLTR_PTYPE_NONF_IPV6_SCTP:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_OTHER)
+				return true;
+			break;
+		case ICE_FLTR_PTYPE_NONF_IPV6_OTHER:
+			if (flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_UDP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_TCP ||
+			    flow_type_b == ICE_FLTR_PTYPE_NONF_IPV6_SCTP)
+				return true;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
 /**
  * ice_vc_fdir_write_flow_prof
  * @vf: pointer to the VF structure
@@ -677,6 +743,13 @@ ice_vc_fdir_config_input_set(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 	enum ice_fltr_ptype flow;
 	int ret;
 
+	ret = ice_vc_fdir_has_prof_conflict(vf, conf);
+	if (ret) {
+		dev_dbg(dev, "Found flow profile conflict for VF %d\n",
+			vf->vf_id);
+		return ret;
+	}
+
 	flow = input->flow_type;
 	ret = ice_vc_fdir_alloc_prof(vf, flow);
 	if (ret) {
-- 
2.39.2



