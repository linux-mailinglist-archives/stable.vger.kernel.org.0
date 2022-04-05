Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB24F2B18
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiDEIyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241062AbiDEIcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090BB91A6;
        Tue,  5 Apr 2022 01:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8AB86117D;
        Tue,  5 Apr 2022 08:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0567AC385A1;
        Tue,  5 Apr 2022 08:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147190;
        bh=YbwfK3n1g59Ka5Cp7SEaBOTGe7h8cOzjzd41fU7Ajow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwM6B0Q3ctQkrGuNWZphQ1mp4Nu/wBuibuGjpLJK3oA9rGrL4NS8kG3jiiWvTzUZw
         B0EHwzb5508oXp4xVQ07AR6UOVI9cDOI1j3UObb3uaJf3ZNJSqLhZM+f46asrwexW4
         qPB9vb2LQa/f9zyL0+tv0bnHhUZ4BQeTCAuy9OaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 1033/1126] net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware
Date:   Tue,  5 Apr 2022 09:29:40 +0200
Message-Id: <20220405070437.798067423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -10314,11 +10314,11 @@ int hclge_set_vlan_filter(struct hnae3_h
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


