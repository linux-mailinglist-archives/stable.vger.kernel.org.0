Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E8A54A66B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354554AbiFNCZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355263AbiFNCYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4D940E76;
        Mon, 13 Jun 2022 19:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C385BB816AF;
        Tue, 14 Jun 2022 02:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA11C385A5;
        Tue, 14 Jun 2022 02:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172653;
        bh=PW9Uc52kYeo+JHHe0JnPlr9wT9JEcdBrvx+CeZ24egk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYLdGz3qkVkdfNuk506xM7uzfmbTcqGIR/S0LCUIq5Ktf4521R02YLvJ3O2FJewv+
         GA1iW1/QqOqbD3+NImEQyQT+xJEO0aUfe6/EXWmFOhP1bDz303qmK+y+DdsvfvbBCz
         XdNy2H51FqtsZSi7M/I5LGC88pF8c/JFrMuvXKkFwG96M5S15hQ1dvSFf51e0eQKaL
         eZMVWZLrS3f7vAM9b/XMGcyNHApNze8lMg6k3pgfv1jf8g1d+mG5uJqECNQgIEs74V
         V18wEs5Dl+0C9ktkTjzBycoBj6WFuzGRbaC0h5EqHfc3JsMeJaDC4cC33vMkvK8V6a
         UCTSh0hM1ORxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao Wang <wwentao@vmware.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jgill@vmware.com,
        pv-drivers@vmware.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/12] scsi: vmw_pvscsi: Expand vcpuHint to 16 bits
Date:   Mon, 13 Jun 2022 22:10:35 -0400
Message-Id: <20220614021040.1101131-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021040.1101131-1-sashal@kernel.org>
References: <20220614021040.1101131-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d41292ef85f2..98ad17cb6643 100644
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

