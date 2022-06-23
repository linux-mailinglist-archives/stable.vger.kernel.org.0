Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00125586A8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiFWSQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiFWSP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:15:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A20822528;
        Thu, 23 Jun 2022 10:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8594B824BD;
        Thu, 23 Jun 2022 17:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CFBC3411B;
        Thu, 23 Jun 2022 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004912;
        bh=gwmf6peLKhueY78cBZXQsHDQ+B2rOr5tX1pQlxSjuXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pf+GVt/fLHT743LYjnHfsWT9pzb/34ee9kWpn5JaVHRo44+r05uYidR8U/KnEIzDH
         BvRZ2inVLO1M6JJinN9qUqRM57n/qO05TvzMU+VqVAayv0YRZ5LtcpzhtgLZgnnDbv
         LFg2T+fbxl0LfN2J3CaRMx7Df18g8PT4UCKbXhIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wentao Wang <wwentao@vmware.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/234] scsi: vmw_pvscsi: Expand vcpuHint to 16 bits
Date:   Thu, 23 Jun 2022 18:44:17 +0200
Message-Id: <20220623164348.425130366@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wentao Wang <wwentao@vmware.com>

[ Upstream commit cf71d59c2eceadfcde0fb52e237990a0909880d7 ]

vcpuHint has been expanded to 16 bit on host to enable routing to more
CPUs. Guest side should align with the change. This change has been tested
with hosts with 8-bit and 16-bit vcpuHint, on both platforms host side can
get correct value.

Link: https://lore.kernel.org/r/EF35F4D5-5DCC-42C5-BCC4-29DF1729B24C@vmware.com
Signed-off-by: Wentao Wang <wwentao@vmware.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/vmw_pvscsi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 75966d3f326e..d87c12324c03 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -333,8 +333,8 @@ struct PVSCSIRingReqDesc {
 	u8	tag;
 	u8	bus;
 	u8	target;
-	u8	vcpuHint;
-	u8	unused[59];
+	u16	vcpuHint;
+	u8	unused[58];
 } __packed;
 
 /*
-- 
2.35.1



