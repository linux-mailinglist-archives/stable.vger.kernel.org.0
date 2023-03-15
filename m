Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E847C6BB27C
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjCOMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjCOMgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F12A0F1B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92A0361D7E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87E8C4339B;
        Wed, 15 Mar 2023 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883719;
        bh=QdM6oYw6C2NIT+nA1L+81ZmqARfeuUVYYh3ExZe8Vtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guzoZWwqelh5qDcOAlzTSuUCEl+mpUfoQgo+vDVzTpCFRKfoR33T8iaKiA3GT6Ll6
         /F/+QZy7ID8mU95PRgtnut1gcgZYVz07zXVKeSE/3b8ploK+HClrtzxCMQDo5uFWvD
         AEt6AxY8w9NDYJYXDeRjr/PTf8JbNJcUN6dcmxt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/143] ethernet: ice: avoid gcc-9 integer overflow warning
Date:   Wed, 15 Mar 2023 13:13:11 +0100
Message-Id: <20230315115743.692725337@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8f5c5a790e3025d6eca96bf7ee5e3873dc92373f ]

With older compilers like gcc-9, the calculation of the vlan
priority field causes a false-positive warning from the byteswap:

In file included from drivers/net/ethernet/intel/ice/ice_tc_lib.c:4:
drivers/net/ethernet/intel/ice/ice_tc_lib.c: In function 'ice_parse_cls_flower':
include/uapi/linux/swab.h:15:15: error: integer overflow in expression '(int)(short unsigned int)((int)match.key-><U67c8>.<U6698>.vlan_priority << 13) & 57344 & 255' of type 'int' results in '0' [-Werror=overflow]
   15 |  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
      |   ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
include/uapi/linux/swab.h:106:2: note: in expansion of macro '___constant_swab16'
  106 |  ___constant_swab16(x) :   \
      |  ^~~~~~~~~~~~~~~~~~
include/uapi/linux/byteorder/little_endian.h:42:43: note: in expansion of macro '__swab16'
   42 | #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
      |                                           ^~~~~~~~
include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
   96 | #define cpu_to_be16 __cpu_to_be16
      |                     ^~~~~~~~~~~~~
drivers/net/ethernet/intel/ice/ice_tc_lib.c:1458:5: note: in expansion of macro 'cpu_to_be16'
 1458 |     cpu_to_be16((match.key->vlan_priority <<
      |     ^~~~~~~~~~~

After a change to be16_encode_bits(), the code becomes more
readable to both people and compilers, which avoids the warning.

Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index f68c555be4e9a..71cb15fcf63b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1322,8 +1322,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
 			headers->vlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 
 		if (match.mask->vlan_tpid)
@@ -1356,8 +1356,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
 			headers->cvlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 	}
 
-- 
2.39.2



