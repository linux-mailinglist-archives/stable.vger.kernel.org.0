Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D755013B8
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347544AbiDNODv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346217AbiDNN4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9565A098;
        Thu, 14 Apr 2022 06:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B357B828E6;
        Thu, 14 Apr 2022 13:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9548EC385A1;
        Thu, 14 Apr 2022 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943962;
        bh=kaBfcwaEPG0w9QfQXaAFjfZgMRuMBTfVid4mHf1EyPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blR3CNzJC63HQzp/ZWy8zJENaJ51f5/nYKuPp+j6lQu4Ut0mrFaUkWMD5OhRKsmx7
         vBwxwJFe7eOcufu/t5UBKUXBBAPN3HhBQH4lvYrLVDwzugEFBdqxBSs2kbzeuPW/zD
         6mLcRZtlDJuoxfp6oLDzv27yneV+dZ/Ar6QfMS6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 343/475] net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware
Date:   Thu, 14 Apr 2022 15:12:08 +0200
Message-Id: <20220414110904.681017496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Guangbin Huang <huangguangbin2@huawei.com>

commit 7ed258f12ec5ce855f15cdfb5710361dc82fe899 upstream.

When user delete vlan 0, as driver will not delete vlan 0 for hardware in
function hclge_set_vlan_filter_hw(), so vlan 0 in software vlan talbe should
not be deleted.

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8344,11 +8344,11 @@ int hclge_set_vlan_filter(struct hnae3_h
 	}
 
 	if (!ret) {
-		if (is_kill)
-			hclge_rm_vport_vlan_table(vport, vlan_id, false);
-		else
+		if (!is_kill)
 			hclge_add_vport_vlan_table(vport, vlan_id,
 						   writen_to_tbl);
+		else if (is_kill && vlan_id != 0)
+			hclge_rm_vport_vlan_table(vport, vlan_id, false);
 	} else if (is_kill) {
 		/* when remove hw vlan filter failed, record the vlan id,
 		 * and try to remove it from hw later, to be consistence


